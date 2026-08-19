import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_theme.dart';

class DriverDashboardEnhanced extends StatefulWidget {
  const DriverDashboardEnhanced({super.key});

  @override
  State<DriverDashboardEnhanced> createState() =>
      _DriverDashboardEnhancedState();
}

class _DriverDashboardEnhancedState extends State<DriverDashboardEnhanced> {
  bool _isOnline = true;

  @override
  Widget build(BuildContext context) {
    const initialPosition = CameraPosition(
      target: LatLng(15.5007, 32.5599),
      zoom: 15,
    );

    return Scaffold(
      appBar: AppBar(title: Text(AppStrings.driverDashboard), elevation: 0),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Map Section
            SizedBox(
              height: 250,
              child: GoogleMap(
                initialCameraPosition: initialPosition,
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                markers: {
                  const Marker(
                    markerId: MarkerId('bus'),
                    position: LatLng(15.5007, 32.5599),
                    infoWindow: InfoWindow(title: 'حافلتك الحالية'),
                  ),
                },
              ),
            ),

            // Status Section
            Container(
              color: AppTheme.surface,
              padding: const EdgeInsets.all(16),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppStrings.status,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: AppTheme.textSecondary),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: _isOnline
                                  ? AppTheme.secondary
                                  : AppTheme.textLight,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              _isOnline
                                  ? AppStrings.online
                                  : AppStrings.offline,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Switch.adaptive(
                        value: _isOnline,
                        onChanged: (value) {
                          setState(() {
                            _isOnline = value;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                _isOnline
                                    ? 'أنت الآن متصل'
                                    : 'أنت الآن غير متصل',
                              ),
                            ),
                          );
                        },
                        activeColor: AppTheme.secondary,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Route Info Section
            Padding(
              padding: const EdgeInsets.all(16),
              child: Card(
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
                            'الخط رقم 42',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _infoColumn(context, AppStrings.passengers, '15/25'),
                          _infoColumn(context, 'الإيرادات اليومية', '1,500 ج'),
                          _infoColumn(context, 'متوسط التقييم', '4.8'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Action Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('تم بدء الرحلة')),
                      );
                    },
                    icon: const Icon(Icons.play_arrow),
                    label: Text(AppStrings.startTrip),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primary,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 48),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('تم إنهاء الرحلة')),
                      );
                    },
                    icon: const Icon(Icons.stop_circle),
                    label: Text(AppStrings.endTrip),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.secondary,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 48),
                    ),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pushNamed(context, '/trip_management');
                    },
                    icon: const Icon(Icons.person_add),
                    label: Text(AppStrings.registerPassenger),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.primary,
                      minimumSize: const Size(double.infinity, 48),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoColumn(BuildContext context, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: AppTheme.textSecondary),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
