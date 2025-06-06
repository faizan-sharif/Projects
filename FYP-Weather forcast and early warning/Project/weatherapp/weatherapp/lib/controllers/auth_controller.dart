import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:weatherapp/screens/homeScreen.dart';
import 'package:weatherapp/screens/splash_screen/starter_screen.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.find();
  RxBool obsecureText = true.obs;
  late Rx<User?> _user;
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void onReady() {
    super.onReady();
    _user = Rx<User?>(auth.currentUser);
    _user.bindStream(auth.userChanges());
    ever(_user, _initialScreen);
  }

  void _initialScreen(User? user) {
    if (user == null) {
      print("User not logged in");
    } else {
      Get.offAll(() => HomeScreen());
    }
  }

  void register({
  required String email,
  required String password,
  required String username,
  required String fullName,
  required String phoneNumber,
  required String gender,
  required String age,
}) async {
  try {
    UserCredential userCredential = await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    // Save user data in Firestore
    await firestore.collection('users').doc(userCredential.user!.uid).set({
      'email': email,
      'username': username,
      'uid': userCredential.user!.uid,
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'gender': gender,
      'age': age,
    });

    Get.snackbar(
      "Success",
      "Account created successfully!",
      snackPosition: SnackPosition.BOTTOM,
    );
  } on FirebaseAuthException catch (e) {
    Get.snackbar(
      "Registration Failed",
      e.message.toString(),
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}

  void login(String email, String password) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      Get.snackbar(
        "Login Failed",
        e.message.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void logout() async {
    await auth.signOut().then((value) => Get.offAll(() => StarterScreen()));
    Get.snackbar("Logout", "You have been logged out");
  }
}
