import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';

import '../models/language.dart';
import '../models/speech_message.dart';
import '../models/transceiver_packet.dart';
import '../services/model_manager_service.dart';
import '../services/p2p_network_service.dart';
import '../services/packet_codec.dart';
import '../services/stt_service.dart';
import '../services/tts_service.dart';
import '../services/vad_service.dart';

class TransceiverController extends ChangeNotifier implements P2pPacketListener, VadListener {
  final ModelManagerService modelManager = ModelManagerService();
  late final SttService sttService;
  late final TtsService ttsService;
  late final VadService vadService;
  late final P2pNetworkService networkService;

  AppLanguage _sourceLanguage = AppLanguage.hindi;
  AppLanguage _targetLanguage = AppLanguage.hindi;
  bool _isPushToTalkMode = true;

  bool _isRecording = false;
  bool _isProcessingStt = false;
  bool _isProcessingTts = false;

  final List<SpeechMessage> _messages = [];
  final List<double> _livePcmAmplitudes = List.filled(30, 0.05);

  ConnectionStatus _connectionStatus = ConnectionStatus.disconnected;
  String? _connectedPeer;

  TransceiverController() {
    sttService = SttService(modelManager);
    ttsService = TtsService(modelManager);
    vadService = VadService();
    networkService = P2pNetworkService();
    networkService.listener = this;

    _initEngines();
  }

  AppLanguage get sourceLanguage => _sourceLanguage;
  AppLanguage get targetLanguage => _targetLanguage;
  bool get isPushToTalkMode => _isPushToTalkMode;
  bool get isRecording => _isRecording;
  bool get isProcessingStt => _isProcessingStt;
  bool get isProcessingTts => _isProcessingTts;
  List<SpeechMessage> get messages => List.unmodifiable(_messages);
  List<double> get livePcmAmplitudes => _livePcmAmplitudes;
  ConnectionStatus get connectionStatus => _connectionStatus;
  String? get connectedPeer => _connectedPeer;

  Future<void> _initEngines() async {
    await sttService.initialize(_sourceLanguage);
    await ttsService.initialize(_targetLanguage);
    notifyListeners();
  }

  void setSourceLanguage(AppLanguage lang) {
    if (_sourceLanguage != lang) {
      _sourceLanguage = lang;
      sttService.initialize(lang);
      notifyListeners();
    }
  }

  void setTargetLanguage(AppLanguage lang) {
    if (_targetLanguage != lang) {
      _targetLanguage = lang;
      ttsService.initialize(lang);
      notifyListeners();
    }
  }

  void setMode(bool isPushToTalk) {
    _isPushToTalkMode = isPushToTalk;
    notifyListeners();
  }

  void startPttRecording() {
    if (_isRecording) return;
    _isRecording = true;
    vadService.reset();
    notifyListeners();
  }

  Future<void> stopPttRecordingAndSend() async {
    if (!_isRecording) return;
    _isRecording = false;
    _isProcessingStt = true;
    notifyListeners();

    final sttStartTime = DateTime.now().millisecondsSinceEpoch;

    final simulatedPcm = Float32List(16000 * 2);
    final text = await sttService.transcribe(simulatedPcm);
    final sttLatency = DateTime.now().millisecondsSinceEpoch - sttStartTime;

    _isProcessingStt = false;
    notifyListeners();

    if (text.isNotEmpty) {
      await _sendTransceiverText(text, sttLatency, simulatedPcm.length * 2);
    }
  }

  Future<void> sendAlertMessage(String text) async {
    if (text.trim().isEmpty) return;
    _isProcessingStt = true;
    notifyListeners();

    final messageId = "ALT_${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}";

    final packetBytes = PacketCodec.encode(
      text: text,
      sourceLanguage: _sourceLanguage,
      targetLanguage: _targetLanguage,
      packetType: PacketType.alert,
      messageId: messageId,
    );

    await networkService.sendPacket(packetBytes);
    _isProcessingStt = false;

    final message = SpeechMessage(
      id: messageId,
      senderName: "EMERGENCY ALERT (${_sourceLanguage.code.toUpperCase()})",
      text: text,
      sourceLanguage: _sourceLanguage,
      targetLanguage: _targetLanguage,
      isSentByMe: true,
      rawAudioBytes: 64000,
      compressedPacketBytes: packetBytes.length,
      sttLatencyMs: 10,
      transmissionLatencyMs: 12,
    );

    _messages.insert(0, message);
    notifyListeners();
  }

