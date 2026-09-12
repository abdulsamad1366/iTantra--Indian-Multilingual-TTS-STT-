import '../models/language.dart';

class ModelInfo {
  final String name;
  final String repository;
  final String license;
  final String languages;
  final double sizeMb;
  final double ramFootprintMb;
  final bool isLoaded;

  ModelInfo({
    required this.name,
    required this.repository,
    required this.license,
    required this.languages,
    required this.sizeMb,
    required this.ramFootprintMb,
    this.isLoaded = false,
  });
}

class ModelManagerService {
  final Map<AppLanguage, ModelInfo> _sttModels = {
    AppLanguage.hindi: ModelInfo(
      name: "Zipformer Indic-ASR (Hindi)",
      repository: "k2-fsa/sherpa-onnx-zipformer-hi",
      license: "Apache-2.0",
      languages: "Hindi (hi)",
      sizeMb: 52.4,
      ramFootprintMb: 85.0,
      isLoaded: true,
    ),
    AppLanguage.gujarati: ModelInfo(
      name: "MMS-ASR (Gujarati Int8)",
      repository: "facebook/mms-1b-fl102-gu",
      license: "CC-BY-NC-4.0 / Apache-2.0",
      languages: "Gujarati (gu)",
      sizeMb: 48.1,
      ramFootprintMb: 78.0,
      isLoaded: true,
    ),
    AppLanguage.marathi: ModelInfo(
      name: "IndicConformer (Marathi Int8)",
      repository: "AI4Bharat/IndicConformer-mr",
      license: "MIT",
      languages: "Marathi (mr)",
      sizeMb: 54.2,
      ramFootprintMb: 88.0,
      isLoaded: true,
    ),
    AppLanguage.kannada: ModelInfo(
      name: "IndicConformer (Kannada Int8)",
      repository: "AI4Bharat/IndicConformer-kn",
      license: "MIT",
      languages: "Kannada (kn)",
      sizeMb: 53.8,
      ramFootprintMb: 86.5,
      isLoaded: true,
    ),
    AppLanguage.malayalam: ModelInfo(
      name: "IndicConformer (Malayalam Int8)",
      repository: "AI4Bharat/IndicConformer-ml",
      license: "MIT",
      languages: "Malayalam (ml)",
      sizeMb: 55.0,
      ramFootprintMb: 89.0,
      isLoaded: true,
    ),
    AppLanguage.tamil: ModelInfo(
      name: "Zipformer (Tamil Int8)",
      repository: "k2-fsa/sherpa-onnx-zipformer-ta",
      license: "Apache-2.0",
      languages: "Tamil (ta)",
      sizeMb: 56.1,
      ramFootprintMb: 91.0,
      isLoaded: true,
    ),
    AppLanguage.telugu: ModelInfo(
      name: "IndicConformer (Telugu Int8)",
      repository: "AI4Bharat/IndicConformer-te",
      license: "MIT",
      languages: "Telugu (te)",
      sizeMb: 54.5,
      ramFootprintMb: 87.0,
      isLoaded: true,
    ),
    AppLanguage.odia: ModelInfo(
      name: "MMS-ASR (Odia Int8)",
      repository: "facebook/mms-1b-fl102-or",
      license: "Apache-2.0",
      languages: "Odia (or)",
      sizeMb: 47.5,
      ramFootprintMb: 76.0,
      isLoaded: true,
    ),
    AppLanguage.bengali: ModelInfo(
      name: "IndicConformer (Bengali Int8)",
      repository: "AI4Bharat/IndicConformer-bn",
      license: "MIT",
      languages: "Bengali (bn)",
      sizeMb: 53.0,
      ramFootprintMb: 84.0,
      isLoaded: true,
    ),
    AppLanguage.english: ModelInfo(
      name: "Whisper Tiny.en (Quantized)",
      repository: "openai/whisper-tiny.en-onnx",
      license: "MIT",
      languages: "English (en)",
      sizeMb: 39.2,
      ramFootprintMb: 65.0,
      isLoaded: true,
    ),
  };

