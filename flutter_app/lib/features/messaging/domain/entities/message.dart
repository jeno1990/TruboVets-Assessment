import 'package:equatable/equatable.dart';

/// Type of message content
enum MessageType { text, image }

/// Represents a chat message in the messaging feature.
class Message extends Equatable {
  /// Unique identifier for the message
  final String id;

  /// The message text content (empty for image-only messages)
  final String text;

  /// Whether this message was sent by the user (true) or agent (false)
  final bool isFromUser;

  /// Timestamp when the message was created
  final DateTime timestamp;

  /// Type of message (text or image)
  final MessageType type;

  /// Local file path for image messages (null for text messages)
  final String? imagePath;

  const Message({
    required this.id,
    required this.text,
    required this.isFromUser,
    required this.timestamp,
    this.type = MessageType.text,
    this.imagePath,
  });

  /// Creates a user text message with auto-generated ID and current timestamp
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

  /// Creates an agent text message with auto-generated ID and current timestamp
  factory Message.fromAgent(String text) {
    return Message(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text,
      isFromUser: false,
      timestamp: DateTime.now(),
      type: MessageType.text,
    );
  }

  /// Whether this is an image message
  bool get isImage => type == MessageType.image;

  /// Whether this is a text message
  bool get isText => type == MessageType.text;

  @override
  List<Object?> get props => [id, text, isFromUser, timestamp, type, imagePath];
}
