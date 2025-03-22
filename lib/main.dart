import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'router.dart';
import 'constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Flutter bindingni ishga tushirish
  await Firebase.initializeApp(); // Firebase’ni ishga tushirish
  runApp(const UzbekonaTamApp());
}

class UzbekonaTamApp extends StatelessWidget {
  const UzbekonaTamApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: "O‘zbekona Ta’m",
      theme: ThemeData(
        primaryColor: kPrimaryColor,
        scaffoldBackgroundColor: kBackgroundColor,
        appBarTheme: const AppBarTheme(
          color: kPrimaryColor,
          elevation: 0,
          titleTextStyle: kTitleStyle,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: kPrimaryColor,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: kDefaultBorderRadius),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: kPrimaryColor),
            shape: RoundedRectangleBorder(borderRadius: kDefaultBorderRadius),
          ),
        ),
        textTheme: const TextTheme(
          headlineSmall: kTitleStyle,
          titleMedium: kSubtitleStyle,
          bodyMedium: kBodyStyle,
        ),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: kPrimaryColor,
          secondary: kSecondaryColor,
        ),
      ),
      routerConfig: router, // go_router’dan navigatsiya konfiguratsiyasi
      debugShowCheckedModeBanner: false, // Debug bannerini o‘chirish
    );
  }
}