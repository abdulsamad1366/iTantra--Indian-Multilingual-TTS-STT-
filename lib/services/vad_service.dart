import 'dart:math';
import 'dart:typed_data';

abstract class VadListener {
  void onSpeechStart();
  void onSpeechEnd(Float32List pcmUtterance);
  void onAudioBuffer(Float32List samples, bool isSpeech);
}

class VadService {
  bool _isSpeechActive = false;
  int _silenceFrameCount = 0;
  int _speechFrameCount = 0;

  final double _energyThreshold = 1200.0;
  final int _minSpeechFrames = 3;
  final int _maxSilenceFrames = 15;

  final List<double> _utteranceBuffer = [];

  bool get isSpeechActive => _isSpeechActive;

  void processPcmChunk(Int16List pcmData, VadListener? listener) {
    final floatSamples = Float32List(pcmData.length);
    double sum = 0.0;

    for (int i = 0; i < pcmData.length; i++) {
      final s = pcmData[i];
      floatSamples[i] = s / 32768.0;
      sum += (s * s).toDouble();
    }

    final rms = sqrt(sum / pcmData.length);
    final isFrameSpeech = rms > _energyThreshold;

    if (isFrameSpeech) {
      _speechFrameCount++;
      _silenceFrameCount = 0;
      if (!_isSpeechActive && _speechFrameCount >= _minSpeechFrames) {
        _isSpeechActive = true;
        listener?.onSpeechStart();
      }
    } else {
      _silenceFrameCount++;
      if (_isSpeechActive && _silenceFrameCount >= _maxSilenceFrames) {
        _isSpeechActive = false;
        _speechFrameCount = 0;
        final completedUtterance = Float32List.fromList(_utteranceBuffer);
        _utteranceBuffer.clear();
        listener?.onSpeechEnd(completedUtterance);
      }
    }

    if (_isSpeechActive) {
      _utteranceBuffer.addAll(floatSamples);
    }

    listener?.onAudioBuffer(floatSamples, isFrameSpeech);
  }

  void reset() {
    _isSpeechActive = false;
    _speechFrameCount = 0;
    _silenceFrameCount = 0;
    _utteranceBuffer.clear();
  }
}
