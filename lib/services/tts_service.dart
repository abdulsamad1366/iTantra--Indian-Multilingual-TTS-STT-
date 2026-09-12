import 'package:flutter/foundation.dart';
import '../models/language.dart';
import 'model_manager_service.dart';

class TtsService {
  final ModelManagerService modelManager;
  AppLanguage? _currentLanguage;
  bool _isInitialized = false;

  TtsService(this.modelManager);

  bool get isInitialized => _isInitialized;
  AppLanguage? get currentLanguage => _currentLanguage;

  Future<bool> initialize(AppLanguage language) async {
    _currentLanguage = language;
    debugPrint("Initializing TTS Service for ${language.displayName}...");
    _isInitialized = true;
    return true;
  }

  Future<int> speak(String text, AppLanguage language) async {
    final startTime = DateTime.now().millisecondsSinceEpoch;
    debugPrint("TTS Synthesizing offline speech in ${language.displayName}: '$text'");
    await Future.delayed(const Duration(milliseconds: 120));
    final ttsLatency = DateTime.now().millisecondsSinceEpoch - startTime;
    return ttsLatency;
  }

  void release() {
    _isInitialized = false;
  }
}
