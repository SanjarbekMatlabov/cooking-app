import 'package:go_router/go_router.dart';
import '../screens/onboarding_screen.dart';
import '../screens/auth/sign_in_screen.dart';
import '../screens/auth/sign_up_screen.dart';
import '../screens/auth/forgot_password_screen.dart';
import '../screens/main_screen.dart';
import '../screens/home_screen.dart';
import '../screens/search_screen.dart';
import '../screens/add_recipe_screen.dart';
import '../screens/recipe_detail_screen.dart';
import '../screens/profile_screen.dart';
import '../services/auth_service.dart';

class AppRoutes {
  static final GoRouter router = GoRouter(
    initialLocation: '/onboarding',
    routes: [
      GoRoute(path: '/onboarding', builder: (context, state) => OnboardingScreen()),
      GoRoute(path: '/sign-in', builder: (context, state) => SignInScreen()),
      GoRoute(path: '/sign-up', builder: (context, state) => SignUpScreen()),
      GoRoute(path: '/forgot-password', builder: (context, state) => ForgotPasswordScreen()),
      GoRoute(
        path: '/home',
        builder: (context, state) => MainScreen(initialIndex: 0),
      ),
      GoRoute(
        path: '/search',
        builder: (context, state) => MainScreen(initialIndex: 1),
      ),
      GoRoute(
        path: '/add-recipe',
        builder: (context, state) => MainScreen(initialIndex: 2),
      ),
      // GoRoute(
      //   path: '/recipe/:id',
      //   builder: (context, state) {
      //     final id = state.pathParameters['id']!;
      //     return RecipeDetailScreen(recipeId: id);
      //   },
      // ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => MainScreen(initialIndex: 3),
      ),
    ],
    redirect: (context, state) async {
      final authService = AuthService();
      final user = await authService.userStream.first;
      final isLoggedIn = user != null;

      if (!isLoggedIn &&
          state.matchedLocation != '/sign-in' &&
          state.matchedLocation != '/sign-up' &&
          state.matchedLocation != '/forgot-password' &&
          state.matchedLocation != '/onboarding') {
        return '/sign-in';
      }
      return null;
    },
  );
}