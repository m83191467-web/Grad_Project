import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/constants/app_strings.dart';
import '../core/theme/app_theme.dart';
import '../features/auth/presentation/bloc/auth_bloc.dart';
import '../features/auth/presentation/bloc/auth_event.dart';
import '../features/auth/presentation/bloc/auth_state.dart';
import 'passenger_screen.dart';

class OtpScreen extends StatefulWidget {
  final String phoneNumber;

  const OtpScreen({super.key, required this.phoneNumber});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final TextEditingController otpController = TextEditingController();
  bool loading = false;

  @override
  void dispose() {
    otpController.dispose();
    super.dispose();
  }

  void _submitOtp() {
    if (otpController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text(AppStrings.verifyOtp)));
      return;
    }

    setState(() => loading = true);
    context.read<AuthBloc>().add(OtpSubmitted(otpController.text.trim()));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const PassengerScreen()),
          );
        }

        if (state is AuthError) {
          setState(() => loading = false);
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }

        if (state is AuthCodeSent) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text(AppStrings.sendOtp)));
        }
      },
      child: Scaffold(
        backgroundColor: AppTheme.background,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(37, 24, 37, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    onPressed: () => Navigator.maybePop(context),
                    padding: EdgeInsets.zero,
                    alignment: Alignment.centerLeft,
                    icon: const Icon(
                      Icons.arrow_back,
                      color: AppTheme.textSecondary,
                      size: 28,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  '${AppStrings.verifyOtp}\n${widget.phoneNumber}',
                  textAlign: TextAlign.left,
                  style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 24,
                    height: 1.35,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 34),
                TextField(
                  controller: otpController,
                  keyboardType: TextInputType.number,
                  enabled: !loading,
                  style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 28,
                    letterSpacing: 14,
                  ),
                  decoration: const InputDecoration(
                    hintText: '••••',
                    filled: false,
                    hintStyle: TextStyle(color: Color(0xFF979797)),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: AppTheme.outline),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: AppTheme.primary),
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    onPressed: loading ? null : () {},
                    child: const Text(
                      'Resend Code',
                      style: TextStyle(color: AppTheme.primary, fontSize: 18),
                    ),
                  ),
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  height: 58,
                  child: ElevatedButton(
                    onPressed: loading ? null : _submitOtp,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      shape: const RoundedRectangleBorder(),
                      elevation: 4,
                    ),
                    child: loading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(AppStrings.next),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