  Future<void> _sendTransceiverText(String text, int sttLatencyMs, int rawAudioBytes) async {
    final messageId = DateTime.now().millisecondsSinceEpoch.toString().substring(5);

    final packetBytes = PacketCodec.encode(
      text: text,
      sourceLanguage: _sourceLanguage,
      targetLanguage: _targetLanguage,
      messageId: messageId,
    );

    final txStartTime = DateTime.now().millisecondsSinceEpoch;

    await networkService.sendPacket(packetBytes);
    final txLatency = DateTime.now().millisecondsSinceEpoch - txStartTime;

    final message = SpeechMessage(
      id: messageId,
      senderName: "Me (${_sourceLanguage.code.toUpperCase()})",
      text: text,
      sourceLanguage: _sourceLanguage,
      targetLanguage: _targetLanguage,
      isSentByMe: true,
      rawAudioBytes: rawAudioBytes > 0 ? rawAudioBytes : 64000,
      compressedPacketBytes: packetBytes.length,
      sttLatencyMs: sttLatencyMs,
      transmissionLatencyMs: txLatency,
    );

    _messages.insert(0, message);
    notifyListeners();
  }

  @override
  void onPacketReceived(Uint8List packetBytes) async {
    final decoded = PacketCodec.decode(packetBytes);
    if (decoded == null) return;

    final packet = decoded.key;
    final text = decoded.value;
    final isAlert = packet.packetType == PacketType.alert;

    debugPrint("Received ${packetBytes.length} bytes packet (Alert=$isAlert) from peer: '$text'");

    _isProcessingTts = true;
    notifyListeners();

    final ttsLatency = await ttsService.speak(text, packet.targetLanguage);

    _isProcessingTts = false;

    final message = SpeechMessage(
      id: packet.messageId,
      senderName: isAlert ? "⚠️ DISTRESS ALERT (${packet.sourceLanguage.code.toUpperCase()})" : "Peer (${packet.sourceLanguage.code.toUpperCase()})",
      text: text,
      sourceLanguage: packet.sourceLanguage,
      targetLanguage: packet.targetLanguage,
      isSentByMe: false,
      rawAudioBytes: 64000,
      compressedPacketBytes: packetBytes.length,
      sttLatencyMs: 190,
      transmissionLatencyMs: 15,
      ttsLatencyMs: ttsLatency,
    );

    _messages.insert(0, message);
    notifyListeners();
  }

  @override
  void onConnectionStateChanged(ConnectionStatus status, String? peerName) {
    _connectionStatus = status;
    _connectedPeer = peerName;
    notifyListeners();
  }

  @override
  void onSpeechStart() {
    debugPrint("VAD: Speech start detected in continuous mode");
  }

  @override
  void onSpeechEnd(Float32List pcmUtterance) async {
    if (!_isPushToTalkMode) {
      debugPrint("VAD: Speech end detected in continuous mode (${pcmUtterance.length} samples)");
      final text = await sttService.transcribe(pcmUtterance);
      if (text.isNotEmpty) {
        await _sendTransceiverText(text, 190, pcmUtterance.length * 2);
      }
    }
  }

  @override
  void onAudioBuffer(Float32List samples, bool isSpeech) {
    if (samples.isNotEmpty) {
      double maxAmp = 0.0;
      for (int i = 0; i < samples.length; i += 10) {
        final abs = samples[i].abs();
        if (abs > maxAmp) maxAmp = abs;
      }
      _livePcmAmplitudes.removeAt(0);
      _livePcmAmplitudes.add(maxAmp.clamp(0.05, 1.0));
      notifyListeners();
    }
  }

  Future<void> startP2pHost() async {
    await networkService.startServer();
  }

  Future<void> connectP2pPeer(String ipAddress) async {
    await networkService.connectToPeer(ipAddress);
  }
}
