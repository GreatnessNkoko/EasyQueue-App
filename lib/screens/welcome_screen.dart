import 'package:flutter/material.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text.dart';
import 'login_screen.dart'; // Ensure this import exists
import 'package:google_fonts/google_fonts.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40), // Proper spacing from top

            // EasyQueue Title
            const Center(
              child: Text(
                'EasyQueue',
                style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Bodoni MT Black",
                  color: Colors.black, // Ensuring exact UI match
                  letterSpacing: 0.5,
                ),
              ),
            ),

            const SizedBox(height: 50), // Adjusted spacing

            // Welcome Image
            Center(
              child: Image.asset(
                'assets/images/welcome_image.png',
                width: 280, // Adjusted size
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 30),

            // Title Text
            const Text(
              'Real-Time Queue \n Updates',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 5),

            // Subtitle Text
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                'Keep all your fee payment appointments organized in one place with our intuitive schedule management feature.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                  height: 1.5, // Line height adjustment
                ),
              ),
            ),

            const Spacer(), // Pushes content up to balance UI

            // Get Started Button
            Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: SizedBox(
                width: 300,
                height: 45,
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to Login Screen
                    // Navigator.push(
                    // context,
                    //MaterialPageRoute(
                    //builder: (context) => const LoginScreen()),
                    //);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 51, 221, 135), // Match UI color
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(15), // Fully rounded button
                    ),
                  ),
                  child: const Text(
                    'Get Started',
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
