import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsState {
  final ThemeMode themeMode;
  final String languageCode;
  final String username;

  const SettingsState({
    required this.themeMode,
    required this.languageCode,
    required this.username,
  });

  SettingsState copyWith({
    ThemeMode? themeMode,
    String? languageCode,
    String? username,
  }) {
    return SettingsState(
      themeMode: themeMode ?? this.themeMode,
      languageCode: languageCode ?? this.languageCode,
      username: username ?? this.username,
    );
  }
}

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit()
      : super(
          const SettingsState(
            themeMode: ThemeMode.system,
            languageCode: 'en',
            username: 'User',
          ),
        );

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    emit(
      SettingsState(
        themeMode: _themeFromString(prefs.getString('theme') ?? 'system'),
        languageCode: prefs.getString('language') ?? 'en',
        username: prefs.getString('username') ?? 'User',
      ),
    );
  }

  Future<void> setTheme(ThemeMode themeMode) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('theme', themeMode.name);

    emit(state.copyWith(themeMode: themeMode));
  }

  Future<void> setUsername(String username) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('username', username);

    emit(state.copyWith(username: username));
  }

  Future<void> setLanguage(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('language', languageCode);

    emit(state.copyWith(languageCode: languageCode));
  }

  ThemeMode _themeFromString(String value) {
    switch (value) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }
}
