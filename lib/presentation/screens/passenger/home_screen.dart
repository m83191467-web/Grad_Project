import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_theme.dart';
import '../../../features/user/presentation/bloc/user_data_bloc.dart';
import '../../../features/user/presentation/bloc/user_data_event.dart';
import '../../../features/user/presentation/bloc/user_data_state.dart';

class PassengerHomeScreen extends StatefulWidget {
  const PassengerHomeScreen({super.key});

  @override
  State<PassengerHomeScreen> createState() => _PassengerHomeScreenState();
}

class _PassengerHomeScreenState extends State<PassengerHomeScreen> {
  int _selectedIndex = 0;
  late final Set<Marker> _markers = {};

  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(15.5007, 32.5599),
    zoom: 13.5,
  );

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
    // Fetch available routes when screen loads
    context.read<UserDataBloc>().add(FetchAvailableRoutesRequested());
  }

  Future<void> _requestLocationPermission() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _showPermissionDeniedSnackbar();
        }
      }
      if (permission == LocationPermission.deniedForever) {
        _showPermissionDeniedSnackbar();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'تعذر الحصول على إذن الموقع، يرجى تفعيله من الإعدادات',
            ),
            backgroundColor: AppTheme.danger,
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
  }

  void _showPermissionDeniedSnackbar() {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('مطلوب إذن الموقع لتتبع الحافلات'),
          backgroundColor: AppTheme.danger,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  void _updateMarkersFromRoutes(List<dynamic> routes) {
    _markers.clear();
    for (int i = 0; i < routes.length; i++) {
      final route = routes[i];
      // Generate random nearby coordinates for demo
      final lat = 15.5007 + (i * 0.02);
      final lng = 32.5599 + (i * 0.02);

      _markers.add(
        Marker(
          markerId: MarkerId('route_$i'),
          position: LatLng(lat, lng),
          infoWindow: InfoWindow(
            title: route.startLocation,
            snippet: 'الاتجاه: ${route.endLocation}',
          ),
          icon: i == 0
              ? BitmapDescriptor.defaultMarker
              : BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueGreen,
                ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Text(AppStrings.appName),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none),
          ),
        ],
      ),
      drawer: _buildDrawer(),
      body: SafeArea(
        child: Column(
          children: [
            _buildSearchBar(),
            _buildWelcomeCard(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: BlocListener<UserDataBloc, UserDataState>(
                    listener: (context, state) {
                      if (state is RoutesLoaded) {
                        setState(() {
                          _updateMarkersFromRoutes(state.routes);
                        });
                      }
                    },
                    child: GoogleMap(
                      initialCameraPosition: _initialPosition,
                      markers: _markers,
                      myLocationEnabled: true,
                      myLocationButtonEnabled: true,
                      mapType: MapType.normal,
                    ),
                  ),
                ),
              ),
            ),
            _buildBusList(),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // ========== SEARCH BAR ==========
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              offset: const Offset(0, 4),
              blurRadius: 10,
            ),
          ],
        ),
        child: TextField(
          textAlign: TextAlign.right,
          decoration: InputDecoration(
            hintText: AppStrings.searchRoute,
            border: InputBorder.none,
            prefixIcon: const Icon(
              Icons.search,
              color: AppTheme.textLight,
              size: 20,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
          ),
        ),
      ),
    );
  }

  // ========== WELCOME CARD ==========
  Widget _buildWelcomeCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: AppTheme.primary.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppTheme.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.person, color: Colors.white, size: 18),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${AppStrings.welcome} محمد!',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    'الحافلات • 3 خطوط',
                    style: TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ========== BUS LIST ==========
  Widget _buildBusList() {
    return BlocBuilder<UserDataBloc, UserDataState>(
      builder: (context, state) {
        if (state is RoutesLoaded) {
          if (state.routes.isEmpty) {
            return Container(
              height: 100,
              alignment: Alignment.center,
              child: Text(AppStrings.noTripsFound),
            );
          }

          return Container(
            height: 150,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: state.routes.length,
              itemBuilder: (context, index) {
                final route = state.routes[index];
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: _routeCard(
                    route.id,
                    '${route.startLocation} - ${route.endLocation}',
                    '${route.duration} دقيقة',
                    '${route.fare.toStringAsFixed(0)} جنيه',
                  ),
                );
              },
            ),
          );
        }

        if (state is UserDataLoading) {
          return Container(
            height: 150,
            alignment: Alignment.center,
            child: const CircularProgressIndicator(),
          );
        }

        if (state is UserDataError) {
          return Container(
            height: 150,
            alignment: Alignment.center,
            child: Text('خطأ: ${state.message}'),
          );
        }

        return Container(
          height: 150,
          alignment: Alignment.center,
          child: const CircularProgressIndicator(),
        );
      },
    );
  }

  // ========== ROUTE CARD (FIXED OVERFLOW) ==========
  Widget _routeCard(String busNumber, String route, String eta, String price) {
    return Container(
      width: 200,
      margin: const EdgeInsets.only(left: 4),
      padding: const EdgeInsets.all(10), // reduced padding
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            offset: const Offset(0, 2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Row: icon + number
          Row(
            children: [
              Container(
                width: 24, // smaller
                height: 24,
                decoration: BoxDecoration(
                  color: AppTheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(
                  Icons.directions_bus,
                  color: AppTheme.primary,
                  size: 14,
                ),
              ),
              const Spacer(),
              Text(
                'رقم $busNumber',
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 10, // smaller
                ),
              ),
            ],
          ),
          const SizedBox(height: 3),
          // Route name
          Text(
            route,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 10, // smaller
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 3),
          // ETA
          Row(
            children: [
              const Icon(Icons.access_time, size: 10, color: AppTheme.accent),
              const SizedBox(width: 2),
              Text(
                eta,
                style: const TextStyle(color: AppTheme.accent, fontSize: 9),
              ),
            ],
          ),
          const SizedBox(height: 2),
          // Price
          Row(
            children: [
              const Icon(
                Icons.attach_money,
                size: 10,
                color: AppTheme.secondary,
              ),
              const SizedBox(width: 2),
              Text(
                price,
                style: const TextStyle(
                  color: AppTheme.secondary,
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          // Confirm button - smaller height
          SizedBox(
            width: double.infinity,
            height: 24,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  '/route_details',
                  arguments: {
                    'busNumber': busNumber,
                    'route': route,
                    'price': price,
                    'eta': eta,
                  },
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                foregroundColor: Colors.white,
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                textStyle: const TextStyle(fontSize: 10),
              ),
              child: const Text('تأكيد', style: TextStyle(fontSize: 10)),
            ),
          ),
        ],
      ),
    );
  }

  // ========== BOTTOM NAVIGATION ==========
  Widget _buildBottomNav() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: (index) => setState(() => _selectedIndex = index),
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'الرئيسية'),
        BottomNavigationBarItem(icon: Icon(Icons.map), label: 'الخريطة'),
        BottomNavigationBarItem(icon: Icon(Icons.payment), label: 'الدفع'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'الملف'),
      ],
    );
  }

  // ========== DRAWER ==========
  Widget _buildDrawer() {
    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: AppTheme.primary),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person,
                      size: 34,
                      color: AppTheme.primary,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    'محمد عباس',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  Text(
                    'mohamed@email.com',
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.history),
              title: Text(AppStrings.recentTrips),
              onTap: () {
                Navigator.pushNamed(context, '/trip_history');
              },
            ),
            ListTile(
              leading: const Icon(Icons.payment),
              title: Text(AppStrings.payment),
              onTap: () {
                Navigator.pushNamed(context, '/payment');
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: Text(AppStrings.settings),
              onTap: () {
                Navigator.pushNamed(context, '/profile');
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: AppTheme.danger),
              title: Text(
                AppStrings.logout,
                style: const TextStyle(color: AppTheme.danger),
              ),
              onTap: _logout,
            ),
          ],
        ),
      ),
    );
  }

  // ========== LOGOUT ==========
  void _logout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تسجيل الخروج'),
        content: const Text('هل أنت متأكد من رغبتك في تسجيل الخروج؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppStrings.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/login');
            },
            child: Text(
              AppStrings.logout,
              style: const TextStyle(color: AppTheme.danger),
            ),
          ),
        ],
      ),
    );
  }
}
