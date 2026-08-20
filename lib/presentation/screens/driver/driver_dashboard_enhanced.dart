import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../core/theme/app_theme.dart';

class DriverDashboardEnhanced extends StatefulWidget {
  const DriverDashboardEnhanced({super.key});

  @override
  State<DriverDashboardEnhanced> createState() =>
      _DriverDashboardEnhancedState();
}

class _DriverDashboardEnhancedState extends State<DriverDashboardEnhanced> {
  bool _isOnline = true;
  bool _tripStarted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Driver center'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none_rounded),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          _statusCard(),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
            child: const SizedBox(
              height: 220,
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(15.5007, 32.5599),
                  zoom: 13,
                ),
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
              ),
            ),
          ),
          const SizedBox(height: 14),
          _requestCard(),
          const SizedBox(height: 14),
          Row(
            children: [
              _metric('Today', '1,240 EGP', Icons.payments_outlined),
              const SizedBox(width: 10),
              _metric('Trips', '12', Icons.route_rounded),
              const SizedBox(width: 10),
              _metric('Rating', '4.9', Icons.star_rounded),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statusCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const CircleAvatar(
              backgroundColor: AppTheme.primaryLight,
              child: Icon(Icons.person, color: AppTheme.primary),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Good morning, Sam',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
                  ),
                  SizedBox(height: 3),
                  Text(
                    'Ready when you are',
                    style: TextStyle(color: AppTheme.textSecondary),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                Text(
                  _isOnline ? 'ONLINE' : 'OFFLINE',
                  style: TextStyle(
                    color: _isOnline
                        ? AppTheme.success
                        : AppTheme.textSecondary,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Switch.adaptive(
                  value: _isOnline,
                  onChanged: (value) => setState(() => _isOnline = value),
                  activeThumbColor: AppTheme.secondary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _requestCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.notifications_active_rounded,
                  color: AppTheme.accent,
                ),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'New ride request',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
                  ),
                ),
                Text('2 min ago', style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
            const SizedBox(height: 16),
            _stop(
              'Pickup',
              'Riverside Mall',
              Icons.radio_button_checked_rounded,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 11),
              child: Container(height: 18, width: 2, color: AppTheme.outline),
            ),
            _stop('Drop-off', 'Central Station', Icons.location_on_rounded),
            const SizedBox(height: 14),
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Estimated fare\n145 EGP · 6.2 km',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isOnline
                        ? () => setState(() => _tripStarted = true)
                        : null,
                    child: Text(_tripStarted ? 'Trip started' : 'Accept ride'),
                  ),
                ),
              ],
            ),
            if (_tripStarted) ...[
              const SizedBox(height: 10),
              OutlinedButton.icon(
                onPressed: () {
                  setState(() => _tripStarted = false);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Trip completed. Earnings updated.'),
                    ),
                  );
                },
                icon: const Icon(Icons.flag_rounded),
                label: const Text('Complete trip'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _stop(String label, String place, IconData icon) {
    return Row(
      children: [
        Icon(
          icon,
          color: label == 'Pickup' ? AppTheme.secondary : AppTheme.danger,
          size: 22,
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 12,
              ),
            ),
            Text(place, style: const TextStyle(fontWeight: FontWeight.w700)),
          ],
        ),
      ],
    );
  }

  Widget _metric(String label, String value, IconData icon) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
          child: Column(
            children: [
              Icon(icon, color: AppTheme.primary),
              const SizedBox(height: 7),
              Text(value, style: const TextStyle(fontWeight: FontWeight.w800)),
              Text(
                label,
                style: const TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
