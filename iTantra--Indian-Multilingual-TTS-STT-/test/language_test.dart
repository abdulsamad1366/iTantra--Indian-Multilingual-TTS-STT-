import 'package:flutter_test/flutter_test.dart';
import '../lib/models/language.dart';

void main() {
  group('Language Enum Unit Tests', () {
    test('Contains exactly 10 supported languages', () {
      expect(AppLanguage.values.length, equals(10));
    });

    test('Maps IDs and ISO codes correctly', () {
      expect(AppLanguage.fromId(1), equals(AppLanguage.hindi));
      expect(AppLanguage.fromId(2), equals(AppLanguage.gujarati));
      expect(AppLanguage.fromId(3), equals(AppLanguage.marathi));
      expect(AppLanguage.fromId(4), equals(AppLanguage.kannada));
      expect(AppLanguage.fromId(5), equals(AppLanguage.malayalam));
      expect(AppLanguage.fromId(6), equals(AppLanguage.tamil));
      expect(AppLanguage.fromId(7), equals(AppLanguage.telugu));
      expect(AppLanguage.fromId(8), equals(AppLanguage.odia));
      expect(AppLanguage.fromId(9), equals(AppLanguage.bengali));
      expect(AppLanguage.fromId(10), equals(AppLanguage.english));

      expect(AppLanguage.fromCode('hi'), equals(AppLanguage.hindi));
      expect(AppLanguage.fromCode('ta'), equals(AppLanguage.tamil));
      expect(AppLanguage.fromCode('en'), equals(AppLanguage.english));
    });

    test('Native names are populated for all 10 languages', () {
      for (final lang in AppLanguage.values) {
        expect(lang.displayName.isNotEmpty, isTrue);
        expect(lang.nativeName.isNotEmpty, isTrue);
        expect(lang.code.isNotEmpty, isTrue);
      }
    });
  });
}
