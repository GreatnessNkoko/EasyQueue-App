import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../utils/app_colors.dart';
import '../widgets/custom_input_field.dart';
import '../widgets/custom_button.dart';
import 'login_screen.dart';
import 'home_screen.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final nameCtrl = TextEditingController();
    final emailCtrl = TextEditingController();
    final passCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    final authProvider = Provider.of<AuthProvider>(context);

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: primaryColor,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Text(
                    'EasyQueue',
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Bodoni MT Black',
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Create Account Now!',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                const SizedBox(height: 40),
                CustomInputField(hintText: 'Full Name', controller: nameCtrl),
                const SizedBox(height: 20),
                CustomInputField(hintText: 'Email', controller: emailCtrl),
                const SizedBox(height: 20),
                CustomInputField(
                    hintText: 'Password',
                    controller: passCtrl,
                    obscureText: true),
                const SizedBox(height: 20),
                CustomInputField(hintText: 'Phone No', controller: phoneCtrl),
                const SizedBox(height: 30),
                if (authProvider.error.isNotEmpty)
                  Text(authProvider.error,
                      style: const TextStyle(color: Colors.red)),
                const SizedBox(height: 20),
                CustomButton(
                  label: authProvider.isLoading ? '' : 'SIGN UP',
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                  ),
                  onPressed: () async {
                    FocusScope.of(context).unfocus();
                    authProvider.clearError();

                    if (nameCtrl.text.isEmpty ||
                        emailCtrl.text.isEmpty ||
                        passCtrl.text.isEmpty ||
                        phoneCtrl.text.isEmpty) {
                      authProvider.setError('Please fill in all fields');
                      return;
                    }

                    if (passCtrl.text.length < 6) {
                      authProvider
                          .setError('Password must be at least 6 characters');
                      return;
                    }

                    final success = await authProvider.signup(
                        emailCtrl.text, passCtrl.text);
                    if (success) {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => const HomeScreen()),
                        (route) => false,
                      );
                    }
                  },
                  child: authProvider.isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2)
                      : const Text(
                          'SIGN UP',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                ),
                const SizedBox(height: 30),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                      );
                    },
                    child: const Text(
                      'Already have an account? Login',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
