import '../../domain/entities/message.dart';
import '../../domain/repositories/message_repository.dart';

/// In-memory implementation of MessageRepository.
/// Messages are stored in memory and persist during app session.
/// Can be extended to use Hive or SQLite for persistent storage.
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

