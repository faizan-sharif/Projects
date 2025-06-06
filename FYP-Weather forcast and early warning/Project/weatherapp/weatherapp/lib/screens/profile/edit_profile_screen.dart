import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:weatherapp/helper/firebase_helper.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _ageController = TextEditingController();
  String gender = 'Male';

  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final userData = await FirebaseHelper().getUserDataFromFirestore();
    if (userData != null) {
      _usernameController.text = userData['username'] ?? '';
      _fullNameController.text = userData['fullName'] ?? '';
      _phoneController.text = userData['phoneNumber'] ?? '';
      _ageController.text = userData['age']?.toString() ?? '';
      gender = userData['gender'] ?? 'Male';
    }
    setState(() => _loading = false);
  }

  Future<void> _saveChanges() async {
    if (_formKey.currentState!.validate()) {
      await FirebaseHelper().updateUserProfile({
        'username': _usernameController.text.trim(),
        'fullName': _fullNameController.text.trim(),
        'phoneNumber': _phoneController.text.trim(),
        'age': int.tryParse(_ageController.text.trim()) ?? 0,
        'gender': gender,
      });
      Get.back();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ Profile updated successfully")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
        backgroundColor: theme.colorScheme.primary,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Animate(
                effects: const [
                  FadeEffect(duration: Duration(milliseconds: 600)),
                  ScaleEffect()
                ],
                child: Form(
                  key: _formKey,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeInOut,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.secondary,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        const Text(
                          "Update Your Profile",
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ).animate().fade().slideY(begin: 0.2),
                        const SizedBox(height: 20),
                        _buildInput("Username", _usernameController),
                        _buildInput("Full Name", _fullNameController),
                        _buildInput("Phone Number", _phoneController,
                            TextInputType.phone),
                        _buildInput(
                            "Age", _ageController, TextInputType.number),
                        DropdownButtonFormField<String>(
                          value: gender,
                          decoration:
                              const InputDecoration(labelText: "Gender"),
                          items: ["Male", "Female", "Other"]
                              .map((g) =>
                                  DropdownMenuItem(value: g, child: Text(g)))
                              .toList(),
                          onChanged: (value) => setState(() => gender = value!),
                        ),
                        const SizedBox(height: 30),
                        ElevatedButton.icon(
                          onPressed: _saveChanges,
                          icon: const Icon(Icons.save),
                          label: const Text("Save Changes"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.colorScheme.primary,
                            foregroundColor: theme.colorScheme.onPrimary,
                            padding: const EdgeInsets.symmetric(
                                vertical: 14, horizontal: 30),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ).animate().fade().slideY(begin: 0.4),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildInput(String label, TextEditingController controller,
      [TextInputType? type]) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: TextFormField(
        controller: controller,
        keyboardType: type ?? TextInputType.text,
        decoration: InputDecoration(
          hintText: label,
          hintStyle: Theme.of(context).textTheme.bodySmall!.copyWith(
                color: Theme.of(context).colorScheme.tertiary.withOpacity(0.5),
              ),
          border: const OutlineInputBorder(),
          filled: true,
          fillColor: Theme.of(context).scaffoldBackgroundColor,
        ),
        validator: (value) => value!.isEmpty ? "Required" : null,
      ).animate().fade().slideY(begin: 0.1),
    );
  }
}
