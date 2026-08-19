import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'otp_screen.dart';
import 'register_screen.dart';
import 'passenger_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../features/auth/presentation/bloc/auth_bloc.dart';
import '../features/auth/presentation/bloc/auth_event.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController phoneController = TextEditingController();

  String countryCode = "+249";
  String countryFlag = "🇸🇩";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight:
                  MediaQuery.of(context).size.height -
                  (MediaQuery.of(context).padding.top +
                      MediaQuery.of(context).padding.bottom),
            ),
            child: IntrinsicHeight(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),

                  Image.asset("assets/images/logo.png", width: 120),

                  const SizedBox(height: 30),

                  const Text(
                    "تسجيل الدخول",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 40),

                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          showCountryPicker(
                            context: context,
                            showPhoneCode: true,
                            favorite: const ["SD", "EG"],
                            countryFilter: null,
                            onSelect: (country) {
                              setState(() {
                                countryCode = "+${country.phoneCode}";
                                countryFlag = country.flagEmoji;
                              });
                            },
                          );
                        },

                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 16,
                          ),

                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black12),
                            borderRadius: BorderRadius.circular(12),
                          ),

                          child: Row(
                            children: [
                              Text(
                                countryFlag,
                                style: const TextStyle(fontSize: 20),
                              ),

                              const SizedBox(width: 5),

                              Text(
                                countryCode,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const Icon(Icons.keyboard_arrow_down),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(width: 10),

                      Expanded(
                        child: TextField(
                          controller: phoneController,
                          keyboardType: TextInputType.phone,

                          decoration: InputDecoration(
                            hintText: "رقم الهاتف",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  SizedBox(
                    width: double.infinity,
                    height: 55,

                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                      ),

                      onPressed: () {
                        if (phoneController.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("ادخل رقم الهاتف")),
                          );

                          return;
                        }

                        final phoneNumber =
                            "$countryCode${phoneController.text.trim()}";

                        context.read<AuthBloc>().add(
                          LoginRequested(phoneNumber),
                        );

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => OtpScreen(phoneNumber: phoneNumber),
                          ),
                        );
                      },

                      child: const Text("إرسال رمز التحقق"),
                    ),
                  ),

                  const SizedBox(height: 25),

                  const Text("أو"),

                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    height: 55,

                    child: OutlinedButton(
                      onPressed: () async {
                        try {
                          final googleUser = await GoogleSignIn().signIn();
                          if (googleUser == null) return;

                          final googleAuth = await googleUser.authentication;
                          final credential = GoogleAuthProvider.credential(
                            accessToken: googleAuth.accessToken,
                            idToken: googleAuth.idToken,
                          );

                          await FirebaseAuth.instance.signInWithCredential(
                            credential,
                          );

                          if (!context.mounted) return;

                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const PassengerScreen(),
                            ),
                          );
                        } catch (e) {
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'فشل تسجيل الدخول بواسطة Google: $e',
                              ),
                            ),
                          );
                        }
                      },

                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/images/google_logo.png",
                            width: 24,
                          ),

                          const SizedBox(width: 10),

                          const Text(
                            "تسجيل الدخول بواسطة Google",
                            style: TextStyle(color: Colors.black, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const RegisterScreen(),
                        ),
                      );
                    },
                    child: const Text("إنشاء حساب جديد"),
                  ),

                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => OtpScreen(
                            phoneNumber:
                                "$countryCode${phoneController.text.trim()}",
                          ),
                        ),
                      );
                    },
                    child: const Text("نسيت كلمة المرور؟"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
