// lib/presentation/screens/home/home_screen.dart
import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../widgets/recipe/recipe_card.dart';
import '../recipe/recipe_detail_screen.dart';
import '../recipe/recipe_upload_screen.dart';
import '../profile/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  String _selectedCategory = 'All';
  final List<String> _categories = ['All', 'Food', 'Drink'];
  
  // Sample recipe data - would typically come from a repository
  final List<Map<String, dynamic>> _recipes = [
    {
      'id': '1',
      'title': 'Pancake',
      'imageUrl': 'assets/images/pancake.jpg',
      'author': 'Caleb Lewis',
      'time': '30 min',
      'liked': true,
      'likes': 273,
    },
    {
      'id': '2',
      'title': 'Salad',
      'imageUrl': 'assets/images/salad.jpg',
      'author': 'Elif Shafak',
      'time': '20 min',
      'liked': false,
      'likes': 189,
    },
    {
      'id': '3',
      'title': 'Cacao Maca Walnut Milk',
      'imageUrl': 'assets/images/milk.jpg',
      'author': 'Elena Shelby',
      'time': '60 min',
      'liked': false,
      'likes': 273,
    },
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    
    // Handle navigation to different tabs
    if (index == 3) { // Profile
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const ProfileScreen()),
      );
    } else if (index == 1) { // Add recipe
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const RecipeUploadScreen()),
      );
    }
  }

  void _selectCategory(String category) {
    setState(() {
      _selectedCategory = category;
    });
    // In a real app, you would filter recipes based on category
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search bar
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: AppColors.inputBackground,
                  ),
                ),
              ),
              
              // Category header
              const Text(
                'Category',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              
              // Category chips
              SizedBox(
                height: 40,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _categories.length,
                  itemBuilder: (context, index) {
                    final category = _categories[index];
                    final isSelected = category == _selectedCategory;
                    
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: FilterChip(
                        label: Text(category),
                        selected: isSelected,
                        onSelected: (_) => _selectCategory(category),
                        backgroundColor: isSelected ? AppColors.primary : AppColors.inputBackground,
                        selectedColor: AppColors.primary,
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : AppColors.textPrimary,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        showCheckmark: false,
                      ),
                    );
                  },
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Recipes grid
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: _recipes.length,
                  itemBuilder: (context, index) {
                    final recipe = _recipes[index];
                    return RecipeCard(
                      title: recipe['title'],
                      imageUrl: recipe['imageUrl'],
                      author: recipe['author'],
                      time: recipe['time'],
                      liked: recipe['liked'],
                      likes: recipe['likes'],
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => RecipeDetailScreen(recipeId: recipe['id']),
                          ),
                        );
                      },
                      onLikeTap: () {
                        // Toggle like state
                        setState(() {
                          _recipes[index]['liked'] = !recipe['liked'];
                          if (recipe['liked']) {
                            _recipes[index]['likes']++;
                          } else {
                            _recipes[index]['likes']--;
                          }
                        });
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            activeIcon: Icon(Icons.add_circle),
            label: 'Create',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_outlined),
            activeIcon: Icon(Icons.notifications),
            label: 'Notification',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}