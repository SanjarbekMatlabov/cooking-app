// lib/presentation/screens/recipe/recipe_upload_screen.dart
import 'package:flutter/material.dart';
import 'dart:io';
import '../../../app/theme/app_colors.dart';
import '../../widgets/common/custom_button.dart';

class RecipeUploadScreen extends StatefulWidget {
  const RecipeUploadScreen({Key? key}) : super(key: key);

  @override
  State<RecipeUploadScreen> createState() => _RecipeUploadScreenState();
}

class _RecipeUploadScreenState extends State<RecipeUploadScreen> {
  final PageController _pageController = PageController();
  int _currentStep = 0;
  final int _totalSteps = 3;

  // Recipe data
  File? _imageFile;
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  int _cookingDuration = 30; // default 30 minutes
  final List<String> _ingredients = [];
  final List<String> _steps = [];

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < _totalSteps - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() {
        _currentStep++;
      });
    } else {
      _submitRecipe();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() {
        _currentStep--;
      });
    } else {
      Navigator.pop(context);
    }
  }

  Future<void> _pickImage() async {
    // Would typically use image_picker package
    // final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    // if (pickedFile != null) {
    //   setState(() {
    //     _imageFile = File(pickedFile.path);
    //   });
    // }
  }

  void _addIngredient(String ingredient) {
    if (ingredient.isNotEmpty) {
      setState(() {
        _ingredients.add(ingredient);
      });
    }
  }

  void _removeIngredient(int index) {
    setState(() {
      _ingredients.removeAt(index);
    });
  }

  void _addStep(String step) {
    if (step.isNotEmpty) {
      setState(() {
        _steps.add(step);
      });
    }
  }

  void _removeStep(int index) {
    setState(() {
      _steps.removeAt(index);
    });
  }

  void _submitRecipe() async {
    // Implement Firebase upload logic here
    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      // Upload logic would go here
      // await recipeRepository.uploadRecipe(
      //   name: _nameController.text,
      //   description: _descriptionController.text,
      //   cookingTime: _cookingDuration,
      //   ingredients: _ingredients,
      //   steps: _steps,
      //   image: _imageFile,
      // );
      
      // Simulate upload delay
      await Future.delayed(const Duration(seconds: 2));
      
      if (mounted) {
        Navigator.pop(context); // Dismiss loading indicator
        
        // Navigate to success screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const UploadSuccessScreen(),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context); // Dismiss loading indicator
        
        // Show error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error uploading recipe: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Step ${_currentStep + 1}/$_totalSteps'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _previousStep,
        ),
        actions: [
          if (_currentStep < _totalSteps - 1)
            TextButton(
              onPressed: _nextStep,
              child: const Text('Next'),
            )
        ],
      ),
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          _buildUploadPhotoStep(),
          _buildIngredientsStep(),
          _buildStepsStep(),
        ],
      ),
    );
  }

  Widget _buildUploadPhotoStep() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Upload',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          
          // Image picker
          GestureDetector(
            onTap: _pickImage,
            child: Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.inputBackground,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.divider),
              ),
              child: _imageFile == null
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.camera_alt_outlined,
                          size: 48,
                          color: AppColors.textLight,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Add Cover Photo',
                          style: TextStyle(
                            color: AppColors.textLight,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '(up to 12 MB)',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textLight,
                          ),
                        ),
                      ],
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        _imageFile!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 24),
          
          // Food name field
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Food Name',
              hintText: 'Enter food name',
            ),
          ),
          const SizedBox(height: 16),
          
          // Description field
          TextField(
            controller: _descriptionController,
            decoration: const InputDecoration(
              labelText: 'Description',
              hintText: 'Tell more about your food',
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 24),
          
          // Cooking duration slider
          const Text(
            'Cooking Duration (in minutes)',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Text('10'),
              Expanded(
                child: Slider(
                  value: _cookingDuration.toDouble(),
                  min: 10,
                  max: 120,
                  divisions: 22,
                  label: _cookingDuration.toString(),
                  onChanged: (value) {
                    setState(() {
                      _cookingDuration = value.toInt();
                    });
                  },
                ),
              ),
              const Text('120'),
            ],
          ),
          Center(
            child: Text(
              '$_cookingDuration minutes',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          
          const Spacer(),
          
          CustomButton(
            text: 'Next',
            onPressed: _nextStep,
          ),
        ],
      ),
    );
  }

  Widget _buildIngredientsStep() {
    final _ingredientController = TextEditingController();
    
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Ingredients',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          
          // Add ingredient field
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _ingredientController,
                  decoration: const InputDecoration(
                    hintText: 'Enter ingredient',
                  ),
                  onSubmitted: (value) {
                    _addIngredient(value);
                    _ingredientController.clear();
                  },
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add_circle_outline),
                onPressed: () {
                  _addIngredient(_ingredientController.text);
                  _ingredientController.clear();
                },
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Ingredients list
          Expanded(
            child: _ingredients.isEmpty
                ? Center(
                    child: Text(
                      'No ingredients added yet',
                      style: TextStyle(color: AppColors.textLight),
                    ),
                  )
                : ListView.builder(
                    itemCount: _ingredients.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: const Icon(Icons.check, color: AppColors.primary),
                        title: Text(_ingredients[index]),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline, color: Colors.red),
                          onPressed: () => _removeIngredient(index),
                        ),
                      );
                    },
                  ),
          ),
          
          const SizedBox(height: 16),
          
          CustomButton(
            text: 'Next',
            onPressed: _nextStep,
          ),
        ],
      ),
    );
  }

  Widget _buildStepsStep() {
    final _stepController = TextEditingController();
    
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Steps',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          
          // Add step field
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _stepController,
                  decoration: const InputDecoration(
                    hintText: 'Tell a little about your food',
                  ),
                  onSubmitted: (value) {
                    _addStep(value);
                    _stepController.clear();
                  },
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add_circle_outline),
                onPressed: () {
                  _addStep(_stepController.text);
                  _stepController.clear();
                },
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Steps list
          Expanded(
            child: _steps.isEmpty
                ? Center(
                    child: Text(
                      'No steps added yet',
                      style: TextStyle(color: AppColors.textLight),
                    ),
                  )
                : ListView.builder(
                    itemCount: _steps.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: AppColors.primary,
                          child: Text(
                            '${index + 1}',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        title: Text(_steps[index]),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline, color: Colors.red),
                          onPressed: () => _removeStep(index),
                        ),
                      );
                    },
                  ),
          ),
          
          const SizedBox(height: 16),
          
          CustomButton(
            text: 'Submit Recipe',
            onPressed: _submitRecipe,
          ),
        ],
      ),
    );
  }
}

// Success Screen after recipe upload
class UploadSuccessScreen extends StatelessWidget {
  const UploadSuccessScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.sentiment_very_satisfied,
                size: 80,
                color: AppColors.primary,
              ),
              const SizedBox(height: 24),
              const Text(
                'Upload Success',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              const Text(
                'Your recipe has been uploaded, you can see it on your profile',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              CustomButton(
                text: 'Back to Home',
                onPressed: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}