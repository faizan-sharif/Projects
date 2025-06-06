import 'package:flutter/material.dart';
import 'package:weatherapp/screens/auth/sign_in_screen.dart';

class StarterScreen extends StatelessWidget {
  const StarterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Set the background image for the screen
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/background1.jpg', // Path to your background image
              fit: BoxFit.cover,
            ),
          ),

          // Main content (Button at the bottom)
          Column(
            mainAxisAlignment: MainAxisAlignment
                .spaceBetween, // Pushes content to top and bottom
            children: [
              Container(), // Empty container to push the button to the bottom
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to Sign In or Sign Up screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignInScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(
                      context,
                    ).primaryColor, // Blue color for the button
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 32,
                    ), // Adjust button size
                  ),
                  child: Text(
                    "Get Started",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
