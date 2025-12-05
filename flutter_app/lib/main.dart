import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

import 'app_shell.dart';
import 'core/constants/app_constants.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_cubit.dart';
import 'data/adapters/message_adapter.dart';
import 'data/repositories/hive_message_repository.dart';
import 'presentation/state/message_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  // Initialize Hive
  await Hive.initFlutter();
  Hive.registerAdapter(MessageAdapter());

  // Initialize message repository
  final messageRepository = HiveMessageRepository();
  await messageRepository.init();

  runApp(TurboVetsApp(messageRepository: messageRepository));
}

class TurboVetsApp extends StatelessWidget {
  final HiveMessageRepository messageRepository;

  const TurboVetsApp({super.key, required this.messageRepository});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ThemeCubit()),
        BlocProvider(
          create: (_) =>
              MessageCubit(repository: messageRepository)..loadMessages(),
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
