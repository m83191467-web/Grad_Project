import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_theme.dart';
import '../../../models/user_model.dart';
import '../../../providers/language_provider.dart';
import '../../../providers/theme_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final Future<UserModel?> _userProfileFuture;

  @override
  void initState() {
    super.initState();
    _userProfileFuture = _loadCurrentUserProfile();
  }

  Future<UserModel?> _loadCurrentUserProfile() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return null;

    final document = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .get();
    final data = document.data() ?? <String, dynamic>{};

    return UserModel.fromMap({
      ...data,
      'name': data['name'] ?? currentUser.displayName ?? '',
      'email': data['email'] ?? currentUser.email ?? '',
      'phone': data['phone'] ?? currentUser.phoneNumber ?? '',
    }, currentUser.uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppStrings.profile)),
      body: FutureBuilder<UserModel?>(
        future: _userProfileFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('خطأ: ${snapshot.error}'));
          }

          final user = snapshot.data;
          if (user == null) {
            return const Center(child: Text('لا يوجد مستخدم مسجل الدخول'));
          }

          return Padding(
            padding: const EdgeInsets.all(16),
            child: ListView(
              children: [
                const SizedBox(height: 12),
                Center(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: AppTheme.primary.withValues(alpha: 0.12),
                    backgroundImage: user.avatar?.isNotEmpty == true
                        ? NetworkImage(user.avatar!)
                        : null,
                    child: user.avatar?.isNotEmpty == true
                        ? null
                        : const Icon(
                            Icons.person,
                            size: 54,
                            color: AppTheme.primary,
                          ),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: Text(
                    user.name,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
                const SizedBox(height: 8),
                Center(
                  child: Text(
                    user.phone,
                    style: TextStyle(color: AppTheme.textSecondary),
                  ),
                ),
                const SizedBox(height: 4),
                Center(
                  child: Text(
                    user.email,
                    style: TextStyle(color: AppTheme.textSecondary),
                  ),
                ),
                const SizedBox(height: 20),
                Card(
                  child: Column(
                    children: [
                      SwitchListTile(
                        title: Text(AppStrings.darkMode),
                        value: context.watch<ThemeProvider>().isDarkMode,
                        onChanged: (enabled) => context
                            .read<ThemeProvider>()
                            .toggleDarkMode(enabled),
                      ),
                      SwitchListTile(
                        title: Text(AppStrings.notifications),
                        value: true,
                        onChanged: (_) {},
                      ),
                      ListTile(
                        leading: const Icon(Icons.language),
                        title: Text(AppStrings.language),
                        subtitle: Text(
                          context
                                      .watch<LanguageProvider>()
                                      .locale
                                      .languageCode ==
                                  'ar'
                              ? 'العربية'
                              : 'English',
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios_rounded),
                        onTap: () => _showLanguagePicker(context),
                      ),
                      ListTile(
                        leading: const Icon(Icons.lock),
                        title: Text(AppStrings.changePassword),
                        trailing: const Icon(Icons.arrow_forward_ios_rounded),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.credit_card),
                        title: Text(AppStrings.creditCard),
                      ),
                      ListTile(
                        leading: const Icon(Icons.wallet),
                        title: Text(AppStrings.wallet),
                        trailing: const Text('1250 ج'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.danger,
                  ),
                  onPressed: _signOut,
                  child: Text(AppStrings.logout),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showLanguagePicker(BuildContext context) {
    final language = context.read<LanguageProvider>();
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const ListTile(
              title: Text('اختر اللغة', textAlign: TextAlign.right),
            ),
            RadioGroup<String>(
              groupValue: language.locale.languageCode,
              onChanged: (value) {
                if (value != null) language.changeLanguage(value);
                Navigator.pop(sheetContext);
              },
              child: const Column(
                children: [
                  RadioListTile<String>(value: 'ar', title: Text('العربية')),
                  RadioListTile<String>(value: 'en', title: Text('English')),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, '/login', (_) => false);
  }
}
