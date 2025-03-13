import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../constants/app_colors.dart';
import '../widgets/custom_button.dart';

class OnboardingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Sarlavha
              Text(
                'Start Cooking',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 10),
              Text(
                "Let's join our community to cook better food!",
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.accentGray,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40),
              // Tasvirlar (Hozircha placeholder sifatida)
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 20,
                runSpacing: 20,
                children: List.generate(
                  6,
                  (index) => CircleAvatar(
                    radius: 40,
                    backgroundColor: AppColors.cardBackground,
                    child: ClipOval(
                      child: Image.network(
                        'https://via.placeholder.com/80', // Keyin o'zbek taomlari rasmlari qo‘shiladi
                        fit: BoxFit.cover,
                        width: 80,
                        height: 80,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 60),
              // Get Started tugmasi
              CustomButton(
                text: 'Get Started',
                color: AppColors.primaryGreen,
                onPressed: () {
                  context.go('/home'); // SignInScreen'ga o'tish
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}