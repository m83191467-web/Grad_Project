import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/constants/app_strings.dart';
import '../../core/theme/app_theme.dart';
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

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        // Skip loading state, only process final states
        if (state is AuthLoading) return;

        if (!_navigationHandled) {
          _navigationHandled = true;

          if (state is AuthAuthenticated) {
            Navigator.pushReplacementNamed(context, '/home');
          } else if (state is AuthUnauthenticated) {
            Navigator.pushReplacementNamed(context, '/login');
          } else if (state is AuthError) {
            Navigator.pushReplacementNamed(context, '/login');
          }
        }
      },
      builder: (context, state) {
        // If we're already authenticated or unauthenticated, navigate immediately
        if (!_navigationHandled) {
          if (state is AuthAuthenticated) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!_navigationHandled) {
                _navigationHandled = true;
                Navigator.pushReplacementNamed(context, '/home');
              }
            });
          } else if (state is AuthUnauthenticated) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!_navigationHandled) {
                _navigationHandled = true;
                Navigator.pushReplacementNamed(context, '/login');
              }
            });
          } else if (state is AuthError) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!_navigationHandled) {
                _navigationHandled = true;
                Navigator.pushReplacementNamed(context, '/login');
              }
            });
          }
        }

        return Scaffold(
          body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [AppTheme.primary, AppTheme.primaryDark],
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ScaleTransition(
                  scale: _animation,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Icon(
                      Icons.directions_bus,
                      size: 60,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  AppStrings.appName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 48),
                const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
