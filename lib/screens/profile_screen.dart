import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubits/auth/auth_cubit.dart';
import '../cubits/posts/post_cubit.dart';
import '../cubits/settings/settings_cubit.dart';
import '../widgets/post_card.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final usernameController = TextEditingController();

  @override
  void dispose() {
    usernameController.dispose();
    super.dispose();
  }

  Future<void> changeLanguage(String languageCode) async {
    await context.setLocale(Locale(languageCode));

    if (!mounted) return;

    await context.read<SettingsCubit>().setLanguage(languageCode);
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('profile'.tr()),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          CircleAvatar(
            radius: 40,
            child: Text(
              (user?.email ?? 'U')[0].toUpperCase(),
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: Text(user?.email ?? ''),
          ),
          const SizedBox(height: 24),
          BlocBuilder<SettingsCubit, SettingsState>(
            builder: (context, settings) {
              usernameController.text = settings.username;

              return Column(
                children: [
                  TextField(
                    controller: usernameController,
                    decoration: InputDecoration(
                      labelText: 'username'.tr(),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () {
                        context
                            .read<SettingsCubit>()
                            .setUsername(usernameController.text.trim());
                      },
                      child: Text('save'.tr()),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SwitchListTile(
                    title: Text('dark_mode'.tr()),
                    value: settings.themeMode == ThemeMode.dark,
                    onChanged: (value) {
                      context.read<SettingsCubit>().setTheme(
                            value ? ThemeMode.dark : ThemeMode.light,
                          );
                    },
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: context.locale.languageCode,
                    decoration: InputDecoration(
                      labelText: 'language'.tr(),
                      border: const OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'en',
                        child: Text('English'),
                      ),
                      DropdownMenuItem(
                        value: 'ru',
                        child: Text('Русский'),
                      ),
                      DropdownMenuItem(
                        value: 'kk',
                        child: Text('Қазақша'),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        changeLanguage(value);
                      }
                    },
                  ),
                ],
              );
            },
          ),
          const Divider(height: 36),
          Text(
            'my_posts'.tr(),
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          BlocBuilder<PostCubit, PostState>(
            builder: (context, state) {
              if (state is! PostLoaded) {
                return const SizedBox();
              }

              final myPosts = state.posts
                  .where((post) => post.userId == user?.uid)
                  .toList();

              if (myPosts.isEmpty) {
                return Text('no_posts'.tr());
              }

              return Column(
                children: myPosts
                    .map(
                      (post) => PostCard(post: post),
                    )
                    .toList(),
              );
            },
          ),
          const SizedBox(height: 24),
          OutlinedButton.icon(
            onPressed: () {
              context.read<AuthCubit>().logout();
            },
            icon: const Icon(Icons.logout),
            label: Text('logout'.tr()),
          ),
        ],
      ),
    );
  }
}
