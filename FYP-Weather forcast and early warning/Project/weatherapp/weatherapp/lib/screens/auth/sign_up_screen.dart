import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weatherapp/controllers/auth_controller.dart';
import 'package:weatherapp/screens/auth/sign_in_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  String _selectedGender = 'Male';

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    InputBorder border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary),
    );

    InputBorder errorBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: Colors.red),
    );

    final authController = Get.put(AuthController());

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/background2.jpg', fit: BoxFit.cover),
            


          ),
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Container(
                  width: width > 600 ? 400 : width * 0.85,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).colorScheme.tertiary.withOpacity(0.9),
                        blurRadius: 20,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Sign Up",
                          style: Theme.of(context).textTheme.displayMedium!.copyWith(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                        ),
                        const SizedBox(height: 24),
                        _buildTextField(_emailController, "example@gmail.com", border, errorBorder),
                        const SizedBox(height: 16),
                        _buildTextField(_usernameController, "Username", border, errorBorder),
                        const SizedBox(height: 16),
                        _buildTextField(_fullNameController, "Full Name", border, errorBorder),
                        const SizedBox(height: 16),
                        _buildTextField(_phoneNumberController, "Phone Number", border, errorBorder),
                        const SizedBox(height: 16),
                        _buildTextField(_ageController, "Age", border, errorBorder, inputType: TextInputType.number),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          value: _selectedGender,
                          style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Theme.of(context).colorScheme.secondary),
                          dropdownColor: Theme.of(context).colorScheme.tertiary,
                          decoration: InputDecoration(
                            border: border,
                            enabledBorder: border,
                            focusedBorder: border,
                            errorBorder: errorBorder,
                            focusedErrorBorder: errorBorder,

                          ),
                          items: ['Male', 'Female', 'Other']
                              .map((gender) => DropdownMenuItem(

                              
                                    value: gender,

                                    child: Text(gender, style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Theme.of(context).colorScheme.secondary),),
                                  ))
                              .toList(),
                          onChanged: (value) => setState(() => _selectedGender = value!),
                        ),
                        const SizedBox(height: 16),
                        Obx(() {
                          return TextFormField(
                            controller: _passwordController,
                            obscureText: authController.obsecureText.value,
                            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                  color: Theme.of(context).colorScheme.secondary,
                                ),
                            decoration: InputDecoration(
                              hintText: "Password",
                              suffixIcon: IconButton(
                                icon: Icon(
                                  authController.obsecureText.value
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Theme.of(context).colorScheme.secondary,
                                ),
                                onPressed: () => authController.obsecureText.toggle(),
                              ),
                              hintStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
                                    color: Theme.of(context).colorScheme.secondary.withOpacity(0.5),
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
                              }
                              if (value.length < 6) {
                                return 'Password must be at least 6 characters';
                              }
                              return null;
                            },
                          );
                        }),
                        const SizedBox(height: 30),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                authController.register(
                                  email: _emailController.text.trim(),
                                  password: _passwordController.text.trim(),
                                  username: _usernameController.text.trim(),
                                  fullName: _fullNameController.text.trim(),
                                  phoneNumber: _phoneNumberController.text.trim(),
                                  gender: _selectedGender,
                                  age: _ageController.text.trim(),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).colorScheme.primary,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: Text(
                                "Sign Up",
                                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                      fontSize: 16,
                                      color: Theme.of(context).colorScheme.secondary,
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
                              "Already have an account?",
                              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    fontSize: 16,
                                    color: Theme.of(context).colorScheme.secondary,
                                  ),
                            ),
                            TextButton(
                              child: Text(
                                "Sign In",
                                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                      color: Theme.of(context).colorScheme.primary,
                                      fontSize: 16,
                                    ),
                              ),
                              onPressed: () => Get.to(
                                () => SignInScreen(),
                                transition: Transition.leftToRight,
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

  Widget _buildTextField(TextEditingController controller, String hint,
      InputBorder border, InputBorder errorBorder,
      {TextInputType inputType = TextInputType.text}) {
    return TextFormField(
      controller: controller,
      keyboardType: inputType,
      style: Theme.of(context).textTheme.bodySmall!.copyWith(
            color: Theme.of(context).colorScheme.secondary,
          ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
              color: Theme.of(context).colorScheme.secondary.withOpacity(0.5),
            ),
        border: border,
        focusedBorder: border,
        enabledBorder: border,
        errorBorder: errorBorder,
        focusedErrorBorder: errorBorder,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your $hint';
        }
        return null;
      },
    );
  }
}
