import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';

class AdminDashboardEnhanced extends StatefulWidget {
  const AdminDashboardEnhanced({super.key});

  @override
  State<AdminDashboardEnhanced> createState() => _AdminDashboardEnhancedState();
}

class _AdminDashboardEnhancedState extends State<AdminDashboardEnhanced> {
  double _baseFare = 35;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Operations dashboard'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.download_outlined),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Today at a glance',
            style: TextStyle(fontSize: 21, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 14),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            children: [
              _stat('Live rides', '86', Icons.route_rounded, AppTheme.primary),
              _stat(
                'Active drivers',
                '142',
                Icons.people_alt_outlined,
                AppTheme.secondary,
              ),
              _stat(
                'Revenue today',
                '45,600 EGP',
                Icons.payments_outlined,
                AppTheme.accent,
              ),
              _stat('Avg. rating', '4.8', Icons.star_rounded, AppTheme.warning),
            ],
          ),
          const SizedBox(height: 24),
          const Text(
            'Pricing controls',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 10),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Base fare',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                      Text(
                        '${_baseFare.toStringAsFixed(0)} EGP',
                        style: const TextStyle(fontWeight: FontWeight.w800),
                      ),
                    ],
                  ),
                  Slider(
                    value: _baseFare,
                    min: 20,
                    max: 80,
                    divisions: 12,
                    label: '${_baseFare.toStringAsFixed(0)} EGP',
                    onChanged: (value) => setState(() => _baseFare = value),
                  ),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Changes apply to new ride estimates.',
                      style: TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Driver performance',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 10),
          Card(
            child: Column(
              children: [
                _driver('Maya Chen', '98 trips · 4.9 rating', '98%'),
                const Divider(height: 1),
                _driver('Omar Hassan', '86 trips · 4.8 rating', '94%'),
                const Divider(height: 1),
                _driver('Lina Joseph', '72 trips · 4.7 rating', '91%'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _stat(String label, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 10),
            Text(
              value,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 3),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _driver(String name, String detail, String completion) {
    return ListTile(
      leading: const CircleAvatar(
        backgroundColor: AppTheme.primaryLight,
        child: Icon(Icons.person, color: AppTheme.primary),
      ),
      title: Text(name, style: const TextStyle(fontWeight: FontWeight.w700)),
      subtitle: Text(detail),
      trailing: Text(
        completion,
        style: const TextStyle(
          color: AppTheme.success,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
