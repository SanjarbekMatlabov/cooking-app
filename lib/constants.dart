import 'package:flutter/material.dart';

// Ranglar
const Color kPrimaryColor = Color(0xFF4CAF50); // Yashil - asosiy rang (O‘zbekona ruh uchun)
const Color kSecondaryColor = Color(0xFFFF9800); // To‘q sariq - aksent rangi
const Color kBackgroundColor = Color(0xFFF5F5F5); // Och kulrang - fon uchun
const Color kTextColor = Color(0xFF212121); // Qora - asosiy matn rangi
const Color kErrorColor = Colors.red; // Xatolik xabarlari uchun

// Matn uslublari
const TextStyle kTitleStyle = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.bold,
  color: kTextColor,
);

const TextStyle kSubtitleStyle = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w600,
  color: kTextColor,
);

const TextStyle kBodyStyle = TextStyle(
  fontSize: 14,
  color: kTextColor,
);

// Bo‘shliqlar
const double kDefaultPadding = 16.0; // Standart padding/margin uchun
const double kSmallPadding = 8.0; // Kichik bo‘shliqlar uchun
const double kLargePadding = 24.0; // Katta bo‘shliqlar uchun

// Firebase kolleksiya nomlari
const String kRecipesCollection = 'recipes'; // Retseptlar kolleksiyasi
const String kUsersCollection = 'users'; // Foydalanuvchilar kolleksiyasi

// Umumiy sozlamalar
const BorderRadius kDefaultBorderRadius = BorderRadius.all(Radius.circular(12.0)); // Standart yumaloq burchaklar
const BoxShadow kDefaultBoxShadow = BoxShadow(
  color: Colors.black12,
  blurRadius: 8.0,
  offset: Offset(0, 2),
); // Standart soya