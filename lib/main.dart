import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'firebase_options.dart';
import 'cubits/api/api_cubit.dart';
import 'cubits/auth/auth_cubit.dart';
import 'cubits/posts/post_cubit.dart';
import 'cubits/settings/settings_cubit.dart';
import 'screens/auth_gate.dart';
import 'services/api_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await EasyLocalization.ensureInitialized();
 await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);

  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('en'),
        Locale('ru'),
        Locale('kk'),
      ],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: const SocialHubApp(),
    ),
  );
}

class SocialHubApp extends StatelessWidget {
  const SocialHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => SettingsCubit()..loadSettings()),
        BlocProvider(create: (_) => AuthCubit()..checkAuthState()),
        BlocProvider(create: (_) => PostCubit()..loadPosts()),
        BlocProvider(create: (_) => ApiCubit(ApiService())..loadQuotes()),
      ],
      child: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, settings) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Social Hub',
            locale: context.locale,
            supportedLocales: context.supportedLocales,
            localizationsDelegates: context.localizationDelegates,
            themeMode: settings.themeMode,
            theme: ThemeData(
              useMaterial3: true,
              brightness: Brightness.light,
              colorSchemeSeed: Colors.indigo,
            ),
            darkTheme: ThemeData(
              useMaterial3: true,
              brightness: Brightness.dark,
              colorSchemeSeed: Colors.indigo,
            ),
            home: const AuthGate(),
          );
        },
      ),
    );
  }
}
