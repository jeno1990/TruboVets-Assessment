import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_app/domain/entities/message.dart';
import 'package:flutter_app/domain/repositories/message_repository.dart';
import 'package:flutter_app/presentation/state/message_cubit.dart';
import 'package:flutter_app/presentation/state/message_state.dart';

class MockMessageRepository extends Mock implements MessageRepository {}

class FakeMessage extends Fake implements Message {}

void main() {
  late MessageCubit cubit;
  late MockMessageRepository mockRepository;

  setUpAll(() {
    registerFallbackValue(FakeMessage());
  });

  setUp(() {
    mockRepository = MockMessageRepository();
    cubit = MessageCubit(repository: mockRepository);
  });

  tearDown(() {
    cubit.close();
  });

  group('MessageCubit', () {
    group('initial state', () {
      test('should be MessageInitial', () {
        expect(cubit.state, isA<MessageInitial>());
      });
    });

    group('loadMessages', () {
      test('should emit MessageLoaded with empty list when no messages', () {
        when(() => mockRepository.getMessages()).thenReturn([]);

        cubit.loadMessages();

        expect(cubit.state, isA<MessageLoaded>());
        expect((cubit.state as MessageLoaded).messages, isEmpty);
      });

      test('should emit MessageLoaded with messages from repository', () {
        final messages = [
          Message.fromUser('Hello'),
          Message.fromAgent('Hi there'),
        ];
        when(() => mockRepository.getMessages()).thenReturn(messages);

        cubit.loadMessages();

        expect(cubit.state, isA<MessageLoaded>());
        expect((cubit.state as MessageLoaded).messages, messages);
      });
    });

    group('sendMessage', () {
      test('should not add empty message', () async {
        when(() => mockRepository.getMessages()).thenReturn([]);

        await cubit.sendMessage('');

        verifyNever(() => mockRepository.addMessage(any()));
      });

      test('should not add whitespace-only message', () async {
        when(() => mockRepository.getMessages()).thenReturn([]);

        await cubit.sendMessage('   ');

        verifyNever(() => mockRepository.addMessage(any()));
      });

      test('should add user message to repository', () async {
        when(() => mockRepository.getMessages()).thenReturn([]);
        when(() => mockRepository.addMessage(any())).thenReturn(null);

        await cubit.sendMessage('Hello');

        verify(
          () => mockRepository.addMessage(any()),
        ).called(2); // User + Agent
      });

      test(
        'should show typing indicator while waiting for agent response',
        () async {
          when(() => mockRepository.getMessages()).thenReturn([]);
          when(() => mockRepository.addMessage(any())).thenReturn(null);

          // Start sending but don't await
          final future = cubit.sendMessage('Hello');

          // Check intermediate state (typing indicator)
          await Future.delayed(const Duration(milliseconds: 100));
          if (cubit.state is MessageLoaded) {
            expect((cubit.state as MessageLoaded).isAgentTyping, true);
          }

          await future;

          // After completion, typing should be false
          expect((cubit.state as MessageLoaded).isAgentTyping, false);
        },
      );

      test('should emit MessageLoaded after sending', () async {
        final userMessage = Message.fromUser('Hello');
        when(() => mockRepository.getMessages()).thenReturn([userMessage]);
        when(() => mockRepository.addMessage(any())).thenReturn(null);

        await cubit.sendMessage('Hello');

        expect(cubit.state, isA<MessageLoaded>());
      });
    });

    group('sendImageMessage', () {
      test('should add image message to repository', () async {
        when(() => mockRepository.getMessages()).thenReturn([]);
        when(() => mockRepository.addMessage(any())).thenReturn(null);

        await cubit.sendImageMessage('/path/to/image.jpg');

        verify(
          () => mockRepository.addMessage(any()),
        ).called(2); // Image + Agent
      });

      test('should trigger agent response after image', () async {
        when(() => mockRepository.getMessages()).thenReturn([]);
        when(() => mockRepository.addMessage(any())).thenReturn(null);

        await cubit.sendImageMessage('/path/to/image.jpg');

        // Agent response is added
        verify(() => mockRepository.addMessage(any())).called(2);
      });
    });

    group('clearMessages', () {
      test('should call repository clearMessages', () {
        when(() => mockRepository.clearMessages()).thenReturn(null);

        cubit.clearMessages();

        verify(() => mockRepository.clearMessages()).called(1);
      });

      test('should emit MessageLoaded with empty list', () {
        when(() => mockRepository.clearMessages()).thenReturn(null);

        cubit.clearMessages();

        expect(cubit.state, isA<MessageLoaded>());
        expect((cubit.state as MessageLoaded).messages, isEmpty);
      });
    });
  });

  group('MessageState', () {
    test('MessageInitial props should be empty', () {
      const state = MessageInitial();
      expect(state.props, isEmpty);
    });

    test('MessageLoaded should contain messages and typing status', () {
      final messages = [Message.fromUser('Test')];
      final state = MessageLoaded(messages: messages, isAgentTyping: true);

      expect(state.messages, messages);
      expect(state.isAgentTyping, true);
      expect(state.props, [messages, true]);
    });

    test('MessageLoaded.copyWith should create new instance with changes', () {
      final messages = [Message.fromUser('Test')];
      final state = MessageLoaded(messages: messages, isAgentTyping: false);

      final newState = state.copyWith(isAgentTyping: true);

      expect(newState.messages, messages);
      expect(newState.isAgentTyping, true);
      expect(state.isAgentTyping, false); // Original unchanged
    });
  });
}
