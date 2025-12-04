import 'package:hive_ce/hive.dart';

import '../../domain/entities/message.dart';

class MessageAdapter extends TypeAdapter<Message> {
  @override
  final int typeId = 0;

  @override
  Message read(BinaryReader reader) {
    final id = reader.readString();
    final text = reader.readString();
    final isFromUser = reader.readBool();
    final timestamp = DateTime.fromMillisecondsSinceEpoch(reader.readInt());
    final typeIndex = reader.readInt();
    final hasImagePath = reader.readBool();
    final imagePath = hasImagePath ? reader.readString() : null;

    return Message(
      id: id,
      text: text,
      isFromUser: isFromUser,
      timestamp: timestamp,
      type: MessageType.values[typeIndex],
      imagePath: imagePath,
    );
  }

  @override
  void write(BinaryWriter writer, Message obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.text);
    writer.writeBool(obj.isFromUser);
    writer.writeInt(obj.timestamp.millisecondsSinceEpoch);
    writer.writeInt(obj.type.index);
    writer.writeBool(obj.imagePath != null);
    if (obj.imagePath != null) {
      writer.writeString(obj.imagePath!);
    }
  }
}
