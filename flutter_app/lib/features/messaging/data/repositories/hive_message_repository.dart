import 'package:hive_ce/hive.dart';

import '../../domain/entities/message.dart';
import '../../domain/repositories/message_repository.dart';

/// Hive-based implementation of MessageRepository.
/// Persists messages to local storage using Hive.
class HiveMessageRepository implements MessageRepository {
  static const String _boxName = 'messages';

  Box<Message>? _box;

  /// Opens the Hive box. Must be called before using the repository.
  Future<void> init() async {
    _box = await Hive.openBox<Message>(_boxName);
  }

  Box<Message> get _messagesBox {
    if (_box == null || !_box!.isOpen) {
      throw StateError('HiveMessageRepository not initialized. Call init() first.');
    }
    return _box!;
  }

  @override
  List<Message> getMessages() {
    return _messagesBox.values.toList()
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
  }

  @override
  void addMessage(Message message) {
    _messagesBox.put(message.id, message);
  }

  @override
  void clearMessages() {
    _messagesBox.clear();
  }
}

