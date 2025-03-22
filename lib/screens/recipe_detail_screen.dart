import 'package:flutter/material.dart';
import '../models/recipe.dart';
import '../services/recipe_service.dart';
import '../constants.dart';

class RecipeDetailScreen extends StatelessWidget {
  final String recipeId;
  final RecipeService _recipeService = RecipeService();

  RecipeDetailScreen({super.key, required this.recipeId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Retsept Detallari",
          style: kTitleStyle,
        ),
        backgroundColor: kPrimaryColor,
        elevation: 0,
      ),
      body: FutureBuilder<Recipe?>(
        future: _recipeService.getRecipeById(recipeId),
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
          // Retsept topilmadi holati
          if (!snapshot.hasData || snapshot.data == null) {
            return Center(
              child: Text(
                "Retsept topilmadi",
                style: kBodyStyle,
                textAlign: TextAlign.center,
              ),
            );
          }
          // Retsept ma’lumotlari
          final recipe = snapshot.data!;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(kDefaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Retsept nomi
                Text(
                  recipe.title,
                  style: kTitleStyle.copyWith(fontSize: 24),
                ),
                const SizedBox(height: kDefaultPadding),
                // Masalliqlar
                Text(
                  "Masalliqlar",
                  style: kSubtitleStyle,
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(kDefaultPadding),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    recipe.ingredients,
                    style: kBodyStyle,
                  ),
                ),
                const SizedBox(height: kDefaultPadding),
                // Tayyorlash usuli
                Text(
                  "Tayyorlash Usuli",
                  style: kSubtitleStyle,
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(kDefaultPadding),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    recipe.instructions,
                    style: kBodyStyle,
                  ),
                ),
                const SizedBox(height: kDefaultPadding),
                // Muallif (agar kerak bo‘lsa keyinroq to‘ldiriladi)
                Text(
                  "Muallif ID: ${recipe.authorId}",
                  style: kBodyStyle.copyWith(color: Colors.grey),
                ),
              ],
            ),
          );
        },
      ),
      backgroundColor: kBackgroundColor,
    );
  }
}