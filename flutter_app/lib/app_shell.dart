import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/constants/app_constants.dart';
import 'features/dashboard_webview/presentation/pages/dashboard_page.dart';
import 'features/messaging/presentation/pages/chat_page.dart';
import 'features/messaging/presentation/state/message_cubit.dart';
import 'features/messaging/presentation/state/message_state.dart';

/// The main app shell with bottom navigation.
class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _currentIndex = 0;

  static const List<Widget> _pages = [ChatPage(), DashboardPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _currentIndex == 0
              ? AppConstants.messagesLabel
              : AppConstants.dashboardLabel,
        ),
        actions: [
          if (_currentIndex == 0)
            BlocBuilder<MessageCubit, MessageState>(
              builder: (context, state) {
                final hasMessages =
                    state is MessageLoaded && state.messages.isNotEmpty;

                if (!hasMessages) return const SizedBox.shrink();

                return IconButton(
                  onPressed: () => _showClearMessagesDialog(context),
                  icon: const Icon(Icons.delete_outline_rounded),
                  tooltip: 'Clear messages',
                );
              },
            ),
        ],
      ),
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() => _currentIndex = index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.chat_bubble_outline_rounded),
            selectedIcon: Icon(Icons.chat_bubble_rounded),
            label: AppConstants.messagesLabel,
          ),
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard_rounded),
            label: AppConstants.dashboardLabel,
          ),
        ],
      ),
    );
  }

  void _showClearMessagesDialog(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Clear Messages'),
        content: const Text(
          'Are you sure you want to clear all messages? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              context.read<MessageCubit>().clearMessages();
              Navigator.pop(dialogContext);
            },
            style: FilledButton.styleFrom(
              backgroundColor: colorScheme.error,
              foregroundColor: colorScheme.onError,
            ),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }
}
