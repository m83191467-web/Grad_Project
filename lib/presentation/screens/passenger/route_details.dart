import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_theme.dart';
import '../../../features/trip/presentation/bloc/trip_bloc.dart';
import '../../../features/trip/presentation/bloc/trip_event.dart';
import '../../../features/trip/presentation/bloc/trip_state.dart';
import '../../../features/user/presentation/bloc/user_data_bloc.dart';
import '../../../features/user/presentation/bloc/user_data_event.dart';

class RouteDetailsScreen extends StatefulWidget {
  final String? routeId;
  final String? routeName;
  final String? price;
  final String? eta;

  const RouteDetailsScreen({
    super.key,
    this.routeId,
    this.routeName,
    this.price,
    this.eta,
  });

  @override
  State<RouteDetailsScreen> createState() => _RouteDetailsScreenState();
}

class _RouteDetailsScreenState extends State<RouteDetailsScreen> {
  bool _isBooking = false;

  double get _fare {
    final numericPrice = widget.price?.replaceAll(RegExp(r'[^0-9.]'), '');
    return double.tryParse(numericPrice ?? '') ?? 150;
  }

  void _bookTrip() {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('يرجى تسجيل الدخول أولاً')));
      return;
    }

    context.read<TripBloc>().add(
      BookTripEvent(
        userId: userId,
        routeId: widget.routeId ?? 'route_demo',
        fare: _fare,
      ),
    );
    context.read<UserDataBloc>().add(
      BookTripRequested(userId, widget.routeId ?? 'route_demo'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TripBloc, TripState>(
      listener: (context, state) {
        if (state is TripLoading) {
          setState(() => _isBooking = true);
        } else if (state is TripBooked) {
          setState(() => _isBooking = false);
          Navigator.pushReplacementNamed(
            context,
            '/trip_tracking',
            arguments: state.tripId,
          );
        } else if (state is TripError) {
          setState(() => _isBooking = false);
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: Scaffold(
        appBar: AppBar(title: Text(AppStrings.tripDetails)),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.routeName ?? 'الجامعة → السوق',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 16),
                    _infoRow('المسافة', '8.4 كم'),
                    _infoRow('الوقت المتوقع', widget.eta ?? '18 دقيقة'),
                    _infoRow('السعر', widget.price ?? '150 جنيه'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'تفاصيل المسار',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    _routePoint('من', 'جامعة الخرطوم'),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Icon(Icons.swap_vert, color: AppTheme.primary),
                    ),
                    _routePoint('إلى', 'السوق المركزي'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _isBooking ? null : _bookTrip,
              icon: _isBooking
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.check_circle_outline),
              label: Text(
                _isBooking ? 'جارٍ تأكيد الحجز...' : AppStrings.confirmTrip,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppTheme.textSecondary)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }

  Widget _routePoint(String prefix, String value) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: const BoxDecoration(
            color: AppTheme.primary,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(prefix, style: const TextStyle(color: AppTheme.textSecondary)),
            const SizedBox(height: 4),
            Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      ],
    );
  }
}
