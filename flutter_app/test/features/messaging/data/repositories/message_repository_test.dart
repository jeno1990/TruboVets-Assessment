import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_app/features/messaging/domain/entities/message.dart';
import 'package:flutter_app/features/messaging/domain/repositories/message_repository.dart';
import 'package:flutter_app/features/messaging/data/repositories/message_repository_impl.dart';

void main() {
  group('MessageRepositoryImpl', () {
    late MessageRepository repository;

    setUp(() {
      repository = MessageRepositoryImpl();
    });

    group('getMessages', () {
      test('should return empty list initially', () {
        final messages = repository.getMessages();

        expect(messages, isEmpty);
      });

      test('should return unmodifiable list', () {
        final messages = repository.getMessages();

        expect(() => messages.add(Message.fromUser('Test')), throwsA(isA<UnsupportedError>()));
      });
    });

    group('addMessage', () {
      test('should add a message to the repository', () {
        final message = Message.fromUser('Hello');

        repository.addMessage(message);
        final messages = repository.getMessages();

        expect(messages.length, 1);
        expect(messages.first, message);
      });

      test('should add multiple messages in order', () {
        final message1 = Message.fromUser('First');
        final message2 = Message.fromUser('Second');
        final message3 = Message.fromAgent('Third');

        repository.addMessage(message1);
        repository.addMessage(message2);
        repository.addMessage(message3);

        final messages = repository.getMessages();

        expect(messages.length, 3);
        expect(messages[0], message1);
        expect(messages[1], message2);
        expect(messages[2], message3);
      });

      test('should add image messages', () {
        final imageMessage = Message.imageFromUser('/path/to/image.jpg');

        repository.addMessage(imageMessage);
        final messages = repository.getMessages();

        expect(messages.length, 1);
        expect(messages.first.isImage, true);
        expect(messages.first.imagePath, '/path/to/image.jpg');
      });
    });

    group('clearMessages', () {
      test('should remove all messages', () {
        repository.addMessage(Message.fromUser('First'));
        repository.addMessage(Message.fromUser('Second'));
        repository.addMessage(Message.fromAgent('Third'));

        expect(repository.getMessages().length, 3);

        repository.clearMessages();

        expect(repository.getMessages(), isEmpty);
      });

      test('should work on empty repository', () {
        expect(repository.getMessages(), isEmpty);

        repository.clearMessages();

        expect(repository.getMessages(), isEmpty);
      });
    });

    group('integration scenarios', () {
      test('should handle add, clear, add sequence', () {
        repository.addMessage(Message.fromUser('First batch'));
        repository.clearMessages();
        repository.addMessage(Message.fromUser('Second batch'));

        final messages = repository.getMessages();

        expect(messages.length, 1);
        expect(messages.first.text, 'Second batch');
      });

      test('should maintain message integrity after retrieval', () {
        final originalMessage = Message(
          id: 'test-id',
          text: 'Test message',
          isFromUser: true,
          timestamp: DateTime(2024, 1, 1),
          type: MessageType.text,
        );

        repository.addMessage(originalMessage);
        final retrieved = repository.getMessages().first;

        expect(retrieved.id, originalMessage.id);
        expect(retrieved.text, originalMessage.text);
        expect(retrieved.isFromUser, originalMessage.isFromUser);
        expect(retrieved.timestamp, originalMessage.timestamp);
        expect(retrieved.type, originalMessage.type);
      });
    });
  });
}

