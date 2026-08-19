import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/services/location_service.dart';

class TripTrackingScreen extends StatefulWidget {
  const TripTrackingScreen({super.key});

  @override
  State<TripTrackingScreen> createState() => _TripTrackingScreenState();
}

class _TripTrackingScreenState extends State<TripTrackingScreen> {
  static const _defaultPosition = LatLng(15.5007, 32.5599);
  final _locationService = LocationService();
  GoogleMapController? _mapController;
  StreamSubscription<Position>? _locationSubscription;
  LatLng _busPosition = _defaultPosition;
  bool _isAlertEnabled = false;

  @override
  void initState() {
    super.initState();
    _startTracking();
  }

  Future<void> _startTracking() async {
    final permissionGranted = await _locationService.requestPermissions();
    if (!permissionGranted || !mounted) return;

    _locationSubscription = _locationService.getLocationStream().listen((
      position,
    ) {
      final nextPosition = LatLng(position.latitude, position.longitude);
      setState(() => _busPosition = nextPosition);
      _mapController?.animateCamera(CameraUpdate.newLatLng(nextPosition));
    });
  }

  @override
  void dispose() {
    _locationSubscription?.cancel();
    _mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final markers = {
      Marker(
        markerId: const MarkerId('bus_current'),
        position: _busPosition,
        infoWindow: const InfoWindow(
          title: 'الحافلة',
          snippet: 'تقترب من المحطة',
        ),
      ),
    };

    return Scaffold(
      appBar: AppBar(title: const Text('تتبع الرحلة')),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: _defaultPosition,
              zoom: 15,
            ),
            markers: markers,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            onMapCreated: (controller) => _mapController = controller,
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 20,
            child: _buildStatusCard(context),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard(BuildContext context) {
    return Card(
      elevation: 8,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  backgroundColor: AppTheme.primary,
                  child: Icon(Icons.directions_bus, color: Colors.white),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'الحافلة رقم 12',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.success.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'مباشر',
                    style: TextStyle(
                      color: AppTheme.success,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('الوصول المتوقع: 5 دقائق'),
                Text('المسافة: 1.2 كم'),
              ],
            ),
            const SizedBox(height: 14),
            OutlinedButton.icon(
              onPressed: () {
                setState(() => _isAlertEnabled = !_isAlertEnabled);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      _isAlertEnabled
                          ? 'سيتم تنبيهك عند اقتراب الحافلة'
                          : 'تم إيقاف تنبيه الوصول',
                    ),
                  ),
                );
              },
              icon: Icon(
                _isAlertEnabled
                    ? Icons.notifications
                    : Icons.notifications_none,
              ),
              label: Text(
                _isAlertEnabled ? 'التنبيه مفعّل' : AppStrings.arriveAlert,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
