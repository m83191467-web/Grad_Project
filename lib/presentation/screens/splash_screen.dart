import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';

import '../../core/constants/app_strings.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/bloc/auth_state.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;
  bool _navigationHandled = false;
  bool _navigationScheduled = false;

  static const _minimumSplashDuration = Duration(milliseconds: 1200);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _scheduleNavigation() {
    if (_navigationHandled || _navigationScheduled) return;

    _navigationScheduled = true;
    Future<void>.delayed(_minimumSplashDuration, () {
      if (!mounted || _navigationHandled) return;

      _navigationHandled = true;
      final state = context.read<AuthBloc>().state;
      if (state is AuthAuthenticated) {
        final route = switch (state.role) {
          'admin' => '/admin_dashboard_enhanced',
          'driver' => '/driver_dashboard_enhanced',
          _ => '/home',
        };
        Navigator.pushReplacementNamed(context, route);
      } else {
        Navigator.pushReplacementNamed(context, '/login');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        // Skip loading state, only process final states
        if (state is AuthLoading) return;

        if (state is AuthAuthenticated ||
            state is AuthUnauthenticated ||
            state is AuthError) {
          _scheduleNavigation();
        }
      },
      builder: (context, state) {
        if (state is AuthAuthenticated ||
            state is AuthUnauthenticated ||
            state is AuthError) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _scheduleNavigation();
          });
        }

        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: const SystemUiOverlayStyle(
            statusBarColor: Colors.black,
            statusBarIconBrightness: Brightness.light,
            statusBarBrightness: Brightness.dark,
            systemNavigationBarColor: Colors.black,
            systemNavigationBarIconBrightness: Brightness.light,
          ),
          child: Scaffold(
            backgroundColor: const Color(0xFF1976D2),
            body: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF1976D2), Color(0xFF535AFF)],
                ),
              ),
              child: Center(
                child: ScaleTransition(
                  scale: _animation,
                  child: Container(
                    width: 181,
                    height: 181,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0xFF1976D2), Color(0xFF535AFF)],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x40000000),
                          blurRadius: 10,
                          offset: Offset(4, 4),
                        ),
                        BoxShadow(
                          color: Color(0x66BDBDBD),
                          blurRadius: 10,
                          offset: Offset(-4, -4),
                        ),
                      ],
                    ),
                    child: Text(
                      AppStrings.appName,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Color(0xFFEDF6FF),
                        fontSize: 52,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -1.5,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
