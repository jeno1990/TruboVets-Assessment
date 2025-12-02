import 'package:hive_ce/hive.dart';

import '../../domain/entities/message.dart';

/// Hive TypeAdapter for Message entity.
/// Manually implemented to avoid code generation complexity.
class MessageAdapter extends TypeAdapter<Message> {
  @override
  final int typeId = 0;

  @override
  Message read(BinaryReader reader) {
    final id = reader.readString();
    final text = reader.readString();
    final isFromUser = reader.readBool();
    final timestamp = DateTime.fromMillisecondsSinceEpoch(reader.readInt());

    return Message(
      id: id,
      text: text,
      isFromUser: isFromUser,
      timestamp: timestamp,
    );
  }

  @override
  void write(BinaryWriter writer, Message obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.text);
    writer.writeBool(obj.isFromUser);
    writer.writeInt(obj.timestamp.millisecondsSinceEpoch);
  }
}

