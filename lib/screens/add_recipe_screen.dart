import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import '../models/recipe.dart';
import '../services/recipe_service.dart';
import '../constants.dart';

class AddRecipeScreen extends StatefulWidget {
  const AddRecipeScreen({super.key});

  @override
  _AddRecipeScreenState createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {
  final _titleController = TextEditingController();
  final _ingredientsController = TextEditingController();
  final _instructionsController = TextEditingController();
  final RecipeService _recipeService = RecipeService();
  bool _isLoading = false;

  // Retsept qo‘shish funksiyasi
  Future<void> _addRecipe() async {
    if (_titleController.text.isEmpty ||
        _ingredientsController.text.isEmpty ||
        _instructionsController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Iltimos, barcha maydonlarni to‘ldiring"),
          backgroundColor: kSecondaryColor,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final recipe = Recipe(
        id: '', // Firestore avtomatik ID beradi
        title: _titleController.text.trim(),
        ingredients: _ingredientsController.text.trim(),
        instructions: _instructionsController.text.trim(),
        photoUrl: null, // Hozircha fotosiz
        authorId: user.uid,
      );
      try {
        await _recipeService.addRecipe(recipe);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Retsept muvaffaqiyatli qo‘shildi!"),
              backgroundColor: kPrimaryColor,
            ),
          );
          context.go('/home'); // Saqlangach bosh sahifaga qaytish
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Xatolik yuz berdi: $e"),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
    setState(() => _isLoading = false);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _ingredientsController.dispose();
    _instructionsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Retsept Qo‘shish",
          style: kTitleStyle,
        ),
        backgroundColor: kPrimaryColor,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(kDefaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Taom nomi
                  TextField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      labelText: "Taom Nomi",
                      labelStyle: kBodyStyle,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: const BorderSide(color: kPrimaryColor),
                      ),
                    ),
                  ),
                  const SizedBox(height: kDefaultPadding),
                  // Masalliqlar
                  TextField(
                    controller: _ingredientsController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: "Masalliqlar",
                      labelStyle: kBodyStyle,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: const BorderSide(color: kPrimaryColor),
                      ),
                    ),
                  ),
                  const SizedBox(height: kDefaultPadding),
                  // Tayyorlash usuli
                  TextField(
                    controller: _instructionsController,
                    maxLines: 5,
                    decoration: InputDecoration(
                      labelText: "Tayyorlash Usuli",
                      labelStyle: kBodyStyle,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: const BorderSide(color: kPrimaryColor),
                      ),
                    ),
                  ),
                  const SizedBox(height: kDefaultPadding * 2),
                  // Saqlash tugmasi
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _addRecipe,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kSecondaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 14.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                      child: const Text(
                        "Saqlash",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
      backgroundColor: kBackgroundColor,
    );
  }
}