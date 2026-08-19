import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_theme.dart';

class TripTrackingScreen extends StatelessWidget {
  const TripTrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const initialPosition = CameraPosition(
      target: LatLng(15.5007, 32.5599),
      zoom: 15,
    );

    final markers = {
      const Marker(
        markerId: MarkerId('bus_current'),
        position: LatLng(15.5007, 32.5599),
        infoWindow: InfoWindow(title: 'الحافلة', snippet: 'تقترب من المحطة'),
      ),
    };

    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: initialPosition,
            markers: markers,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 24,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.directions_bus, color: AppTheme.primary),
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
                      Text(
                        'الوقت المتبقي: 5 دقائق',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Text(
                        'المسافة: 1.2 كم',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.attach_money, color: AppTheme.secondary),
                      const SizedBox(width: 8),
                      Text(
                        'السعر: 150 جنيه',
                        style: const TextStyle(
                          color: AppTheme.secondary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {},
                    child: Text(AppStrings.arriveAlert),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
