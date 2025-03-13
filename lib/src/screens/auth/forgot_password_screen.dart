import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/auth_service.dart';
import '../../constants/app_colors.dart';
import '../../widgets/custom_button.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final AuthService _authService = AuthService();
  int _step = 1; // 1: Email, 2: Code, 3: Reset Password
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _codeController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  // Email bosqich
  Widget _buildEmailScreen() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 50),
          Text(
            'Password recovery',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          Text(
            'Enter your email to recover your password',
            style: TextStyle(fontSize: 16, color: AppColors.accentGray),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 40),
          TextField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText: 'Syafriichoiu17@gmail.com',
              prefixIcon: Icon(Icons.email, color: AppColors.textPrimary),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0)),
              filled: true,
              fillColor: AppColors.cardBackground,
            ),
            keyboardType: TextInputType.emailAddress,
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
            text: 'Sign In',
            color: AppColors.primaryGreen,
            onPressed: () async {
              try {
                await _authService.resetPassword(_emailController.text.trim());
                setState(() {
                  _step = 2;
                  _errorMessage = null;
                });
              } catch (e) {
                setState(() => _errorMessage = 'Error sending reset email: $e');
              }
            },
          ),
        ],
      ),
    );
  }

  // Kod tekshirish bosqich
  Widget _buildCodeScreen() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 50),
          Text(
            'Check your email',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          Text(
            "We've sent the code to your email",
            style: TextStyle(fontSize: 16, color: AppColors.accentGray),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(4, (index) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.textPrimary),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Center(
                  child: TextField(
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    maxLength: 1,
                    decoration: InputDecoration(
                      counterText: '',
                      border: InputBorder.none,
                    ),
                    onChanged: (value) {
                      if (value.isNotEmpty && index < 3) {
                        FocusScope.of(context).nextFocus();
                      }
                    },
                  ),
                ),
              ),
            )),
          ),
          SizedBox(height: 10),
          Text(
            'code expires in: 03:12',
            style: TextStyle(fontSize: 14, color: AppColors.accentGray),
            textAlign: TextAlign.center,
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
            text: 'Next',
            color: AppColors.primaryGreen,
            onPressed: () {
              // Kodni tekshirish logikasi (keyin qo‘shiladi)
              setState(() {
                _step = 3;
                _errorMessage = null;
              });
            },
          ),
          TextButton(
            onPressed: () async {
              try {
                await _authService.resetPassword(_emailController.text.trim());
                setState(() => _errorMessage = null);
              } catch (e) {
                setState(() => _errorMessage = 'Error resending code: $e');
              }
            },
            child: Text('Send again', style: TextStyle(color: AppColors.primaryGreen)),
          ),
        ],
      ),
    );
  }

  // Yangi parol o‘rnatish bosqich
  Widget _buildResetPasswordScreen() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 50),
          Text(
            'Reset your password',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          Text(
            'Please enter your new password',
            style: TextStyle(fontSize: 16, color: AppColors.accentGray),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 40),
          TextField(
            controller: _newPasswordController,
            decoration: InputDecoration(
              labelText: '••••••••',
              prefixIcon: Icon(Icons.lock, color: AppColors.textPrimary),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0)),
              filled: true,
              fillColor: AppColors.cardBackground,
              suffixIcon: Icon(Icons.visibility, color: AppColors.textPrimary),
            ),
            obscureText: true,
          ),
          SizedBox(height: 10),
          Text(
            'Password must contain:',
            style: TextStyle(fontSize: 14, color: AppColors.textPrimary),
          ),
          Text('✓ Atleast 6 characters', style: TextStyle(color: Colors.green)),
          Text('✓ Contains a number', style: TextStyle(color: Colors.green)),
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
            text: 'Done',
            color: AppColors.primaryGreen,
            onPressed: () async {
              if (_newPasswordController.text.length < 6 || !RegExp(r'[0-9]').hasMatch(_newPasswordController.text)) {
                setState(() => _errorMessage = 'Password does not meet requirements!');
                return;
              }
              try {
                User? user = FirebaseAuth.instance.currentUser;
                if (user != null) {
                  await user.updatePassword(_newPasswordController.text.trim());
                  context.go('/sign-in');
                } else {
                  setState(() => _errorMessage = 'User not found. Please sign in again.');
                }
              } catch (e) {
                setState(() => _errorMessage = 'Error resetting password: $e');
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: _step == 1
            ? _buildEmailScreen()
            : _step == 2
                ? _buildCodeScreen()
                : _buildResetPasswordScreen(),
      ),
    );
  }
}