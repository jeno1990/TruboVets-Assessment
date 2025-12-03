import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/constants/app_constants.dart';
import 'core/theme/theme_cubit.dart';
import 'features/dashboard_webview/presentation/pages/dashboard_page.dart';
import 'features/messaging/presentation/pages/chat_page.dart';
import 'features/messaging/presentation/state/message_cubit.dart';
import 'features/messaging/presentation/state/message_state.dart';

/// The main app shell with bottom navigation and settings drawer.
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
    return SafeArea(
      child: Scaffold(
        appBar: _currentIndex == 0
            ? AppBar(
                title: Text(
                  _currentIndex == 0
                      ? AppConstants.messagesLabel
                      : AppConstants.dashboardLabel,
                ),
                // actions: [
                //   if (_currentIndex == 0)
                //     BlocBuilder<MessageCubit, MessageState>(
                //       builder: (context, state) {
                //         final hasMessages =
                //             state is MessageLoaded && state.messages.isNotEmpty;

                //         if (!hasMessages) return const SizedBox.shrink();

                //         return IconButton(
                //           onPressed: () => _showClearMessagesDialog(context),
                //           icon: const Icon(Icons.delete_outline_rounded),
                //           tooltip: 'Clear messages',
                //         );
                //       },
                //     ),
                // ],
              )
            : null,
        drawer: _buildSettingsDrawer(context),
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
      ),
    );
  }

  Widget _buildSettingsDrawer(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.rocket,
                      color: colorScheme.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    AppConstants.appName,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),

            // Settings section
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
              child: Text(
                'Settings',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            // Theme toggle
            BlocBuilder<ThemeCubit, ThemeMode>(
              builder: (context, themeMode) {
                return ListTile(
                  leading: Icon(
                    themeMode == ThemeMode.dark
                        ? Icons.dark_mode_rounded
                        : themeMode == ThemeMode.light
                        ? Icons.light_mode_rounded
                        : Icons.brightness_auto_rounded,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  title: const Text('Dark Mode'),
                  subtitle: Text(
                    themeMode == ThemeMode.system
                        ? 'Following system'
                        : themeMode == ThemeMode.dark
                        ? 'On'
                        : 'Off',
                  ),
                  trailing: Switch(
                    value: themeMode == ThemeMode.dark,
                    onChanged: (value) {
                      if (value) {
                        context.read<ThemeCubit>().setDarkMode();
                      } else {
                        context.read<ThemeCubit>().setLightMode();
                      }
                    },
                  ),
                  onTap: () => context.read<ThemeCubit>().toggleTheme(),
                );
              },
            ),

            // System theme option
            BlocBuilder<ThemeCubit, ThemeMode>(
              builder: (context, themeMode) {
                return ListTile(
                  leading: Icon(
                    Icons.smartphone_rounded,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  title: const Text('Use System Theme'),
                  trailing: Radio<ThemeMode>(
                    value: ThemeMode.system,
                    groupValue: themeMode,
                    onChanged: (_) {
                      context.read<ThemeCubit>().setSystemMode();
                    },
                  ),
                  onTap: () => context.read<ThemeCubit>().setSystemMode(),
                );
              },
            ),

            const Spacer(),

            // Version info
            Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                'Version 1.0.0',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant.withOpacity(0.6),
                ),
              ),
            ),
          ],
        ),
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
