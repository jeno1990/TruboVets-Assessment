import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app_shell.dart';
import 'core/constants/app_constants.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_cubit.dart';
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
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ThemeCubit()),
        BlocProvider(
          create: (_) =>
              MessageCubit(repository: MessageRepositoryImpl())..loadMessages(),
        ),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp(
            title: AppConstants.appName,
            debugShowCheckedModeBanner: false,

            // Theme configuration
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: themeMode,

            home: const AppShell(),
          );
        },
      ),
    );
  }
}
