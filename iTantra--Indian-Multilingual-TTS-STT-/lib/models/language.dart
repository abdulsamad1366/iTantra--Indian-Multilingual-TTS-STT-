enum AppLanguage {
  hindi('hi', 'Hindi', 'हिंदी', 1),
  gujarati('gu', 'Gujarati', 'ગુજરાતી', 2),
  marathi('mr', 'Marathi', 'मराठी', 3),
  kannada('kn', 'Kannada', 'ಕನ್ನಡ', 4),
  malayalam('ml', 'Malayalam', 'മലയാളം', 5),
  tamil('ta', 'Tamil', 'தமிழ்', 6),
  telugu('te', 'Telugu', 'తెలుగు', 7),
  odia('or', 'Odia', 'ଓଡ଼ିଆ', 8),
  bengali('bn', 'Bengali', 'বাংলা', 9),
  english('en', 'English', 'English', 10);

  final String code;
  final String displayName;
  final String nativeName;
  final int id;

  const AppLanguage(this.code, this.displayName, this.nativeName, this.id);

  static AppLanguage fromId(int id) {
    return AppLanguage.values.firstWhere(
      (lang) => lang.id == id,
      orElse: () => AppLanguage.hindi,
    );
  }

  static AppLanguage fromCode(String code) {
    return AppLanguage.values.firstWhere(
      (lang) => lang.code.toLowerCase() == code.toLowerCase(),
      orElse: () => AppLanguage.hindi,
    );
  }
}
