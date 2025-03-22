import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/add_recipe_screen.dart';
import 'screens/recipe_detail_screen.dart';
import 'screens/profile_screen.dart';
import 'widgets/app_shell.dart';

final GoRouter router = GoRouter(
  initialLocation: '/login', // Dastlabki sahifa
  routes: [
    // Login sahifasi (BottomNavigationBar’siz)
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    // AppShell ichidagi sahifalar (BottomNavigationBar bilan)
    ShellRoute(
      builder: (context, state, child) => AppShell(child: child),
      routes: [
        GoRoute(
          path: '/home',
          builder: (context, state) => HomeScreen(),
        ),
        GoRoute(
          path: '/add-recipe',
          builder: (context, state) => const AddRecipeScreen(),
        ),
        GoRoute(
          path: '/recipe/:id',
          builder: (context, state) {
            final recipeId = state.pathParameters['id']!;
            return RecipeDetailScreen(recipeId: recipeId);
          },
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) => ProfileScreen(),
        ),
      ],
    ),
  ],
  // Autentifikatsiya holatiga qarab yo‘naltirish
  redirect: (context, state) async {
    final isAuthenticated = FirebaseAuth.instance.currentUser != null;
    final isLoginRoute = state.matchedLocation == '/login';

    // Agar foydalanuvchi autentifikatsiya qilinmagan va login sahifasida bo‘lmasa
    if (!isAuthenticated && !isLoginRoute) {
      return '/login';
    }
    // Agar foydalanuvchi autentifikatsiya qilingan va login sahifasida bo‘lsa
    if (isAuthenticated && isLoginRoute) {
      return '/home';
    }
    return null; // Hech qanday yo‘naltirish kerak emas
  },
);