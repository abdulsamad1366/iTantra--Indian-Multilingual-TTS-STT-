import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import '../models/language.dart';
import '../models/transceiver_packet.dart';

class PacketCodec {
  static const List<int> magicBytes = [0x69, 0x54]; // "iT"

  static Uint8List encode({
    required String text,
    required AppLanguage sourceLanguage,
    required AppLanguage targetLanguage,
    PacketType packetType = PacketType.speechText,
    String? messageId,
  }) {
    final msgId = (messageId ?? DateTime.now().millisecondsSinceEpoch.toString()).padRight(8).substring(0, 8);
    final rawTextBytes = utf8.encode(text);
    final compressedPayload = Uint8List.fromList(zlib.encode(rawTextBytes));

    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final idBytes = utf8.encode(msgId);

    final totalSize = 2 + 1 + 1 + 1 + 8 + 8 + 2 + compressedPayload.length;
    final bdata = ByteData(totalSize);

    int offset = 0;
    bdata.setUint8(offset++, magicBytes[0]);
    bdata.setUint8(offset++, magicBytes[1]);
    bdata.setUint8(offset++, packetType.code);
    bdata.setUint8(offset++, sourceLanguage.id);
    bdata.setUint8(offset++, targetLanguage.id);
    bdata.setInt64(offset, timestamp);
    offset += 8;

    for (int i = 0; i < 8; i++) {
      bdata.setUint8(offset++, i < idBytes.length ? idBytes[i] : 32);
    }

    bdata.setUint16(offset, compressedPayload.length);
    offset += 2;

    final result = Uint8List(totalSize);
    result.setRange(0, offset, bdata.buffer.asUint8List(0, offset));
    result.setRange(offset, totalSize, compressedPayload);

    return result;
  }

  static MapEntry<TransceiverPacket, String>? decode(Uint8List bytes) {
    if (bytes.length < 23) return null;

    final bdata = ByteData.sublistView(bytes);

    int offset = 0;
    final m1 = bdata.getUint8(offset++);
    final m2 = bdata.getUint8(offset++);

    if (m1 != magicBytes[0] || m2 != magicBytes[1]) {
      return null;
    }

    final typeCode = bdata.getUint8(offset++);
    final srcLangId = bdata.getUint8(offset++);
    final tgtLangId = bdata.getUint8(offset++);
    final timestamp = bdata.getInt64(offset);
    offset += 8;

    final idBytes = bytes.sublist(offset, offset + 8);
    offset += 8;
    final messageId = utf8.decode(idBytes).trim();

    final payloadLen = bdata.getUint16(offset);
    offset += 2;

    if (bytes.length - offset < payloadLen) return null;

    final compressedPayload = bytes.sublist(offset, offset + payloadLen);
    final decompressedBytes = Uint8List.fromList(zlib.decode(compressedPayload));
    final text = utf8.decode(decompressedBytes);

    final packet = TransceiverPacket(
      packetType: PacketType.fromCode(typeCode),
      messageId: messageId,
      sourceLanguage: AppLanguage.fromId(srcLangId),
      targetLanguage: AppLanguage.fromId(tgtLangId),
      timestamp: timestamp,
      payload: compressedPayload,
    );

    return MapEntry(packet, text);
  }
}
