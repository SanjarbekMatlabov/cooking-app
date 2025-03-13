import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/auth_service.dart';
import '../../constants/app_colors.dart';
import '../../widgets/custom_button.dart';
import '../home_screen.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final AuthService _authService = AuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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
                  'Create Account',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                Text(
                  'Please fill the details to sign up',
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
                SizedBox(height: 20),
                TextField(
                  controller: _confirmPasswordController,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
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
                SizedBox(height: 20),
                CustomButton(
                  text: 'Sign Up',
                  color: AppColors.primaryGreen,
                  onPressed: () async {
                    if (_passwordController.text != _confirmPasswordController.text) {
                      setState(() => _errorMessage = 'Passwords do not match!');
                      return;
                    }
                    try {
                      final user = await _authService.signUp(
                        _emailController.text.trim(),
                        _passwordController.text.trim(),
                      );
                      if (user != null) {
                        context.go('/home');
                      } else {
                        setState(() => _errorMessage = 'Sign up failed. Please try again.');
                      }
                    } catch (e) {
                      setState(() => _errorMessage = 'An error occurred: $e');
                    }
                  },
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have an account?", style: TextStyle(color: AppColors.textPrimary)),
                    TextButton(
                      onPressed: () => context.go('/sign-in'),
                      child: Text('Sign In', style: TextStyle(color: AppColors.primaryGreen)),
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