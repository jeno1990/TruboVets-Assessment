import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app_shell.dart';
import 'core/constants/app_constants.dart';
import 'core/theme/app_theme.dart';
import 'features/messaging/data/repositories/message_repository_impl.dart';
import 'features/messaging/presentation/state/message_cubit.dart';

void main() {
  runApp(const TurboVetsApp());
}

/// Main application widget with theme and state management setup.
class TurboVetsApp extends StatelessWidget {
  const TurboVetsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          MessageCubit(repository: MessageRepositoryImpl())..loadMessages(),
      child: MaterialApp(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,

        // Theme configuration - follows system dark/light mode
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: ThemeMode.system,

        home: const AppShell(),
      ),
    );
  }
}
