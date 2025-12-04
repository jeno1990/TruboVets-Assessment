import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../state/message_cubit.dart';
import '../state/message_state.dart';
import '../widgets/chat_bubble.dart';
import '../widgets/message_input.dart';

/// The main chat page displaying messages and input.
class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  /// Scrolls to the bottom of the message list
  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: BlocConsumer<MessageCubit, MessageState>(
            listener: (context, state) {
              // Scroll to bottom when new message arrives
              if (state is MessageLoaded) {
                _scrollToBottom();
              }
            },
            builder: (context, state) {
              if (state is MessageInitial) {
                return _buildEmptyState(context);
              }

              if (state is MessageLoaded) {
                if (state.messages.isEmpty) {
                  return _buildEmptyState(context);
                }

                return _buildMessageList(context, state);
              }

              return const SizedBox.shrink();
            },
          ),
        ),
        BlocBuilder<MessageCubit, MessageState>(
          builder: (context, state) {
            final isAgentTyping = state is MessageLoaded && state.isAgentTyping;

            return MessageInput(
              onSendText: (text) {
                context.read<MessageCubit>().sendMessage(text);
              },
              onSendImage: (imagePath) {
                context.read<MessageCubit>().sendImageMessage(imagePath);
              },
              isDisabled: isAgentTyping,
            );
          },
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.chat_bubble_outline_rounded,
              size: 40,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Start a Conversation',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Send a message or image to chat with our support agent',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildMessageList(BuildContext context, MessageLoaded state) {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(vertical: 16),
      itemCount: state.messages.length + (state.isAgentTyping ? 1 : 0),
      itemBuilder: (context, index) {
        // Show typing indicator at the end if agent is typing
        if (index == state.messages.length && state.isAgentTyping) {
          return const TypingIndicator();
        }

        return ChatBubble(message: state.messages[index]);
      },
    );
  }
}
