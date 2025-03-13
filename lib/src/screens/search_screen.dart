import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../constants/app_colors.dart';
import '../models/recipe.dart';
import '../services/recipe_service.dart';
import '../widgets/recipe_card.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final RecipeService _recipeService = RecipeService();
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'All';
  String _searchQuery = '';
  List<String> _suggestions = ['Sushi', 'Sandwich', 'Seafood', 'Fried rice'];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search recipes...',
                  prefixIcon: Icon(Icons.search, color: AppColors.textPrimary),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(30.0)),
                  filled: true,
                  fillColor: AppColors.cardBackground,
                  suffixIcon: IconButton(
                    icon: Icon(Icons.clear, color: AppColors.textPrimary),
                    onPressed: () {
                      _searchController.clear();
                      setState(() => _searchQuery = '');
                    },
                  ),
                ),
                onChanged: (value) {
                  setState(() => _searchQuery = value.trim().toLowerCase());
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: ['All', 'Food', 'Drink'].map((category) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ChoiceChip(
                        label: Text(category),
                        selected: _selectedCategory == category,
                        selectedColor: AppColors.primaryGreen,
                        backgroundColor: AppColors.cardBackground,
                        labelStyle: TextStyle(
                          color: _selectedCategory == category ? Colors.white : AppColors.textPrimary,
                        ),
                        onSelected: (selected) {
                          if (selected) {
                            setState(() => _selectedCategory = category);
                          }
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            Expanded(
              child: _searchQuery.isEmpty
                  ? _buildSuggestions()
                  : _buildSearchResults(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestions() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Search suggestions',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
          ),
          SizedBox(height: 10),
          ..._suggestions.map((suggestion) {
            return ListTile(
              title: Text(suggestion, style: TextStyle(color: AppColors.textPrimary)),
              onTap: () {
                _searchController.text = suggestion;
                setState(() => _searchQuery = suggestion.toLowerCase());
              },
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    return StreamBuilder<QuerySnapshot>(
      stream: _recipeService.getApprovedRecipes(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('No recipes found.', style: TextStyle(color: AppColors.textPrimary)));
        }

        final recipes = snapshot.data!.docs
            .map((doc) => Recipe.fromJson(doc.data() as Map<String, dynamic>))
            .toList();

        final filteredRecipes = recipes.where((recipe) {
          final matchesQuery = recipe.name.toLowerCase().contains(_searchQuery);
          final matchesCategory = _selectedCategory == 'All' ||
              (_selectedCategory == 'Food' && !recipe.name.toLowerCase().contains('drink')) ||
              (_selectedCategory == 'Drink' && recipe.name.toLowerCase().contains('drink'));
          return matchesQuery && matchesCategory;
        }).toList();

        if (filteredRecipes.isEmpty) {
          return Center(child: Text('No matching recipes found.', style: TextStyle(color: AppColors.textPrimary)));
        }

        return ListView.builder(
          itemCount: filteredRecipes.length,
          itemBuilder: (context, index) {
            final recipe = filteredRecipes[index];
            return RecipeCard(
              recipe: recipe,
              onTap: () => context.go('/recipe/${recipe.id}'),
            );
          },
        );
      },
    );
  }
}