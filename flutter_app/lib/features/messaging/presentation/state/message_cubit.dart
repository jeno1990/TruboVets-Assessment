import 'dart:async';
import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/message.dart';
import '../../domain/repositories/message_repository.dart';
import 'message_state.dart';

/// Cubit for managing chat message state and operations.
class MessageCubit extends Cubit<MessageState> {
  final MessageRepository _repository;
  final Random _random = Random();

  MessageCubit({required MessageRepository repository})
      : _repository = repository,
        super(const MessageInitial());

  /// Loads existing messages from repository
  void loadMessages() {
    final messages = _repository.getMessages();
    emit(MessageLoaded(messages: messages));
  }

  /// Sends a user text message and triggers simulated agent response
  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    final currentState = state;
    if (currentState is! MessageLoaded) {
      emit(const MessageLoaded(messages: []));
    }

    // Add user message
    final userMessage = Message.fromUser(text.trim());
    _repository.addMessage(userMessage);

    // Update state with user message and show agent typing indicator
    emit(MessageLoaded(
      messages: _repository.getMessages(),
      isAgentTyping: true,
    ));

    // Simulate agent response after random delay
    await _simulateAgentResponse();
  }

  /// Sends a user image message and triggers simulated agent response
  Future<void> sendImageMessage(String imagePath) async {
    final currentState = state;
    if (currentState is! MessageLoaded) {
      emit(const MessageLoaded(messages: []));
    }

    // Add user image message
    final imageMessage = Message.imageFromUser(imagePath);
    _repository.addMessage(imageMessage);

    // Update state with user message and show agent typing indicator
    emit(MessageLoaded(
      messages: _repository.getMessages(),
      isAgentTyping: true,
    ));

    // Simulate agent response after random delay
    await _simulateAgentResponse();
  }

  /// Simulates an agent response with random delay and message
  Future<void> _simulateAgentResponse() async {
    // Random delay between min and max
    final delay = AppConstants.minResponseDelay +
        _random.nextInt(
            AppConstants.maxResponseDelay - AppConstants.minResponseDelay);

    await Future.delayed(Duration(milliseconds: delay));

    // Pick random response from preset list
    final responseText = AppConstants
        .agentResponses[_random.nextInt(AppConstants.agentResponses.length)];

    final agentMessage = Message.fromAgent(responseText);
    _repository.addMessage(agentMessage);

    // Update state with agent message and hide typing indicator
    emit(MessageLoaded(
      messages: _repository.getMessages(),
      isAgentTyping: false,
    ));
  }

  /// Clears all messages
  void clearMessages() {
    _repository.clearMessages();
    emit(const MessageLoaded(messages: []));
  }
}
