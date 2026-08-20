import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_theme.dart';
import '../../../features/user/presentation/bloc/user_data_bloc.dart';
import '../../../features/user/presentation/bloc/user_data_event.dart';
import '../../../features/user/presentation/bloc/user_data_state.dart';
import '../../../presentation/widgets/trip_card.dart';

class EnhancedTripHistoryScreen extends StatefulWidget {
  const EnhancedTripHistoryScreen({super.key});

  @override
  State<EnhancedTripHistoryScreen> createState() =>
      _EnhancedTripHistoryScreenState();
}

class _EnhancedTripHistoryScreenState extends State<EnhancedTripHistoryScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch user trips when screen loads
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      context.read<UserDataBloc>().add(FetchUserTripsRequested(userId));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: AppTheme.textPrimary,
        title: Text(AppStrings.recentTrips),
      ),
      body: BlocBuilder<UserDataBloc, UserDataState>(
        builder: (context, state) {
          if (state is UserDataLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is UserDataError) {
            return Center(
              child: Text(
                'خطأ: ${state.message}',
                textDirection: TextDirection.rtl,
              ),
            );
          }

          if (state is UserTripsLoaded) {
            final trips = state.trips;

            if (trips.isEmpty) {
              return Center(
                child: Text(
                  AppStrings.noTripsFound,
                  textDirection: TextDirection.rtl,
                  style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              );
            }

            // Group trips by date
            Map<String, List<Map<String, dynamic>>> groupedTrips = {};
            for (var trip in trips) {
              final dateStr =
                  '${trip.tripDate.day} ${_getMonthName(trip.tripDate.month)}';
              if (!groupedTrips.containsKey(dateStr)) {
                groupedTrips[dateStr] = [];
              }
              groupedTrips[dateStr]!.add({
                'id': trip.id,
                'routeId': trip.routeId,
                'fare': trip.fareAmount.toStringAsFixed(0),
                'time':
                    '${trip.tripDate.hour.toString().padLeft(2, '0')}:${trip.tripDate.minute.toString().padLeft(2, '0')}',
                'date': dateStr,
                'status': trip.status,
                'rating': trip.rating,
              });
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: groupedTrips.length,
              itemBuilder: (context, index) {
                final date = groupedTrips.keys.elementAt(index);
                final tripsForDate = groupedTrips[date] ?? [];

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Date Header
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Text(
                        date,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textSecondary,
                            ),
                      ),
                    ),

                    // Trip Cards for this date
                    ...List.generate(tripsForDate.length, (tripIndex) {
                      final trip = tripsForDate[tripIndex];
                      return TripCard(
                        busNumber: trip['routeId'] ?? '',
                        route: trip['routeId'] ?? '',
                        price: trip['fare'] ?? '0',
                        time: trip['time'] ?? '',
                        date: trip['date'] ?? '',
                        onRebook: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'تم إعادة حجز الرحلة',
                                textDirection: TextDirection.rtl,
                              ),
                            ),
                          );
                        },
                        onRate: () {
                          _showRatingDialog(
                            context,
                            trip['routeId'] ?? '',
                            trip['id'],
                          );
                        },
                      );
                    }),

                    if (index < groupedTrips.length - 1)
                      const SizedBox(height: 24),
                  ],
                );
              },
            );
          }

          return const Center(child: Text('لا توجد بيانات'));
        },
      ),
    );
  }

  void _showRatingDialog(BuildContext context, String routeId, String tripId) {
    double rating = 5.0;
    final commentController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text('قيم الرحلة - $routeId'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Star Rating
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    5,
                    (index) => IconButton(
                      onPressed: () {
                        setState(() {
                          rating = (index + 1).toDouble();
                        });
                      },
                      icon: Icon(
                        index < rating.toInt() ? Icons.star : Icons.star_border,
                        color: AppTheme.warning,
                        size: 32,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Comment TextField
                TextField(
                  controller: commentController,
                  decoration: InputDecoration(
                    hintText: 'أضف تعليقاً (اختياري)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                  ),
                  maxLines: 3,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: () {
                context.read<UserDataBloc>().add(
                  RateTripRequested(tripId, rating),
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('شكراً لتقييمك: ${rating.toInt()} نجوم'),
                  ),
                );
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
              ),
              child: const Text('إرسال التقييم'),
            ),
          ],
        ),
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      'يناير',
      'فبراير',
      'مارس',
      'أبريل',
      'مايو',
      'يونيو',
      'يوليو',
      'أغسطس',
      'سبتمبر',
      'أكتوبر',
      'نوفمبر',
      'ديسمبر',
    ];
    return months[month - 1];
  }
}
