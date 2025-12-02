import 'package:equatable/equatable.dart';

import '../../domain/entities/message.dart';

/// Base state class for messaging feature
abstract class MessageState extends Equatable {
  const MessageState();

  @override
  List<Object?> get props => [];
}

/// Initial state before any messages are loaded
class MessageInitial extends MessageState {
  const MessageInitial();
}

/// State when messages are loaded and ready to display
class MessageLoaded extends MessageState {
  /// List of all messages in the chat
  final List<Message> messages;

  /// Whether the agent is currently "typing" a response
  final bool isAgentTyping;

  const MessageLoaded({
    required this.messages,
    this.isAgentTyping = false,
  });

  /// Creates a copy with optional parameter overrides
  MessageLoaded copyWith({
    List<Message>? messages,
    bool? isAgentTyping,
  }) {
    return MessageLoaded(
      messages: messages ?? this.messages,
      isAgentTyping: isAgentTyping ?? this.isAgentTyping,
    );
  }

  @override
  List<Object?> get props => [messages, isAgentTyping];
}

