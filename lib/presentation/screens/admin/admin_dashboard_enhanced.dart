import 'package:flutter/material.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_theme.dart';

class AdminDashboardEnhanced extends StatefulWidget {
  const AdminDashboardEnhanced({super.key});

  @override
  State<AdminDashboardEnhanced> createState() => _AdminDashboardEnhancedState();
}

class _AdminDashboardEnhancedState extends State<AdminDashboardEnhanced> {
  double _pricePerKm = 2.5;
  double _fuelPrice = 1.2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppStrings.adminDashboard), elevation: 0),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Statistics Grid
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                children: [
                  _statCard(
                    context,
                    AppStrings.totalBuses,
                    '42',
                    AppTheme.primary,
                  ),
                  _statCard(
                    context,
                    AppStrings.totalPassengers,
                    '1,280',
                    AppTheme.secondary,
                  ),
                  _statCard(
                    context,
                    'الإيرادات اليومية',
                    '45,600 ج',
                    AppTheme.accent,
                  ),
                  _statCard(
                    context,
                    AppStrings.averageRating,
                    '4.8 ⭐',
                    AppTheme.warning,
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Route Management Section
              Text(
                AppStrings.manageRoutes,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              Card(
                child: Column(
                  children: [
                    _routeListItem(
                      context,
                      'الخط 1: الجامعة - السوق',
                      '12 كم',
                      '150 ج',
                    ),
                    const Divider(),
                    _routeListItem(
                      context,
                      'الخط 2: المطار - المدينة',
                      '25 كم',
                      '250 ج',
                    ),
                    const Divider(),
                    _routeListItem(
                      context,
                      'الخط 3: أمدرمان - الخرطوم',
                      '18 كم',
                      '200 ج',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Pricing Section
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
                      _priceInputField(
                        context,
                        AppStrings.pricePerKm,
                        _pricePerKm.toString(),
                        (value) {
                          setState(() {
                            _pricePerKm = double.tryParse(value) ?? 2.5;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      _priceInputField(
                        context,
                        AppStrings.fuelPrice,
                        _fuelPrice.toString(),
                        (value) {
                          setState(() {
                            _fuelPrice = double.tryParse(value) ?? 1.2;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('تم تحديث الأسعار بنجاح'),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primary,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 48),
                        ),
                        child: Text(AppStrings.updatePrices),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Driver Performance Section
              Text(
                AppStrings.driverPerformance,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              Card(
                child: Column(
                  children: [
                    _driverListItem(context, 'أحمد محمد', '45 رحلة', '4.9 ⭐'),
                    const Divider(),
                    _driverListItem(context, 'فاطمة علي', '38 رحلة', '4.7 ⭐'),
                    const Divider(),
                    _driverListItem(context, 'محمود حسن', '52 رحلة', '4.6 ⭐'),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statCard(
    BuildContext context,
    String label,
    String value,
    Color color,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.trending_up, color: color, size: 28),
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: AppTheme.textSecondary),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _routeListItem(
    BuildContext context,
    String name,
    String distance,
    String price,
  ) {
    return ListTile(
      leading: const Icon(Icons.route, color: AppTheme.primary),
      title: Text(name),
      subtitle: Text('$distance • $price'),
      trailing: PopupMenuButton(
        itemBuilder: (context) => [
          const PopupMenuItem(child: Text('تعديل')),
          const PopupMenuItem(child: Text('حذف')),
        ],
      ),
    );
  }

  Widget _priceInputField(
    BuildContext context,
    String label,
    String value,
    Function(String) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        TextField(
          decoration: InputDecoration(
            hintText: value,
            suffixText: label == AppStrings.pricePerKm ? 'ج' : '',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
          ),
          keyboardType: TextInputType.number,
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _driverListItem(
    BuildContext context,
    String name,
    String trips,
    String rating,
  ) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: AppTheme.primary.withValues(alpha: 0.12),
        child: const Icon(Icons.person, color: AppTheme.primary),
      ),
      title: Text(name),
      subtitle: Text(trips),
      trailing: Text(
        rating,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          color: AppTheme.warning,
        ),
      ),
    );
  }
}
