import '../../domain/entities/message.dart';
import '../../domain/repositories/message_repository.dart';

class MessageRepositoryImpl implements MessageRepository {
  final List<Message> _messages = [];

  @override
  List<Message> getMessages() {
    return List.unmodifiable(_messages);
  }

  @override
  void addMessage(Message message) {
    _messages.add(message);
  }

  @override
  void clearMessages() {
    _messages.clear();
  }
}
