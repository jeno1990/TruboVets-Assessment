import 'package:equatable/equatable.dart';

/// Type of message content
enum MessageType { text, image }

class Message extends Equatable {
  final String id;
  final String text;
  final bool isFromUser;
  final DateTime timestamp;
  final MessageType type;
  final String? imagePath;

  const Message({
    required this.id,
    required this.text,
    required this.isFromUser,
    required this.timestamp,
    this.type = MessageType.text,
    this.imagePath,
  });

  factory Message.fromUser(String text) {
    return Message(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text,
      isFromUser: true,
      timestamp: DateTime.now(),
      type: MessageType.text,
    );
  }

  /// Creates a user image message with auto-generated ID and current timestamp
  factory Message.imageFromUser(String imagePath) {
    return Message(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: '',
      isFromUser: true,
      timestamp: DateTime.now(),
      type: MessageType.image,
      imagePath: imagePath,
    );
  }

  factory Message.fromAgent(String text) {
    return Message(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text,
      isFromUser: false,
      timestamp: DateTime.now(),
      type: MessageType.text,
    );
  }
  bool get isImage => type == MessageType.image;

  bool get isText => type == MessageType.text;

  @override
  List<Object?> get props => [id, text, isFromUser, timestamp, type, imagePath];
}
