import 'package:flutter/material.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppStrings.profile)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            const SizedBox(height: 12),
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundColor: AppTheme.primary.withValues(alpha: 0.12),
                child: const Icon(
                  Icons.person,
                  size: 54,
                  color: AppTheme.primary,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Text(
                'محمد عباس',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                '+966 500 000 000',
                style: TextStyle(color: AppTheme.textSecondary),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              child: Column(
                children: [
                  SwitchListTile(
                    title: Text(AppStrings.darkMode),
                    value: false,
                    onChanged: (_) {},
                  ),
                  SwitchListTile(
                    title: Text(AppStrings.notifications),
                    value: true,
                    onChanged: (_) {},
                  ),
                  ListTile(
                    leading: const Icon(Icons.language),
                    title: Text(AppStrings.language),
                    trailing: const Icon(Icons.arrow_forward_ios_rounded),
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
              style: ElevatedButton.styleFrom(backgroundColor: AppTheme.danger),
              onPressed: () {},
              child: Text(AppStrings.logout),
            ),
          ],
        ),
      ),
    );
  }
}