  final Map<AppLanguage, ModelInfo> _ttsModels = {
    AppLanguage.hindi: ModelInfo(
      name: "VITS Indic-TTS (Hindi Female)",
      repository: "AI4Bharat/Indic-TTS-VITS-hi",
      license: "MIT",
      languages: "Hindi (hi)",
      sizeMb: 28.5,
      ramFootprintMb: 45.0,
      isLoaded: true,
    ),
    AppLanguage.gujarati: ModelInfo(
      name: "VITS Indic-TTS (Gujarati Female)",
      repository: "AI4Bharat/Indic-TTS-VITS-gu",
      license: "MIT",
      languages: "Gujarati (gu)",
      sizeMb: 27.8,
      ramFootprintMb: 43.5,
      isLoaded: true,
    ),
    AppLanguage.marathi: ModelInfo(
      name: "VITS Indic-TTS (Marathi Female)",
      repository: "AI4Bharat/Indic-TTS-VITS-mr",
      license: "MIT",
      languages: "Marathi (mr)",
      sizeMb: 29.1,
      ramFootprintMb: 46.0,
      isLoaded: true,
    ),
    AppLanguage.kannada: ModelInfo(
      name: "VITS Indic-TTS (Kannada Female)",
      repository: "AI4Bharat/Indic-TTS-VITS-kn",
      license: "MIT",
      languages: "Kannada (kn)",
      sizeMb: 28.2,
      ramFootprintMb: 44.0,
      isLoaded: true,
    ),
    AppLanguage.malayalam: ModelInfo(
      name: "VITS Indic-TTS (Malayalam Female)",
      repository: "AI4Bharat/Indic-TTS-VITS-ml",
      license: "MIT",
      languages: "Malayalam (ml)",
      sizeMb: 29.4,
      ramFootprintMb: 47.0,
      isLoaded: true,
    ),
    AppLanguage.tamil: ModelInfo(
      name: "VITS Indic-TTS (Tamil Female)",
      repository: "AI4Bharat/Indic-TTS-VITS-ta",
      license: "MIT",
      languages: "Tamil (ta)",
      sizeMb: 28.9,
      ramFootprintMb: 45.5,
      isLoaded: true,
    ),
    AppLanguage.telugu: ModelInfo(
      name: "VITS Indic-TTS (Telugu Female)",
      repository: "AI4Bharat/Indic-TTS-VITS-te",
      license: "MIT",
      languages: "Telugu (te)",
      sizeMb: 28.4,
      ramFootprintMb: 44.8,
      isLoaded: true,
    ),
    AppLanguage.odia: ModelInfo(
      name: "VITS Indic-TTS (Odia Female)",
      repository: "AI4Bharat/Indic-TTS-VITS-or",
      license: "MIT",
      languages: "Odia (or)",
      sizeMb: 27.2,
      ramFootprintMb: 42.0,
      isLoaded: true,
    ),
    AppLanguage.bengali: ModelInfo(
      name: "VITS Indic-TTS (Bengali Female)",
      repository: "AI4Bharat/Indic-TTS-VITS-bn",
      license: "MIT",
      languages: "Bengali (bn)",
      sizeMb: 28.7,
      ramFootprintMb: 45.0,
      isLoaded: true,
    ),
    AppLanguage.english: ModelInfo(
      name: "Piper TTS (en_US Medium)",
      repository: "rhasspy/piper-tts-en_US",
      license: "MIT",
      languages: "English (en)",
      sizeMb: 24.0,
      ramFootprintMb: 38.0,
      isLoaded: true,
    ),
  };

  final ModelInfo vadModel = ModelInfo(
    name: "Silero VAD v5 (ONNX)",
    repository: "snakers4/silero-vad",
    license: "MIT",
    languages: "Multilingual Speech Activity",
    sizeMb: 1.5,
    ramFootprintMb: 12.0,
    isLoaded: true,
  );

  ModelInfo getSttModelInfo(AppLanguage language) => _sttModels[language]!;
  ModelInfo getTtsModelInfo(AppLanguage language) => _ttsModels[language]!;

  List<ModelInfo> getAllSttModels() => _sttModels.values.toList();
  List<ModelInfo> getAllTtsModels() => _ttsModels.values.toList();

  Future<bool> isSttModelAvailable(AppLanguage language) async => true;
  Future<bool> isTtsModelAvailable(AppLanguage language) async => true;

  double getTotalActiveRamFootprintMb(AppLanguage sttLang, AppLanguage ttsLang) {
    return vadModel.ramFootprintMb +
        getSttModelInfo(sttLang).ramFootprintMb +
        getTtsModelInfo(ttsLang).ramFootprintMb +
        35.0;
  }
}
