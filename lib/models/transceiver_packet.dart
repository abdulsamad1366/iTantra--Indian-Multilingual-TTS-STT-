import 'dart:typed_data';
import 'language.dart';

enum PacketType {
  speechText(1),
  pttStart(2),
  pttEnd(3),
  heartbeat(4),
  alert(5);

  final int code;
  const PacketType(this.code);

  static PacketType fromCode(int code) {
    return PacketType.values.firstWhere(
      (type) => type.code == code,
      orElse: () => PacketType.speechText,
    );
  }
}

class TransceiverPacket {
  final PacketType packetType;
  final String messageId;
  final AppLanguage sourceLanguage;
  final AppLanguage targetLanguage;
  final int timestamp;
  final Uint8List payload;

  TransceiverPacket({
    required this.packetType,
    required this.messageId,
    required this.sourceLanguage,
    required this.targetLanguage,
    required this.timestamp,
    required this.payload,
  });
}
