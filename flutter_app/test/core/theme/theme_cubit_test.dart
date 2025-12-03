import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_app/core/theme/theme_cubit.dart';

void main() {
  late ThemeCubit cubit;

  setUp(() {
    cubit = ThemeCubit();
  });

  tearDown(() {
    cubit.close();
  });

  group('ThemeCubit', () {
    group('initial state', () {
      test('should be ThemeMode.system', () {
        expect(cubit.state, ThemeMode.system);
      });

      test('isSystemMode should be true initially', () {
        expect(cubit.isSystemMode, true);
      });

      test('isDarkMode should be false initially', () {
        expect(cubit.isDarkMode, false);
      });
    });

    group('setLightMode', () {
      test('should emit ThemeMode.light', () {
        cubit.setLightMode();

        expect(cubit.state, ThemeMode.light);
      });

      test('isDarkMode should be false', () {
        cubit.setLightMode();

        expect(cubit.isDarkMode, false);
      });

      test('isSystemMode should be false', () {
        cubit.setLightMode();

        expect(cubit.isSystemMode, false);
      });
    });

    group('setDarkMode', () {
      test('should emit ThemeMode.dark', () {
        cubit.setDarkMode();

        expect(cubit.state, ThemeMode.dark);
      });

      test('isDarkMode should be true', () {
        cubit.setDarkMode();

        expect(cubit.isDarkMode, true);
      });

      test('isSystemMode should be false', () {
        cubit.setDarkMode();

        expect(cubit.isSystemMode, false);
      });
    });

    group('setSystemMode', () {
      test('should emit ThemeMode.system', () {
        cubit.setDarkMode(); // Change from default first
        cubit.setSystemMode();

        expect(cubit.state, ThemeMode.system);
      });

      test('isSystemMode should be true', () {
        cubit.setDarkMode();
        cubit.setSystemMode();

        expect(cubit.isSystemMode, true);
      });
    });

    group('toggleTheme', () {
      test('should switch from light to dark', () {
        cubit.setLightMode();
        expect(cubit.state, ThemeMode.light);

        cubit.toggleTheme();

        expect(cubit.state, ThemeMode.dark);
      });

      test('should switch from dark to light', () {
        cubit.setDarkMode();
        expect(cubit.state, ThemeMode.dark);

        cubit.toggleTheme();

        expect(cubit.state, ThemeMode.light);
      });

      test('should switch from system to dark', () {
        expect(cubit.state, ThemeMode.system);

        cubit.toggleTheme();

        expect(cubit.state, ThemeMode.light);
      });
    });

    group('state transitions', () {
      test('should handle multiple transitions correctly', () {
        expect(cubit.state, ThemeMode.system);

        cubit.setDarkMode();
        expect(cubit.state, ThemeMode.dark);

        cubit.setLightMode();
        expect(cubit.state, ThemeMode.light);

        cubit.setSystemMode();
        expect(cubit.state, ThemeMode.system);

        cubit.toggleTheme();
        expect(cubit.state, ThemeMode.light);

        cubit.toggleTheme();
        expect(cubit.state, ThemeMode.dark);
      });

      test('calling same mode multiple times should not cause issues', () {
        cubit.setDarkMode();
        cubit.setDarkMode();
        cubit.setDarkMode();

        expect(cubit.state, ThemeMode.dark);
      });
    });

    group('stream behavior', () {
      test('should emit states in correct order', () async {
        final states = <ThemeMode>[];
        final subscription = cubit.stream.listen(states.add);

        cubit.setLightMode();
        cubit.setDarkMode();
        cubit.setSystemMode();

        await Future.delayed(Duration.zero);
        await subscription.cancel();

        expect(states, [ThemeMode.light, ThemeMode.dark, ThemeMode.system]);
      });
    });
  });
}

