import 'package:flutter/material.dart';

import '../../../core/constants/app_strings.dart';

class TripHistoryScreen extends StatelessWidget {
  const TripHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final trips = [
      {'route': 'الجامعة - السوق', 'date': '12 أغسطس 2026', 'price': '150 ج'},
      {'route': 'المطار - المدينة', 'date': '08 أغسطس 2026', 'price': '200 ج'},
      {'route': 'أمدرمان - الخرطوم', 'date': '04 أغسطس 2026', 'price': '180 ج'},
    ];

    return Scaffold(
      appBar: AppBar(title: Text(AppStrings.recentTrips)),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: trips.length,
        itemBuilder: (context, index) {
          final trip = trips[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: const Icon(Icons.directions_bus),
              title: Text(trip['route'] ?? ''),
              subtitle: Text(trip['date'] ?? ''),
              trailing: Text(
                trip['price'] ?? '',
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          );
        },
      ),
    );
  }
}
