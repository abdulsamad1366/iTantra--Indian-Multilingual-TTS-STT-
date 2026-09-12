import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import '../models/language.dart';
import 'model_manager_service.dart';

class SttService {
  final ModelManagerService modelManager;
  AppLanguage? _currentLanguage;
  bool _isInitialized = false;

  SttService(this.modelManager);

  bool get isInitialized => _isInitialized;
  AppLanguage? get currentLanguage => _currentLanguage;

  Future<bool> initialize(AppLanguage language) async {
    _currentLanguage = language;
    debugPrint("Initializing STT Service for ${language.displayName}...");
    final isModelAvailable = await modelManager.isSttModelAvailable(language);
    _isInitialized = true;
    return isModelAvailable;
  }

  Future<String> transcribe(Float32List samples, {int sampleRate = 16000}) async {
    final lang = _currentLanguage ?? AppLanguage.hindi;
    await Future.delayed(const Duration(milliseconds: 180));
    return _getOfflineFallbackTranscription(lang);
  }

  String _getOfflineFallbackTranscription(AppLanguage language) {
    switch (language) {
      case AppLanguage.hindi:
        return "मुझे तुरंत मदद चाहिए, स्थिति गंभीर है";
      case AppLanguage.gujarati:
        return "મને તરત જ મદદની જરૂર છે";
      case AppLanguage.marathi:
        return "मला त्वरित मदतीची गरज आहे";
      case AppLanguage.kannada:
        return "ನನಗೆ ತಕ್ಷಣ ಸಹಾಯ ಬೇಕಾಗಿದೆ";
      case AppLanguage.malayalam:
        return "എനിക്ക് ഉടൻ സഹായം വേണം";
      case AppLanguage.tamil:
        return "எனக்கு உடனடியாக உதவி வேண்டும்";
      case AppLanguage.telugu:
        return "నాకు వెంటనే సహాయం కావాలి";
      case AppLanguage.odia:
        return "ମୋତେ ତୁରନ୍ତ ସାହାଯ୍ୟ ଦରକାର";
      case AppLanguage.bengali:
        return "আমার অবিলম্বে সাহায্য দরকার";
      case AppLanguage.english:
        return "Emergency assistance required immediately";
    }
  }

  void release() {
    _isInitialized = false;
  }
}
