import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../constants/app_colors.dart';
import '../models/recipe.dart';
import '../services/recipe_service.dart';
import '../widgets/custom_button.dart';

class RecipeDetailScreen extends StatefulWidget {
  final String recipeId;

  RecipeDetailScreen({required this.recipeId});

  @override
  _RecipeDetailScreenState createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  final RecipeService _recipeService = RecipeService();
  Recipe? _recipe;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadRecipe();
  }

  Future<void> _loadRecipe() async {
    try {
      final recipe = await _recipeService.getRecipeById(widget.recipeId);
      setState(() {
        _recipe = recipe;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error loading recipe: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: Text('Recipe Details', style: TextStyle(color: AppColors.textPrimary)),
        backgroundColor: AppColors.cardBackground,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => context.go('/home'),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: _recipe == null
              ? _errorMessage != null
                  ? Center(child: Text(_errorMessage!, style: TextStyle(color: Colors.red)))
                  : Center(child: CircularProgressIndicator())
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Retsept rasmi
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: Image.network(
                        _recipe!.imageUrl.isNotEmpty
                            ? _recipe!.imageUrl
                            : 'https://via.placeholder.com/300',
                        height: 200,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset('assets/placeholder_image.jpg', height: 200, fit: BoxFit.cover); // Placeholder rasm
                        },
                      ),
                    ),
                    SizedBox(height: 16),
                    // Retsept nomi
                    Text(
                      _recipe!.name,
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 8),
                    // Reyting va pishirish vaqti
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.star, color: AppColors.primaryGreen, size: 20),
                        SizedBox(width: 5),
                        Text(
                          _recipe!.rating.toStringAsFixed(1),
                          style: TextStyle(fontSize: 16, color: AppColors.textPrimary),
                        ),
                        SizedBox(width: 16),
                        Icon(Icons.timer, color: AppColors.accentGray, size: 20),
                        SizedBox(width: 5),
                        Text(
                          '${_recipe!.cookingTime} mins',
                          style: TextStyle(fontSize: 16, color: AppColors.accentGray),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    // Tasvir
                    Text(
                      _recipe!.description,
                      style: TextStyle(fontSize: 16, color: AppColors.textPrimary),
                      textAlign: TextAlign.justify,
                    ),
                    SizedBox(height: 16),
                    // Masalliqlar
                    Text(
                      'Ingredients',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                    ),
                    SizedBox(height: 8),
                    ..._recipe!.ingredients.map((ingredient) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Row(
                          children: [
                            Icon(Icons.check_circle, color: AppColors.primaryGreen, size: 16),
                            SizedBox(width: 8),
                            Expanded(child: Text(ingredient, style: TextStyle(fontSize: 16, color: AppColors.textPrimary))),
                          ],
                        ),
                      );
                    }).toList(),
                    SizedBox(height: 16),
                    // Qadamlar
                    Text(
                      'Steps',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                    ),
                    SizedBox(height: 8),
                    ...List.generate(_recipe!.steps.length, (index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${index + 1}. ', style: TextStyle(fontSize: 16, color: AppColors.textPrimary)),
                            Expanded(child: Text(_recipe!.steps[index], style: TextStyle(fontSize: 16, color: AppColors.textPrimary))),
                          ],
                        ),
                      );
                    }),
                    SizedBox(height: 24),
                    // Tahrirlash tugmasi (keyinchalik funksiyalashadi)
                    CustomButton(
                      text: 'Edit Recipe',
                      color: AppColors.primaryGreen,
                      onPressed: () {
                        // Hozircha placeholder, keyinroq tahrirlash logikasi qo‘shiladi
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Edit functionality coming soon!')),
                        );
                      },
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}