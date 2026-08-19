import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_theme.dart';
import '../../../features/user/presentation/bloc/user_data_bloc.dart';
import '../../../features/user/presentation/bloc/user_data_event.dart';
import '../../../features/user/presentation/bloc/user_data_state.dart';
import '../../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../../features/auth/presentation/bloc/auth_event.dart';

class ProfileScreenWithData extends StatefulWidget {
  const ProfileScreenWithData({super.key});

  @override
  State<ProfileScreenWithData> createState() => _ProfileScreenWithDataState();
}

class _ProfileScreenWithDataState extends State<ProfileScreenWithData> {
  @override
  void initState() {
    super.initState();
    // Fetch user profile when screen loads
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      context.read<UserDataBloc>().add(
        FetchUserProfileRequested(currentUser.uid),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppStrings.profile)),
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

            if (state is UserProfileLoaded) {
              final user = state.userProfile;
              return Padding(
                padding: const EdgeInsets.all(16),
                child: ListView(
                  children: [
                    const SizedBox(height: 12),
                    Center(
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: AppTheme.primary.withValues(
                          alpha: 0.12,
                        ),
                        backgroundImage: user.avatar != null
                            ? NetworkImage(user.avatar!)
                            : null,
                        child: user.avatar == null
                            ? const Icon(
                                Icons.person,
                                size: 54,
                                color: AppTheme.primary,
                              )
                            : null,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: Text(
                        user.name,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Center(
                      child: Text(
                        user.phone,
                        style: TextStyle(color: AppTheme.textSecondary),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Center(
                      child: Text(
                        user.email,
                        style: TextStyle(color: AppTheme.textSecondary),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.secondary.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          user.type,
                          style: TextStyle(
                            color: AppTheme.secondary,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    if (user.rating != null) ...[
                      const SizedBox(height: 12),
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.star,
                              color: AppTheme.accent,
                              size: 20,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${user.rating!.toStringAsFixed(1)}/5',
                              style: TextStyle(
                                color: AppTheme.textSecondary,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 20),
                    Card(
                      child: Column(
                        children: [
                          SwitchListTile(
                            title: Text(AppStrings.darkMode),
                            value: false,
                            onChanged: (_) {},
                          ),
                          SwitchListTile(
                            title: Text(AppStrings.notifications),
                            value: true,
                            onChanged: (_) {},
                          ),
                          ListTile(
                            leading: const Icon(Icons.language),
                            title: Text(AppStrings.language),
                            trailing: const Icon(
                              Icons.arrow_forward_ios_rounded,
                            ),
                          ),
                          ListTile(
                            leading: const Icon(Icons.lock),
                            title: Text(AppStrings.changePassword),
                            trailing: const Icon(
                              Icons.arrow_forward_ios_rounded,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Card(
                      child: Column(
                        children: [
                          ListTile(
                            leading: const Icon(Icons.credit_card),
                            title: Text(AppStrings.creditCard),
                          ),
                          ListTile(
                            leading: const Icon(Icons.wallet),
                            title: Text(AppStrings.wallet),
                            trailing: const Text('1250 ج'),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.danger,
                      ),
                      onPressed: () {
                        context.read<AuthBloc>().add(LogoutRequested());
                        Navigator.pushReplacementNamed(context, '/login');
                      },
                      child: Text(AppStrings.logout),
                    ),
                  ],
                ),
              );
            }

            return Padding(
              padding: const EdgeInsets.all(16),
              child: ListView(
                children: [
                  const SizedBox(height: 12),
                  Center(
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: AppTheme.primary.withValues(alpha: 0.12),
                      child: const Icon(
                        Icons.person,
                        size: 54,
                        color: AppTheme.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: Text(
                      'User',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.danger,
                    ),
                    onPressed: () {
                      context.read<AuthBloc>().add(LogoutRequested());
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                    child: Text(AppStrings.logout),
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
