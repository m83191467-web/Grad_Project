import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';

class TripManagementScreen extends StatefulWidget {
  const TripManagementScreen({super.key});

  @override
  State<TripManagementScreen> createState() => _TripManagementScreenState();
}

class _TripManagementScreenState extends State<TripManagementScreen> {
  final stops = [
    {'name': 'محطة الجامعة', 'passengers': 5, 'status': 'مكتملة'},
    {'name': 'محطة السوق', 'passengers': 3, 'status': 'جارية'},
    {'name': 'محطة المطار', 'passengers': 2, 'status': 'معلقة'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('إدارة الرحلة')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            // Trip Info Card
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.directions_bus,
                          color: AppTheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'حافلة رقم 12',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'الركاب الحاليين',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: AppTheme.textSecondary),
                            ),
                            const Text(
                              '15 راكب',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'المقاعد المتبقية',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: AppTheme.textSecondary),
                            ),
                            const Text(
                              '10 مقاعد',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                                color: AppTheme.secondary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Stops List
            Text('المحطات', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            ...List.generate(stops.length, (index) {
              final stop = stops[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: AppTheme.primary,
                    child: Text(
                      '${index + 1}',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  title: Text(stop['name'] as String),
                  subtitle: Text('${stop['passengers']} ركاب'),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: stop['status'] == 'مكتملة'
                          ? AppTheme.secondary
                          : stop['status'] == 'جارية'
                          ? AppTheme.warning
                          : AppTheme.textLight,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      stop['status'] as String,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              );
            }),
            const SizedBox(height: 24),

            // Action Buttons
            ElevatedButton.icon(
              onPressed: () {
                _showAddPassengerDialog(context);
              },
              icon: const Icon(Icons.person_add),
              label: const Text('تسجيل راكب جديد'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('تم إنهاء الرحلة')),
                );
                Navigator.pop(context);
              },
              icon: const Icon(Icons.check_circle),
              label: const Text('إنهاء الرحلة'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.secondary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddPassengerDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تسجيل راكب جديد'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'اسم الراكب',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'رقم الهاتف',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('تم تسجيل الراكب بنجاح')),
              );
              Navigator.pop(context);
            },
            child: const Text('تسجيل'),
          ),
        ],
      ),
    );
  }
}
