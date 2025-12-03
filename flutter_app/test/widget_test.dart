// Basic widget smoke test for TurboVets app.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_app/app_shell.dart';
import 'package:flutter_app/core/theme/theme_cubit.dart';
import 'package:flutter_app/features/messaging/data/repositories/message_repository_impl.dart';
import 'package:flutter_app/features/messaging/presentation/state/message_cubit.dart';

void main() {
  testWidgets('App shell renders with bottom navigation', (
    WidgetTester tester,
  ) async {
    // Build app with required providers
    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider<ThemeCubit>(create: (_) => ThemeCubit()),
          BlocProvider<MessageCubit>(
            create: (_) => MessageCubit(repository: MessageRepositoryImpl()),
          ),
        ],
        child: const MaterialApp(home: AppShell()),
      ),
    );

    // Verify bottom navigation exists
    expect(find.byType(NavigationBar), findsOneWidget);

    // Verify both navigation destinations exist
    expect(find.text('Messages'), findsOneWidget);
    expect(find.text('Dashboard'), findsOneWidget);
  });

  testWidgets('Messages tab shows empty state initially', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider<ThemeCubit>(create: (_) => ThemeCubit()),
          BlocProvider<MessageCubit>(
            create: (_) =>
                MessageCubit(repository: MessageRepositoryImpl())
                  ..loadMessages(),
          ),
        ],
        child: const MaterialApp(home: AppShell()),
      ),
    );

    await tester.pumpAndSettle();

    // Verify empty state message
    expect(find.text('Start a Conversation'), findsOneWidget);
  });

  testWidgets('Can switch between tabs', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider<ThemeCubit>(create: (_) => ThemeCubit()),
          BlocProvider<MessageCubit>(
            create: (_) =>
                MessageCubit(repository: MessageRepositoryImpl())
                  ..loadMessages(),
          ),
        ],
        child: const MaterialApp(home: AppShell()),
      ),
    );

    // Initially on Messages tab
    expect(find.text('Messages'), findsNWidgets(2)); // Title + Nav item

    // Tap Dashboard tab
    await tester.tap(find.text('Dashboard'));
    await tester.pumpAndSettle();

    // AppBar should now show Dashboard
    expect(find.widgetWithText(AppBar, 'Dashboard'), findsOneWidget);
  });
}
