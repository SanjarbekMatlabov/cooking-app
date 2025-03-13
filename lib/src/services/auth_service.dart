import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Ro‘yxatdan o‘tish
  Future<AppUser?> signUp(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;

      if (user != null) {
        AppUser appUser = AppUser(id: user.uid, email: email, coins: 0);
        await _firestore.collection('users').doc(user.uid).set(appUser.toJson());
        return appUser;
      }
      return null;
    } catch (e) {
      print('Sign Up Error: $e');
      return null;
    }
  }

  // Kirish
  Future<AppUser?> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;

      if (user != null) {
        DocumentSnapshot doc = await _firestore.collection('users').doc(user.uid).get();
        return AppUser.fromJson(doc.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      print('Sign In Error: $e');
      return null;
    }
  }

  // Parolni tiklash
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print('Reset Password Error: $e');
      rethrow;
    }
  }

  // Chiqish
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Foydalanuvchi oqimi
  Stream<User?> get userStream => _auth.authStateChanges();
}