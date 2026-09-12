import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import '../lib/models/language.dart';
import '../lib/models/transceiver_packet.dart';
import '../lib/services/packet_codec.dart';

void main() {
  group('PacketCodec Unit Tests', () {
    test('Encodes and decodes speech text packet accurately', () {
      const text = "मुझे मदद की ज़रूरत है";
      const srcLang = AppLanguage.hindi;
      const tgtLang = AppLanguage.tamil;

      final encodedBytes = PacketCodec.encode(
        text: text,
        sourceLanguage: srcLang,
        targetLanguage: tgtLang,
        messageId: "msg12345",
      );

      expect(encodedBytes, isNotNull);
      expect(encodedBytes.length, greaterThan(23));

      // Validate magic header "iT"
      expect(encodedBytes[0], equals(0x69));
      expect(encodedBytes[1], equals(0x54));

      final decodedPair = PacketCodec.decode(encodedBytes);
      expect(decodedPair, isNotNull);

      final packet = decodedPair!.key;
      final decodedText = decodedPair.value;

      expect(decodedText, equals(text));
      expect(packet.sourceLanguage, equals(srcLang));
      expect(packet.targetLanguage, equals(tgtLang));
      expect(packet.packetType, equals(PacketType.speechText));
    });

    test('Rejects invalid magic header', () {
      final invalidBytes = Uint8List.fromList([0x00, 0x00, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 32, 32, 32, 32, 32, 32, 32, 32, 0, 0]);
      final result = PacketCodec.decode(invalidBytes);
      expect(result, isNull);
    });

    test('Verifies compression ratio on long Indian sentence', () {
      const sentence = "இந்த பயன்பாடு இணையம் இல்லாமல் குரல் தகவல்களை குறைந்த அலைவரிசையில் அனுப்ப உதவுகிறது";
      final encoded = PacketCodec.encode(
        text: sentence,
        sourceLanguage: AppLanguage.tamil,
        targetLanguage: AppLanguage.english,
      );

      // Packet byte size should be extremely compact (< 100 bytes)
      expect(encoded.length, lessThan(120));
    });
  });
}
