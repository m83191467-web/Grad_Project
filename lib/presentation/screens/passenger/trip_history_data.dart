import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_theme.dart';
import '../../../features/user/presentation/bloc/user_data_bloc.dart';
import '../../../features/user/presentation/bloc/user_data_event.dart';
import '../../../features/user/presentation/bloc/user_data_state.dart';

class TripHistoryScreenWithData extends StatefulWidget {
  const TripHistoryScreenWithData({super.key});

  @override
  State<TripHistoryScreenWithData> createState() =>
      _TripHistoryScreenWithDataState();
}

class _TripHistoryScreenWithDataState extends State<TripHistoryScreenWithData> {
  @override
  void initState() {
    super.initState();
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      context.read<UserDataBloc>().add(
        FetchUserTripsRequested(currentUser.uid),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppStrings.recentTrips)),
      body: BlocListener<UserDataBloc, UserDataState>(
        listener: (context, state) {
          if (state is UserDataError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        child: BlocBuilder<UserDataBloc, UserDataState>(
          builder: (context, state) {
            if (state is UserDataLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is UserTripsLoaded) {
              if (state.trips.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.history,
                        size: 64,
                        color: AppTheme.textSecondary.withValues(alpha: 0.5),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'لا توجد رحلات بعد',
                        style: TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.trips.length,
                itemBuilder: (context, index) {
                  final trip = state.trips[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      leading: const Icon(Icons.directions_bus),
                      title: Text('رحلة #${trip.id.substring(0, 8)}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            DateFormat(
                              'dd MMM yyyy - hh:mm a',
                              'ar_SA',
                            ).format(trip.tripDate),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'الحالة: ${trip.status}',
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${trip.fareAmount.toStringAsFixed(1)} ج',
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              color: AppTheme.secondary,
                            ),
                          ),
                          if (trip.rating != null)
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.star,
                                  size: 14,
                                  color: AppTheme.accent,
                                ),
                                const SizedBox(width: 2),
                                Text(
                                  trip.rating!.toStringAsFixed(1),
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }

            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.history,
                    size: 64,
                    color: AppTheme.textSecondary.withValues(alpha: 0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'لا توجد رحلات بعد',
                    style: TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
