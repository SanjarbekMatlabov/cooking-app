import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:ozbekona_retsept/models/recipe.dart';
import '../services/recipe_service.dart';
import '../widgets/recipe_card.dart';
import '../constants.dart';

class HomeScreen extends StatelessWidget {
  final RecipeService _recipeService = RecipeService();

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar sozlamalari
      appBar: AppBar(
        title: const Text(
          "O‘zbekona Ta’m",
          style: kTitleStyle,
        ),
        backgroundColor: kPrimaryColor,
        elevation: 0, // Soyasiz tekis ko‘rinish uchun
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
      // Asosiy kontent
      body: Column(
        children: [
          // Qidiruv paneli (keyinroq funksionallik qo‘shiladi)
          Padding(
            padding: const EdgeInsets.all(kDefaultPadding),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Taom qidirish...",
                hintStyle: kBodyStyle,
                prefixIcon: const Icon(Icons.search, color: kPrimaryColor),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          // Retseptlar ro‘yxati
          Expanded(
            child: StreamBuilder<List<Recipe>>(
              stream: _recipeService.getRecipes(),
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
                    ),
                  );
                }
                // Ma’lumot yo‘q holati
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Text(
                      "Hozircha retseptlar yo‘q. Yangi retsept qo‘shing!",
                      style: kBodyStyle,
                      textAlign: TextAlign.center,
                    ),
                  );
                }
                // Ma’lumot mavjud bo‘lsa
                final recipes = snapshot.data!;
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                  itemCount: recipes.length,
                  itemBuilder: (context, index) {
                    return RecipeCard(recipe: recipes[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
      backgroundColor: kBackgroundColor,
    );
  }
}