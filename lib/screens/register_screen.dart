import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../features/auth/presentation/bloc/auth_event.dart';
import '../features/auth/presentation/bloc/auth_bloc.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();

  bool loading = false;

  Future<void> registerUser() async {
    if (nameController.text.isEmpty || phoneController.text.isEmpty) {
      return;
    }

    setState(() {
      loading = true;
    });

    try {
      // dispatch registration to AuthBloc which will call CreatePassenger usecase
      context.read<AuthBloc>().add(
        RegisterRequested(
          name: nameController.text.trim(),
          phone: phoneController.text.trim(),
          email: emailController.text.trim().isEmpty
              ? null
              : emailController.text.trim(),
        ),
      );

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("تم إرسال طلب التسجيل")));
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("إنشاء حساب جديد")),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "الاسم"),
            ),

            TextField(
              controller: phoneController,
              decoration: const InputDecoration(labelText: "رقم الهاتف"),
            ),

            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: "البريد الإلكتروني"),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,

              child: ElevatedButton(
                onPressed: loading ? null : registerUser,

                child: loading
                    ? const CircularProgressIndicator()
                    : const Text("تسجيل حساب"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
