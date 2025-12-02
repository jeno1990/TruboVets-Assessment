import 'package:equatable/equatable.dart';

/// Represents a chat message in the messaging feature.
class Message extends Equatable {
  /// Unique identifier for the message
  final String id;

  /// The message text content
  final String text;

  /// Whether this message was sent by the user (true) or agent (false)
  final bool isFromUser;

  /// Timestamp when the message was created
  final DateTime timestamp;

  const Message({
    required this.id,
    required this.text,
    required this.isFromUser,
    required this.timestamp,
  });

  /// Creates a user message with auto-generated ID and current timestamp
  factory Message.fromUser(String text) {
    return Message(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text,
      isFromUser: true,
      timestamp: DateTime.now(),
    );
  }

  /// Creates an agent message with auto-generated ID and current timestamp
  factory Message.fromAgent(String text) {
    return Message(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text,
      isFromUser: false,
      timestamp: DateTime.now(),
    );
  }

  @override
  List<Object?> get props => [id, text, isFromUser, timestamp];
}

