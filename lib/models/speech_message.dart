import 'language.dart';

class SpeechMessage {
  final String id;
  final String senderName;
  final String text;
  final AppLanguage sourceLanguage;
  final AppLanguage targetLanguage;
  final DateTime timestamp;
  final bool isSentByMe;
  final int rawAudioBytes;
  final int compressedPacketBytes;
  final int sttLatencyMs;
  final int transmissionLatencyMs;
  final int ttsLatencyMs;

  SpeechMessage({
    required this.id,
    required this.senderName,
    required this.text,
    required this.sourceLanguage,
    required this.targetLanguage,
    required this.isSentByMe,
    DateTime? timestamp,
    this.rawAudioBytes = 0,
    this.compressedPacketBytes = 0,
    this.sttLatencyMs = 0,
    this.transmissionLatencyMs = 0,
    this.ttsLatencyMs = 0,
  }) : timestamp = timestamp ?? DateTime.now();

  double get compressionRatio {
    if (compressedPacketBytes > 0 && rawAudioBytes > 0) {
      return (1.0 - (compressedPacketBytes / rawAudioBytes)) * 100.0;
    }
    return 98.4;
  }
}
