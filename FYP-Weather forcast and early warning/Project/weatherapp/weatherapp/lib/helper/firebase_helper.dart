import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseHelper {

final FirebaseAuth _auth = FirebaseAuth.instance;
final FirebaseFirestore _firestore = FirebaseFirestore.instance;

Future<Map<String, dynamic>?> getUserDataFromFirestore() async {
  final currentUser = FirebaseAuth.instance.currentUser;
  if (currentUser == null) return null;

  final doc = await FirebaseFirestore.instance.collection('users').doc(currentUser.uid).get();
  return doc.exists ? doc.data() : null;
}

Future<void> updateUsernameInFirestore(String newUsername) async {
  final currentUser = FirebaseAuth.instance.currentUser;
  if (currentUser == null) return;

  await FirebaseFirestore.instance
      .collection('users')
      .doc(currentUser.uid)
      .update({'username': newUsername});
}

Future<void> updateUserProfile(Map<String, dynamic> updatedData) async {
    final uid = _auth.currentUser?.uid;
    if (uid != null) {
      await _firestore.collection('users').doc(uid).update(updatedData);
    }
  }




}

