import '../entities/message.dart';

/// Abstract repository interface for message operations.
abstract class MessageRepository {
  /// Retrieves all messages
  List<Message> getMessages();

  /// Adds a new message
  void addMessage(Message message);

  /// Clears all messages
  void clearMessages();
}
