import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/settings/settings_cubit.dart';
import '../cubits/auth/auth_cubit.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
Future<void> changeLanguage(String languageCode) async {
  await context.setLocale(Locale(languageCode));

  if (!mounted) return;

  await context.read<SettingsCubit>().setLanguage(languageCode);
}
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void login() {
    context.read<AuthCubit>().login(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
  title: Text('app_title'.tr()),
  actions: [
    Padding(
      padding: const EdgeInsets.only(right: 12),
      child: DropdownButton<String>(
        value: context.locale.languageCode,
        underline: const SizedBox(),
        items: const [
          DropdownMenuItem(value: 'en', child: Text('EN')),
          DropdownMenuItem(value: 'ru', child: Text('RU')),
          DropdownMenuItem(value: 'kk', child: Text('KZ')),
        ],
        onChanged: (value) {
          if (value != null) {
            changeLanguage(value);
          }
        },
      ),
    ),
  ],
),
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(state.message),
      action: SnackBarAction(
        label: 'Register',
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const RegisterScreen(),
            ),
          );
        },
      ),
    ),
  );
}
        },
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.people_alt_rounded,
                      size: 64,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'app_title'.tr(),
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 24),
                    TextField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'email'.tr(),
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'password'.tr(),
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: login,
                        child: Text('login'.tr()),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (_, animation, __) {
                              return FadeTransition(
                                opacity: animation,
                                child: const RegisterScreen(),
                              );
                            },
                          ),
                        );
                      },
                      child: Text('create_account'.tr()),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
