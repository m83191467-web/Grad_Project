import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';
import 'map_screen.dart';

class PassengerScreen extends StatefulWidget {
  const PassengerScreen({super.key});

  @override
  State<PassengerScreen> createState() => _PassengerScreenState();
}

class _PassengerScreenState extends State<PassengerScreen> {
  int _selectedTab = 0;
  bool _showDestination = false;

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
            'Good morning, Alex',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 4),
          Text(
            'Where are you headed?',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () => setState(() => _showDestination = !_showDestination),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
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
              onPressed: () =>
                  _showMessage('Choose a destination to see your fare.'),
              icon: const Icon(Icons.auto_awesome_rounded, size: 18),
              label: const Text('Find a ride'),
            ),
          ),
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
      onTap: () => _showMessage('$title selected.'),
    );
  }

  Widget _quickPlace(IconData icon, String title, String time) {
    return Material(
      color: AppTheme.background,
      borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        onTap: () => _showMessage('Routing to $title.'),
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
