import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../core/theme/app_theme.dart';
import '../features/trip/presentation/bloc/trip_bloc.dart';
import '../features/trip/presentation/bloc/trip_event.dart';
import 'map_screen.dart';

class PassengerScreen extends StatefulWidget {
  const PassengerScreen({super.key});

  @override
  State<PassengerScreen> createState() => _PassengerScreenState();
}

class _PassengerScreenState extends State<PassengerScreen> {
  int _selectedTab = 0;
  bool _showDestination = false;
  String? _activeRide;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildDrawer(context),
      body: Stack(
        children: [
          const Positioned.fill(child: MapScreen()),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 14, 18, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _roundButton(
                        icon: Icons.menu_rounded,
                        onTap: () => Scaffold.of(context).openDrawer(),
                      ),
                      _brandMark(),
                      _roundButton(
                        icon: Icons.notifications_none_rounded,
                        onTap: () => _showMessage('You are all caught up.'),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                _buildRideSheet(context),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildNavigationBar(),
    );
  }

  Widget _buildRideSheet(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 18),
      decoration: const BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        boxShadow: AppTheme.softShadow,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 42,
              height: 4,
              decoration: BoxDecoration(
                color: AppTheme.outline,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          const SizedBox(height: 18),
          Text(
            _activeRide == null
                ? 'Good morning, Alex'
                : 'Your ride is on the way',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 4),
          Text(
            _activeRide == null
                ? 'Where are you headed?'
                : 'Meet your driver at the pickup point',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          if (_activeRide != null) ...[
            _activeTripCard(),
          ] else ...[
            GestureDetector(
              onTap: () => setState(() => _showDestination = !_showDestination),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceMuted,
                  borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search_rounded, color: AppTheme.primary),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _showDestination
                            ? 'Search for a destination'
                            : 'Plan a new ride',
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios_rounded, size: 15),
                  ],
                ),
              ),
            ),
            if (_showDestination) ...[
              const SizedBox(height: 10),
              _locationRow(
                Icons.my_location_rounded,
                'Current location',
                'Using your GPS position',
              ),
              _locationRow(
                Icons.location_on_rounded,
                'Downtown Station',
                'Saved place · 2.4 km away',
              ),
            ] else ...[
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: _quickPlace(Icons.home_rounded, 'Home', '12 min'),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _quickPlace(
                      Icons.work_outline_rounded,
                      'Work',
                      '18 min',
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _showRideOptions,
                icon: const Icon(Icons.auto_awesome_rounded, size: 18),
                label: const Text('Find a ride'),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _locationRow(IconData icon, String title, String subtitle) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      dense: true,
      leading: Icon(icon, color: AppTheme.secondary),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right_rounded),
      onTap: () {
        setState(() => _showDestination = true);
        _showRideOptions();
      },
    );
  }

  Widget _quickPlace(IconData icon, String title, String time) {
    return Material(
      color: AppTheme.background,
      borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        onTap: () {
          setState(() => _showDestination = true);
          _showRideOptions();
        },
        child: Padding(
          padding: const EdgeInsets.all(13),
          child: Row(
            children: [
              Icon(icon, color: AppTheme.primary, size: 20),
              const SizedBox(width: 9),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  Text(
                    time,
                    style: const TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _activeTripCard() {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.primaryDark,
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundColor: AppTheme.secondary,
            child: Icon(
              Icons.directions_car_filled_rounded,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Navio Comfort',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'Arriving in 4 min · Silver Toyota',
                  style: TextStyle(color: AppTheme.primaryLight, fontSize: 12),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => _showMessage('Calling your driver...'),
            icon: const Icon(Icons.phone_rounded, color: AppTheme.accent),
          ),
        ],
      ),
    );
  }

  Future<void> _showRideOptions() async {
    final choice = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 22),
        decoration: const BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 42,
                height: 4,
                decoration: BoxDecoration(
                  color: AppTheme.outline,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'Choose your ride',
              style: TextStyle(fontSize: 21, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 5),
            const Text(
              'Comfortable rides, transparent prices.',
              style: TextStyle(color: AppTheme.textSecondary),
            ),
            const SizedBox(height: 15),
            _rideOption(
              context,
              'Navio Go',
              'Everyday rides',
              'From 85 EGP',
              Icons.directions_car_filled_rounded,
              false,
            ),
            _rideOption(
              context,
              'Navio Comfort',
              'More space, more calm',
              'From 120 EGP',
              Icons.airline_seat_recline_extra_rounded,
              true,
            ),
            _rideOption(
              context,
              'Navio Green',
              'Lower-emission vehicles',
              'From 105 EGP',
              Icons.eco_rounded,
              false,
            ),
          ],
        ),
      ),
    );
    if (!mounted || choice == null) return;
    setState(() => _activeRide = choice);
    final userId = FirebaseAuth.instance.currentUser?.uid ?? 'demo-passenger';
    context.read<TripBloc>().add(
      BookTripEvent(userId: userId, routeId: 'downtown-station', fare: 120),
    );
    _showMessage('Your $choice ride is being matched.');
  }

  Widget _rideOption(
    BuildContext context,
    String title,
    String subtitle,
    String price,
    IconData icon,
    bool recommended,
  ) {
    return InkWell(
      borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
      onTap: () => Navigator.pop(context, title),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
          color: recommended ? AppTheme.primaryLight : AppTheme.background,
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          border: recommended
              ? Border.all(color: AppTheme.secondary, width: 1.2)
              : null,
        ),
        child: Row(
          children: [
            Icon(icon, color: AppTheme.primary, size: 28),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (recommended)
                  const Text(
                    'RECOMMENDED',
                    style: TextStyle(
                      color: AppTheme.secondary,
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                Text(
                  price,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _roundButton({required IconData icon, required VoidCallback onTap}) {
    return Material(
      color: AppTheme.surface,
      elevation: 3,
      shadowColor: const Color(0x250D2B45),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Icon(icon, color: AppTheme.primary),
        ),
      ),
    );
  }

  Widget _brandMark() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.primary,
        borderRadius: BorderRadius.circular(AppTheme.radiusPill),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.route_rounded, color: AppTheme.accent, size: 18),
          SizedBox(width: 6),
          Text(
            'NAVIO',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationBar() {
    return NavigationBar(
      selectedIndex: _selectedTab,
      onDestinationSelected: (index) {
        setState(() => _selectedTab = index);
        if (index != 0) {
          _showMessage(
            index == 1
                ? 'Your trips will appear here.'
                : 'Your profile is ready.',
          );
        }
      },
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.explore_outlined),
          selectedIcon: Icon(Icons.explore),
          label: 'Explore',
        ),
        NavigationDestination(
          icon: Icon(Icons.receipt_long_outlined),
          selectedIcon: Icon(Icons.receipt_long),
          label: 'Trips',
        ),
        NavigationDestination(
          icon: Icon(Icons.person_outline),
          selectedIcon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    );
  }

  Drawer _buildDrawer(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(22, 24, 22, 22),
              color: AppTheme.primary,
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: AppTheme.primaryLight,
                    child: Icon(Icons.person, color: AppTheme.primary),
                  ),
                  SizedBox(height: 14),
                  Text(
                    'Alex Morgan',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    'Member since 2024',
                    style: TextStyle(color: AppTheme.primaryLight),
                  ),
                ],
              ),
            ),
            _drawerTile(Icons.person_outline, 'Profile'),
            _drawerTile(Icons.history_rounded, 'Ride history'),
            _drawerTile(Icons.account_balance_wallet_outlined, 'Payments'),
            _drawerTile(Icons.help_outline_rounded, 'Help center'),
            const Divider(height: 20),
            _drawerTile(Icons.logout_rounded, 'Sign out'),
          ],
        ),
      ),
    );
  }

  ListTile _drawerTile(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.primary),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      trailing: const Icon(Icons.chevron_right_rounded, size: 18),
      onTap: () => _showMessage('$title selected.'),
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}
