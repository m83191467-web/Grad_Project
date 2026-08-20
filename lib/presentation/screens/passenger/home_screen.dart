import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_theme.dart';
import '../../../features/user/presentation/bloc/user_data_bloc.dart';
import '../../../features/user/presentation/bloc/user_data_event.dart';
import '../../../features/user/presentation/bloc/user_data_state.dart';
import '../../../models/route_model.dart';
import '../../../models/user_model.dart';

class PassengerHomeScreen extends StatefulWidget {
  const PassengerHomeScreen({super.key});

  @override
  State<PassengerHomeScreen> createState() => _PassengerHomeScreenState();
}

class _PassengerHomeScreenState extends State<PassengerHomeScreen> {
  int _selectedIndex = 0;
  late final Set<Marker> _markers = {};
  GoogleMapController? _mapController;
  List<RouteModel> _availableRoutes = [];
  late final Future<UserModel?> _userProfileFuture;
  bool _showWelcomeCard = true;

  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(15.5007, 32.5599),
    zoom: 13.5,
  );

  @override
  void initState() {
    super.initState();
    _userProfileFuture = _loadCurrentUserProfile();
    Future<void>.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        setState(() => _showWelcomeCard = false);
      }
    });
    _requestLocationPermission();
    context.read<UserDataBloc>().add(FetchAvailableRoutesRequested());
  }

  Future<UserModel?> _loadCurrentUserProfile() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return null;

    final document = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .get();
    final data = document.data() ?? <String, dynamic>{};

    return UserModel.fromMap({
      ...data,
      'name': data['name'] ?? currentUser.displayName ?? '',
      'email': data['email'] ?? currentUser.email ?? '',
      'phone': data['phone'] ?? currentUser.phoneNumber ?? '',
    }, currentUser.uid);
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

  void _updateMarkersFromRoutes(List<RouteModel> routes) {
    _availableRoutes = routes;
    _markers.clear();
    for (int i = 0; i < routes.length; i++) {
      final route = routes[i];
      final position = _positionForRoute(i);

      _markers.add(
        Marker(
          markerId: MarkerId('route_$i'),
          position: position,
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

  LatLng _positionForRoute(int index) {
    return LatLng(15.5007 + (index * 0.02), 32.5599 + (index * 0.02));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: Text(AppStrings.appName),
        actions: [
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('لا توجد إشعارات جديدة')),
              );
            },
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
                      onMapCreated: (controller) => _mapController = controller,
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
          readOnly: true,
          onTap: _showDestinationPicker,
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
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 450),
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: SizeTransition(
            sizeFactor: animation,
            alignment: Alignment.topCenter,
            child: child,
          ),
        );
      },
      child: _showWelcomeCard
          ? FutureBuilder<UserModel?>(
              future: _userProfileFuture,
              builder: (context, snapshot) {
                final user = snapshot.data;
                final fullName = user?.name.trim() ?? '';
                final displayName = fullName.isNotEmpty
                    ? fullName.split(RegExp(r'\s+')).first
                    : 'مستخدم';

                return Directionality(
                  textDirection: TextDirection.rtl,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 4,
                    ),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.primary.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              '${AppStrings.welcome} $displayName!',
                              textAlign: TextAlign.right,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            )
          : const SizedBox(key: ValueKey('welcome-card-hidden')),
    );
  }

  Widget _buildAvatar(UserModel? user, double radius) {
    return CircleAvatar(
      radius: radius / 2,
      backgroundColor: AppTheme.primary,
      backgroundImage: user?.avatar?.isNotEmpty == true
          ? NetworkImage(user!.avatar!)
          : null,
      child: user?.avatar?.isNotEmpty == true
          ? null
          : Icon(Icons.person, color: Colors.white, size: radius * 0.55),
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
            height: 180,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: state.routes.length,
              itemBuilder: (context, index) {
                final route = state.routes[index];
                return Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: _beautifulRouteCard(
                    route.id,
                    '${route.startLocation} - ${route.endLocation}',
                    '${route.duration} دقيقة',
                    '${route.fare.toStringAsFixed(0)} جنيه',
                    index,
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

  // ============================================================
  // 🌟 BEAUTIFUL ROUTE CARD — REDESIGNED
  // ============================================================
  Widget _beautifulRouteCard(
    String busNumber,
    String route,
    String eta,
    String price,
    int index,
  ) {
    // Color palette — each card gets a unique gradient
    final List<List<Color>> gradients = [
      [const Color(0xFF667eea), const Color(0xFF764ba2)],
      [const Color(0xFFf093fb), const Color(0xFFf5576c)],
      [const Color(0xFF4facfe), const Color(0xFF00f2fe)],
      [const Color(0xFF43e97b), const Color(0xFF38f9d7)],
      [const Color(0xFFfa709a), const Color(0xFFfee140)],
      [const Color(0xFFa18cd1), const Color(0xFFfbc2eb)],
    ];

    final gradientColors = gradients[index % gradients.length];

    return Container(
      width: 210,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradientColors,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: gradientColors.last.withValues(alpha: 0.4),
            offset: const Offset(0, 8),
            blurRadius: 20,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Stack(
        children: [
          // Decorative circles
          Positioned(
            top: -10,
            right: -10,
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -20,
            left: -20,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Top row: bus icon + number + badge
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.25),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.directions_bus,
                            color: Colors.white,
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'رقم $busNumber',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '● مباشر',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // Route name
                Text(
                  route,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    height: 1.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                // ETA + Price row
                Row(
                  children: [
                    _buildInfoChip(
                      icon: Icons.access_time,
                      label: eta,
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                    const SizedBox(width: 10),
                    _buildInfoChip(
                      icon: Icons.attach_money,
                      label: price,
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // Confirm button
                SizedBox(
                  width: double.infinity,
                  height: 32,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        '/route_details',
                        arguments: {
                          'routeId': busNumber,
                          'busNumber': busNumber,
                          'route': route,
                          'price': price,
                          'eta': eta,
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: gradientColors.first,
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                      textStyle: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('تأكيد الحجز'),
                        SizedBox(width: 4),
                        Icon(Icons.arrow_forward, size: 14),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 12),
          const SizedBox(width: 3),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.w600,
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
      onTap: _handleBottomNavigation,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'الرئيسية'),
        BottomNavigationBarItem(icon: Icon(Icons.history), label: 'رحلاتي'),
        BottomNavigationBarItem(icon: Icon(Icons.map), label: 'الخريطة'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'الملف'),
      ],
    );
  }

  void _handleBottomNavigation(int index) {
    setState(() => _selectedIndex = index);
    switch (index) {
      case 1:
        Navigator.pushNamed(context, '/trip_history');
        break;
      case 2:
        _showDestinationPicker();
        break;
      case 3:
        Navigator.pushNamed(context, '/profile');
        break;
    }
  }

  void _showDestinationPicker() {
    var destination = '';
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            final query = destination.trim().toLowerCase();
            final results = query.isEmpty
                ? _availableRoutes
                : _availableRoutes.where((route) {
                    final searchable =
                        '${route.startLocation} ${route.endLocation}'
                            .toLowerCase();
                    return searchable.contains(query);
                  }).toList();

            return Padding(
              padding: EdgeInsets.fromLTRB(
                20,
                8,
                20,
                MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'إلى أين تريد الذهاب؟',
                    style: Theme.of(context).textTheme.headlineSmall,
                    textAlign: TextAlign.right,
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    autofocus: true,
                    textAlign: TextAlign.right,
                    onChanged: (value) {
                      setSheetState(() => destination = value);
                    },
                    decoration: const InputDecoration(
                      labelText: 'ابحث عن وجهة أو خط سير',
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (_availableRoutes.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        'لا توجد رحلات متاحة حالياً',
                        textAlign: TextAlign.center,
                      ),
                    )
                  else if (results.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        'لم يتم العثور على رحلة بهذه الوجهة',
                        textAlign: TextAlign.center,
                      ),
                    )
                  else
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 280),
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemCount: results.length,
                        separatorBuilder: (_, _) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final route = results[index];
                          final routeIndex = _availableRoutes.indexOf(route);
                          return ListTile(
                            leading: const CircleAvatar(
                              backgroundColor: AppTheme.primary,
                              child: Icon(
                                Icons.directions_bus,
                                color: Colors.white,
                              ),
                            ),
                            title: Text(
                              '${route.startLocation} → ${route.endLocation}',
                              textAlign: TextAlign.right,
                            ),
                            subtitle: Text(
                              '${route.duration} دقيقة · ${route.fare.toStringAsFixed(0)} جنيه',
                              textAlign: TextAlign.right,
                            ),
                            onTap: () => _selectRouteFromSearch(
                              sheetContext,
                              route,
                              routeIndex,
                            ),
                          );
                        },
                      ),
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _selectRouteFromSearch(
    BuildContext sheetContext,
    RouteModel route,
    int routeIndex,
  ) {
    Navigator.pop(sheetContext);
    _mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(_positionForRoute(routeIndex), 14.5),
    );
    Navigator.pushNamed(
      context,
      '/route_details',
      arguments: {
        'routeId': route.id,
        'route': '${route.startLocation} - ${route.endLocation}',
        'price': '${route.fare.toStringAsFixed(0)} جنيه',
        'eta': '${route.duration} دقيقة',
      },
    );
  }

  // ========== DRAWER ==========
  Widget _buildDrawer() {
    return Drawer(
      child: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: FutureBuilder<UserModel?>(
          future: _userProfileFuture,
          builder: (context, snapshot) {
            final user = snapshot.data;
            final displayName = user?.name.trim().isNotEmpty == true
                ? user!.name
                : 'مستخدم';

            return ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  decoration: const BoxDecoration(color: AppTheme.primary),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildAvatar(user, 60),
                      const SizedBox(height: 12),
                      Text(
                        displayName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        user?.email ?? '',
                        style: const TextStyle(color: Colors.white70),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
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
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('الدفع الإلكتروني سيكون متاحاً قريباً'),
                      ),
                    );
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
            );
          },
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
            onPressed: () async {
              final navigator = Navigator.of(context);
              Navigator.pop(context);
              await FirebaseAuth.instance.signOut();
              if (!mounted) return;
              navigator.pushNamedAndRemoveUntil('/login', (_) => false);
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
