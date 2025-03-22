import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../constants.dart';

class UserModel {
  final String id; // Foydalanuvchi UID
  final String? displayName; // Foydalanuvchi ismi (ixtiyoriy)
  final String email; // Foydalanuvchi emaili
  final String? photoUrl; // Foydalanuvchi profil rasmi (ixtiyoriy)
  final DateTime? createdAt; // Hisob yaratilgan vaqt (ixtiyoriy)

  UserModel({
    required this.id,
    this.displayName,
    required this.email,
    this.photoUrl,
    this.createdAt,
  });

  // Firestore’dan ma’lumotlarni olish uchun factory konstruktori
  factory UserModel.fromMap(Map<String, dynamic> data, String id) {
    return UserModel(
      id: id,
      displayName: data['display_name'],
      email: data['email'] ?? '',
      photoUrl: data['photo_url'],
      createdAt: data['created_at'] != null
          ? (data['created_at'] as Timestamp).toDate()
          : null,
    );
  }

  // FirebaseAuth User obyektiidan yaratish uchun factory
  factory UserModel.fromFirebaseUser(User firebaseUser) {
    return UserModel(
      id: firebaseUser.uid,
      displayName: firebaseUser.displayName,
      email: firebaseUser.email ?? '',
      photoUrl: firebaseUser.photoURL,
      createdAt: firebaseUser.metadata.creationTime,
    );
  }

  // Firestore’ga saqlash uchun ma’lumotlarni xarita sifatida qaytarish
  Map<String, dynamic> toMap() {
    return {
      'display_name': displayName,
      'email': email,
      'photo_url': photoUrl,
      'created_at': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
    };
  }
}