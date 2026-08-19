import 'package:flutter/material.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_theme.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppStrings.adminDashboard)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: [
                _statCard('الحافلات', '42', AppTheme.primary),
                _statCard('الركاب', '1280', AppTheme.secondary),
                _statCard('الإيرادات', '45,600', AppTheme.accent),
                _statCard('التقييم', '4.8', AppTheme.warning),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              AppStrings.manageRoutes,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            _routeRow('الخط 12', 'الجامعة - السوق', true),
            _routeRow('الخط 5', 'المطار - المدينة', false),
            _routeRow('الخط 8', 'أمدرمان - الخرطوم', true),
            const SizedBox(height: 20),
            Text(
              AppStrings.editPrice,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    TextField(
                      textAlign: TextAlign.right,
                      decoration: const InputDecoration(
                        labelText: 'سعر الكيلومتر',
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      textAlign: TextAlign.right,
                      decoration: const InputDecoration(
                        labelText: 'سعر الوقود',
                      ),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () {},
                      child: Text(AppStrings.updatePrices),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statCard(String label, String value, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(label, style: TextStyle(color: AppTheme.textSecondary)),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _routeRow(String routeName, String destination, bool active) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        title: Text(routeName),
        subtitle: Text(destination),
        trailing: Chip(
          label: Text(active ? 'نشط' : 'متوقف'),
          backgroundColor: active
              ? AppTheme.secondary.withValues(alpha: 0.15)
              : AppTheme.danger.withValues(alpha: 0.15),
        ),
      ),
    );
  }
}
