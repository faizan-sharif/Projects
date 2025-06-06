import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weatherapp/controllers/auth_controller.dart'; // Import your AuthController
import 'package:weatherapp/screens/auth/sign_up_screen.dart';
import '../../weather_screen.dart'; // Import your WeatherScreen

class SignInScreen extends StatefulWidget {
  SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  // Email validation function
  bool isValidGmail(String email) {
    final RegExp emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@gmail\.com$');
    return emailRegex.hasMatch(email);
  }

  AuthController authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    InputBorder border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary),
    );

    InputBorder errorBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: Colors.red),
    );

    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset('assets/background3.jpg', fit: BoxFit.cover),
          ),
          // Scrollable Sign In Form
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Container(
                  width: width > 600 ? 400 : width * 0.85, // Responsive width
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.secondary.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(
                          context,
                        ).colorScheme.tertiary.withOpacity(0.9),
                        blurRadius: 20,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Sign In",
                          style: Theme.of(context).textTheme.displayMedium!
                              .copyWith(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                        ),
                        const SizedBox(height: 24),
                        TextFormField(
                          style: Theme.of(context).textTheme.bodySmall!
                              .copyWith(
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            // labelText: "Email",
                            hintText: "example@gmail.com",
                            hintStyle: Theme.of(context).textTheme.bodySmall!
                                .copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.secondary.withOpacity(0.5),
                                ),
                            border: border,
                            focusedBorder: border,
                            enabledBorder: border,
                            errorBorder: errorBorder,
                            focusedErrorBorder: errorBorder,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            } else if (!isValidGmail(value)) {
                              return 'Enter a valid Gmail address';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        Obx(() {
                          return TextFormField(
                            style: Theme.of(context).textTheme.bodySmall!
                                .copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.secondary,
                                ),
                            controller: _passwordController,
                            obscureText: authController.obsecureText.value,
                            decoration: InputDecoration(
                              suffixIcon: IconButton(
                                icon: Icon(
                                  authController.obsecureText.value
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.secondary,
                                ),
                                onPressed: () {
                                  authController.obsecureText.toggle();
                                },
                              ),
                              hintText: "Password",
                              hintStyle: Theme.of(context).textTheme.bodySmall!
                                  .copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.secondary.withOpacity(0.5),
                                  ),

                              border: border,
                              focusedBorder: border,
                              enabledBorder: border,
                              errorBorder: errorBorder,
                              focusedErrorBorder: errorBorder,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              } else if (value.length < 6) {
                                return 'Password must be at least 6 characters';
                              }
                              return null;
                            },
                          );
                        }),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(
                                context,
                              ).colorScheme.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                AuthController.instance.login(
                                  _emailController.text.trim(),
                                  _passwordController.text.trim(),
                                );
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: Text(
                                "Sign In",
                                style: Theme.of(context).textTheme.bodyLarge!
                                    .copyWith(
                                      fontSize: 18,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.secondary,
                                    ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Don't have an account?",
                              style: Theme.of(context).textTheme.bodyMedium!
                                  .copyWith(
                                    fontSize: 16,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.secondary,
                                  ),
                            ),
                            TextButton(
                              onPressed: () {
                                Get.to(
                                  () => SignUpScreen(),
                                  transition: Transition.rightToLeft,
                                );
                              },
                              child: Text(
                                "Sign Up",
                                style: Theme.of(context).textTheme.bodyMedium!
                                    .copyWith(
                                      fontSize: 16,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
