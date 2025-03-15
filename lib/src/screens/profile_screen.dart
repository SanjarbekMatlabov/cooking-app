import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../constants/app_colors.dart';
import '../models/recipe.dart';
import '../services/auth_service.dart';
import '../services/recipe_service.dart';
import '../widgets/custom_button.dart';
import '../widgets/recipe_card.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthService _authService = AuthService();
  final RecipeService _recipeService = RecipeService();
  User? _currentUser;
  Map<String, dynamic>? _userData;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    _currentUser = FirebaseAuth.instance.currentUser;
    if (_currentUser != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(_currentUser!.uid)
          .get();
      setState(() {
        _userData = userDoc.data() as Map<String, dynamic>?;
      });
    } 
  }

  Future<void> _signOut() async {
    try {
      await _authService.signOut();
      context.go('/sign-in');
    } catch (e) {
      setState(() => _errorMessage = 'Error signing out: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: Text('Profile', style: TextStyle(color: AppColors.textPrimary)),
        backgroundColor: AppColors.cardBackground,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Profil ma’lumotlari
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: AppColors.primaryGreen,
                      child: Text(
                        _currentUser?.email?.substring(0, 1).toUpperCase() ?? 'U',
                        style: TextStyle(fontSize: 40, color: Colors.white),
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      _currentUser?.email ?? 'Loading...',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Coins: ${_userData?['coins'] ?? 0}',
                      style: TextStyle(fontSize: 16, color: AppColors.accentGray),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),
              // Foydalanuvchi retseptlari
              Text(
                'Your Recipes',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              ),
              SizedBox(height: 16),
              StreamBuilder<QuerySnapshot>(
                stream: _recipeService.getUserRecipes(_currentUser?.uid ?? ''),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text('No recipes added yet.', style: TextStyle(color: AppColors.textPrimary)));
                  }

                  final recipes = snapshot.data!.docs
                      .map((doc) => Recipe.fromJson(doc.data() as Map<String, dynamic>))
                      .toList();

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: recipes.length,
                    itemBuilder: (context, index) {
                      final recipe = recipes[index];
                      return RecipeCard(
                        recipe: recipe,
                        onTap: () => context.go('/recipe/${recipe.id}'),
                      );
                    },
                  );
                },
              ),
              SizedBox(height: 24),
              // Xato xabari
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Text(_errorMessage!, style: TextStyle(color: Colors.red)),
                ),
              // Log Out tugmasi
              CustomButton(
                text: 'Log Out',
                color: AppColors.secondaryRed,
                onPressed: _signOut,
              ),
            ],
          ),
        ),
      ),
    );
  }
}