import 'package:flutter/material.dart';

import '../screens/admin/admin_dashboard.dart';
import '../screens/admin/admin_dashboard_enhanced.dart';
import '../screens/driver/driver_dashboard.dart';
import '../screens/driver/driver_dashboard_enhanced.dart';
import '../screens/driver/trip_management.dart';
import '../screens/login_screen.dart';
import '../screens/onboarding_screen.dart';
import '../screens/passenger/home_screen.dart';
import '../screens/passenger/route_details.dart';
import '../screens/passenger/trip_history_enhanced.dart';
import '../screens/passenger/trip_tracking.dart';
import '../screens/passenger/trip_tracking_enhanced.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/profile/profile_screen_enhanced.dart';
import '../screens/register_screen.dart';
import '../screens/splash_screen.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/splash':
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case '/onboarding':
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());
      case '/login':
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case '/register':
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case '/home':
        return MaterialPageRoute(builder: (_) => const PassengerHomeScreen());
      case '/route_details':
        final arguments = settings.arguments;
        final data = arguments is Map ? arguments : const <String, dynamic>{};
        return MaterialPageRoute(
          builder: (_) => RouteDetailsScreen(
            routeId: data['routeId'] as String?,
            routeName: data['route'] as String?,
            price: data['price'] as String?,
            eta: data['eta'] as String?,
          ),
        );
      case '/trip_history':
        return MaterialPageRoute(
          builder: (_) => const EnhancedTripHistoryScreen(),
        );
      case '/trip_history_enhanced':
        return MaterialPageRoute(
          builder: (_) => const EnhancedTripHistoryScreen(),
        );
      case '/trip_tracking':
        return MaterialPageRoute(builder: (_) => const TripTrackingScreen());
      case '/trip_tracking_enhanced':
        return MaterialPageRoute(
          builder: (_) => const EnhancedTripTrackingScreen(),
        );
      case '/driver_dashboard':
        return MaterialPageRoute(builder: (_) => const DriverDashboard());
      case '/driver_dashboard_enhanced':
        return MaterialPageRoute(
          builder: (_) => const DriverDashboardEnhanced(),
        );
      case '/trip_management':
        return MaterialPageRoute(builder: (_) => const TripManagementScreen());
      case '/admin_dashboard':
        return MaterialPageRoute(builder: (_) => const AdminDashboard());
      case '/admin_dashboard_enhanced':
        return MaterialPageRoute(
          builder: (_) => const AdminDashboardEnhanced(),
        );
      case '/profile':
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      case '/profile_enhanced':
        return MaterialPageRoute(builder: (_) => const EnhancedProfileScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
