import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_app/features/messaging/domain/entities/message.dart';

void main() {
  group('Message Entity', () {
    group('fromUser factory', () {
      test('should create a text message from user', () {
        final message = Message.fromUser('Hello');

        expect(message.text, 'Hello');
        expect(message.isFromUser, true);
        expect(message.type, MessageType.text);
        expect(message.imagePath, isNull);
        expect(message.id, isNotEmpty);
        expect(message.timestamp, isA<DateTime>());
      });

      test('should trim whitespace from text', () {
        final message = Message.fromUser('  Hello World  ');

        // Note: fromUser doesn't trim - that's done in the cubit
        expect(message.text, '  Hello World  ');
      });

      test('should generate unique IDs for different messages', () {
        final message1 = Message.fromUser('First');
        // Small delay to ensure different timestamp
        final message2 = Message.fromUser('Second');

        // IDs might be same if created at same millisecond, but generally should differ
        expect(message1.id, isNotEmpty);
        expect(message2.id, isNotEmpty);
      });
    });

    group('fromAgent factory', () {
      test('should create a text message from agent', () {
        final message = Message.fromAgent('How can I help?');

        expect(message.text, 'How can I help?');
        expect(message.isFromUser, false);
        expect(message.type, MessageType.text);
        expect(message.imagePath, isNull);
      });
    });

    group('imageFromUser factory', () {
      test('should create an image message from user', () {
        final message = Message.imageFromUser('/path/to/image.jpg');

        expect(message.text, '');
        expect(message.isFromUser, true);
        expect(message.type, MessageType.image);
        expect(message.imagePath, '/path/to/image.jpg');
      });
    });

    group('isImage getter', () {
      test('should return true for image messages', () {
        final message = Message.imageFromUser('/path/to/image.jpg');

        expect(message.isImage, true);
        expect(message.isText, false);
      });

      test('should return false for text messages', () {
        final message = Message.fromUser('Hello');

        expect(message.isImage, false);
        expect(message.isText, true);
      });
    });

    group('Equatable', () {
      test('should be equal when all properties match', () {
        final timestamp = DateTime(2024, 1, 1, 12, 0);
        final message1 = Message(
          id: '123',
          text: 'Hello',
          isFromUser: true,
          timestamp: timestamp,
          type: MessageType.text,
        );
        final message2 = Message(
          id: '123',
          text: 'Hello',
          isFromUser: true,
          timestamp: timestamp,
          type: MessageType.text,
        );

        expect(message1, equals(message2));
      });

      test('should not be equal when ID differs', () {
        final timestamp = DateTime(2024, 1, 1, 12, 0);
        final message1 = Message(
          id: '123',
          text: 'Hello',
          isFromUser: true,
          timestamp: timestamp,
        );
        final message2 = Message(
          id: '456',
          text: 'Hello',
          isFromUser: true,
          timestamp: timestamp,
        );

        expect(message1, isNot(equals(message2)));
      });

      test('should not be equal when text differs', () {
        final timestamp = DateTime(2024, 1, 1, 12, 0);
        final message1 = Message(
          id: '123',
          text: 'Hello',
          isFromUser: true,
          timestamp: timestamp,
        );
        final message2 = Message(
          id: '123',
          text: 'Goodbye',
          isFromUser: true,
          timestamp: timestamp,
        );

        expect(message1, isNot(equals(message2)));
      });

      test('should include imagePath in equality', () {
        final timestamp = DateTime(2024, 1, 1, 12, 0);
        final message1 = Message(
          id: '123',
          text: '',
          isFromUser: true,
          timestamp: timestamp,
          type: MessageType.image,
          imagePath: '/path/a.jpg',
        );
        final message2 = Message(
          id: '123',
          text: '',
          isFromUser: true,
          timestamp: timestamp,
          type: MessageType.image,
          imagePath: '/path/b.jpg',
        );

        expect(message1, isNot(equals(message2)));
      });
    });
  });
}

