import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/auth_service.dart';
import '../../constants/app_colors.dart';
import '../../widgets/custom_button.dart';
import 'sign_up_screen.dart';
import 'forgot_password_screen.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final AuthService _authService = AuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 50),
                Text(
                  'Welcome Back!',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                Text(
                  'Please enter your account here',
                  style: TextStyle(fontSize: 16, color: AppColors.accentGray),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 40),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email or phone number',
                    prefixIcon: Icon(Icons.email, color: AppColors.textPrimary),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0)),
                    filled: true,
                    fillColor: AppColors.cardBackground,
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock, color: AppColors.textPrimary),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0)),
                    filled: true,
                    fillColor: AppColors.cardBackground,
                    suffixIcon: Icon(Icons.visibility, color: AppColors.textPrimary),
                  ),
                  obscureText: true,
                ),
                if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      _errorMessage!,
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => context.go('/forgot-password'),
                    child: Text('Forgot password?', style: TextStyle(color: AppColors.primaryGreen)),
                  ),
                ),
                SizedBox(height: 20),
                CustomButton(
                  text: 'Login',
                  color: AppColors.primaryGreen,
                  onPressed: () async {
                    try {
                      final user = await _authService.signIn(
                        _emailController.text.trim(),
                        _passwordController.text.trim(),
                      );
                      if (user != null) {
                        context.go('/home');
                      } else {
                        setState(() => _errorMessage = 'Login failed. Please check your credentials.');
                      }
                    } catch (e) {
                      setState(() => _errorMessage = 'An error occurred: $e');
                    }
                  },
                ),
                SizedBox(height: 20),
                CustomButton(
                  text: 'Google',
                  color: AppColors.secondaryRed,
                  onPressed: () {
                    // Google Sign In (keyin qo‘shiladi)
                    setState(() => _errorMessage = 'Google Sign In not implemented yet.');
                  },
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have any account?", style: TextStyle(color: AppColors.textPrimary)),
                    TextButton(
                      onPressed: () => context.go('/sign-up'),
                      child: Text('Sign Up', style: TextStyle(color: AppColors.primaryGreen)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}