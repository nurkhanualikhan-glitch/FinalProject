import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubits/auth/auth_cubit.dart';
import '../cubits/settings/settings_cubit.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void register() {
    context.read<AuthCubit>().register(
          username: usernameController.text.trim(),
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );
  }

  Future<void> changeLanguage(String languageCode) async {
    await context.setLocale(Locale(languageCode));

    if (!mounted) return;

    await context.read<SettingsCubit>().setLanguage(languageCode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('register'.tr()),
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
              ),
            );
          }

          if (state is Authenticated) {
            Navigator.pop(context);
          }
        },
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            TextField(
              controller: usernameController,
              decoration: InputDecoration(
                labelText: 'username'.tr(),
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
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
            FilledButton(
              onPressed: register,
              child: Text('register'.tr()),
            ),
          ],
        ),
      ),
    );
  }
}