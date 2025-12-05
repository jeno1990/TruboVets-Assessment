import '../entities/message.dart';

abstract class MessageRepository {
  // Retrieves all messages
  List<Message> getMessages();

  // Adds a new message
  void addMessage(Message message);

  // Clears all messages
  void clearMessages();
}
