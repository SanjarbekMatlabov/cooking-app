import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:ozbekona_retsept/models/recipe.dart';
import '../services/recipe_service.dart';
import '../widgets/recipe_card.dart';
import '../constants.dart';

class ProfileScreen extends StatelessWidget {
  final RecipeService _recipeService = RecipeService();
  final User? user = FirebaseAuth.instance.currentUser;

  ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      // Agar foydalanuvchi autentifikatsiya qilinmagan bo‘lsa, login sahifasiga yo‘naltirish
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.go('/login');
      });
      return const SizedBox.shrink();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Mening Profilim",
          style: kTitleStyle,
        ),
        backgroundColor: kPrimaryColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: "Chiqish",
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              if (context.mounted) {
                context.go('/login');
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profil ma’lumotlari
            Container(
              padding: const EdgeInsets.all(kDefaultPadding),
              color: kPrimaryColor.withOpacity(0.1),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user!.displayName ?? "Foydalanuvchi",
                    style: kTitleStyle.copyWith(fontSize: 24),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    user!.email ?? "Email yo‘q",
                    style: kBodyStyle.copyWith(color: Colors.grey[700]),
                  ),
                ],
              ),
            ),
            // Foydalanuvchi retseptlari
            Padding(
              padding: const EdgeInsets.all(kDefaultPadding),
              child: Text(
                "Mening Retseptlarim",
                style: kSubtitleStyle,
              ),
            ),
            StreamBuilder<List<Recipe>>(
              stream: _recipeService.getUserRecipes(user!.uid),
              builder: (context, snapshot) {
                // Loading holati
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
                    ),
                  );
                }
                // Xatolik holati
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      "Xatolik yuz berdi: ${snapshot.error}",
                      style: kBodyStyle,
                      textAlign: TextAlign.center,
                    ),
                  );
                }
                // Retseptlar yo‘q holati
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(kDefaultPadding),
                      child: Text(
                        "Siz hali retsept qo‘shmadingiz. Yangi retsept qo‘shing!",
                        style: kBodyStyle,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }
                // Retseptlar ro‘yxati
                final recipes = snapshot.data!;
                return ListView.builder(
                  shrinkWrap: true, // SingleChildScrollView ichida ishlatish uchun
                  physics: const NeverScrollableScrollPhysics(), // Ichki scrollni o‘chirish
                  itemCount: recipes.length,
                  itemBuilder: (context, index) {
                    return RecipeCard(recipe: recipes[index]);
                  },
                );
              },
            ),
          ],
        ),
      ),
      backgroundColor: kBackgroundColor,
    );
  }
}