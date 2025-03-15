import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import '../constants/app_colors.dart';
import '../models/recipe.dart';
import '../services/recipe_service.dart';
import '../widgets/custom_button.dart';

class AddRecipeScreen extends StatefulWidget {
  @override
  _AddRecipeScreenState createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {
  final RecipeService _recipeService = RecipeService();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _cookingTimeController = TextEditingController();
  final List<TextEditingController> _ingredientControllers = [TextEditingController()];
  final List<TextEditingController> _stepControllers = [TextEditingController()];
  File? _imageFile;
  String? _errorMessage;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _cookingTimeController.dispose();
    _ingredientControllers.forEach((controller) => controller.dispose());
    _stepControllers.forEach((controller) => controller.dispose());
    super.dispose();
  }

  // Rasm tanlash funksiyasi
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  // Retseptni saqlash
  Future<void> _submitRecipe() async {
    if (_nameController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        _cookingTimeController.text.isEmpty ||
        _ingredientControllers.any((controller) => controller.text.isEmpty) ||
        _stepControllers.any((controller) => controller.text.isEmpty) ||
        _imageFile == null) {
      setState(() => _errorMessage = 'Please fill all fields and upload an image.');
      return;
    }

    try {
      // Rasmni Firebase Storage’ga yuklash
      String imageUrl = await _recipeService.uploadImage(_imageFile!, Uuid().v4());

      // Retseptni yaratish
      Recipe newRecipe = Recipe(
        id: Uuid().v4(),
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        rating: 0.0,
        ingredients: _ingredientControllers.map((controller) => controller.text.trim()).toList(),
        steps: _stepControllers.map((controller) => controller.text.trim()).toList(),
        cookingTime: int.parse(_cookingTimeController.text.trim()),
        imageUrl: imageUrl,
      );

      // Firestore’ga saqlash (admin tasdiqlashi uchun approved: false)
      await _recipeService.addRecipe(newRecipe, approved: false);

      // Muvaffaqiyatli saqlangandan so‘ng Home sahifasiga qaytish
      context.go('/home');
    } catch (e) {
      setState(() => _errorMessage = 'Error adding recipe: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: Text('Add New Recipe', style: TextStyle(color: AppColors.textPrimary)),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Retsept nomi
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Recipe Name',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
                  filled: true,
                  fillColor: AppColors.cardBackground,
                ),
              ),
              SizedBox(height: 16),
              // Tasvir
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
                  filled: true,
                  fillColor: AppColors.cardBackground,
                ),
                maxLines: 3,
              ),
              SizedBox(height: 16),
              // Pishirish vaqti
              TextField(
                controller: _cookingTimeController,
                decoration: InputDecoration(
                  labelText: 'Cooking Time (minutes)',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
                  filled: true,
                  fillColor: AppColors.cardBackground,
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16),
              // Rasm yuklash
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 150,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.accentGray),
                    borderRadius: BorderRadius.circular(12.0),
                    color: AppColors.cardBackground,
                  ),
                  child: _imageFile == null
                      ? Center(child: Text('Upload Image', style: TextStyle(color: AppColors.accentGray)))
                      : Image.file(_imageFile!, fit: BoxFit.cover),
                ),
              ),
              SizedBox(height: 16),
              // Masalliqlar
              Text('Ingredients', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
              ...List.generate(_ingredientControllers.length, (index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _ingredientControllers[index],
                          decoration: InputDecoration(
                            labelText: 'Ingredient ${index + 1}',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
                            filled: true,
                            fillColor: AppColors.cardBackground,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.remove_circle, color: AppColors.secondaryRed),
                        onPressed: () {
                          if (_ingredientControllers.length > 1) {
                            setState(() {
                              _ingredientControllers[index].dispose();
                              _ingredientControllers.removeAt(index);
                            });
                          }
                        },
                      ),
                    ],
                  ),
                );
              }),
              TextButton(
                onPressed: () {
                  setState(() {
                    _ingredientControllers.add(TextEditingController());
                  });
                },
                child: Text('Add Ingredient', style: TextStyle(color: AppColors.primaryGreen)),
              ),
              SizedBox(height: 16),
              // Qadamlar
              Text('Steps', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
              ...List.generate(_stepControllers.length, (index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _stepControllers[index],
                          decoration: InputDecoration(
                            labelText: 'Step ${index + 1}',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
                            filled: true,
                            fillColor: AppColors.cardBackground,
                          ),
                          maxLines: 2,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.remove_circle, color: AppColors.secondaryRed),
                        onPressed: () {
                          if (_stepControllers.length > 1) {
                            setState(() {
                              _stepControllers[index].dispose();
                              _stepControllers.removeAt(index);
                            });
                          }
                        },
                      ),
                    ],
                  ),
                );
              }),
              TextButton(
                onPressed: () {
                  setState(() {
                    _stepControllers.add(TextEditingController());
                  });
                },
                child: Text('Add Step', style: TextStyle(color: AppColors.primaryGreen)),
              ),
              SizedBox(height: 16),
              // Xato xabari
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Text(_errorMessage!, style: TextStyle(color: Colors.red)),
                ),
              // Submit tugmasi
              CustomButton(
                text: 'Submit Recipe',
                color: AppColors.primaryGreen,
                onPressed: _submitRecipe,
              ),
            ],
          ),
        ),
      ),
    );
  }
}