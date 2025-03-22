// lib/presentation/screens/recipe/recipe_detail_screen.dart
import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../widgets/common/custom_button.dart';

class RecipeDetailScreen extends StatefulWidget {
  final String recipeId;

  const RecipeDetailScreen({
    Key? key,
    required this.recipeId,
  }) : super(key: key);

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLiked = false;
  int _likeCount = 273;
  
  // Sample recipe data - would typically be fetched from a repository
  late Map<String, dynamic> _recipe;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    
    // Mock data - would be fetched from Firestore
    _recipe = {
      'id': widget.recipeId,
      'title': 'Cacao Maca Walnut Milk',
      'category': 'Food',
      'time': '60 mins',
      'authorName': 'Madeam Qasim',
      'authorImage': 'assets/avatars/author.jpg',
      'image': 'assets/images/milk.jpg',
      'description': 'Your recipe has been uploaded, you can see it on your profile. Your recipe has been uploaded, you can see it on your profile.',
      'ingredients': [
        '4 Eggs',
        '1/2 Butter',
        '1/2 Butter',
      ],
      'steps': [
        'Your recipe has been uploaded, you can see it on your profile. Your recipe has been uploaded, you can see it on your profile.',
        'Your recipe has been uploaded, you can see it on your profile. Your recipe has been uploaded, you can see it on your profile.',
      ],
    };
    
    _isLiked = false;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _toggleLike() {
    setState(() {
      _isLiked = !_isLiked;
      if (_isLiked) {
        _likeCount++;
      } else {
        _likeCount--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App bar with image
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.asset(
                _recipe['image'],
                fit: BoxFit.cover,
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  _isLiked ? Icons.favorite : Icons.favorite_border,
                  color: _isLiked ? Colors.red : Colors.white,
                ),
                onPressed: _toggleLike,
              ),
              IconButton(
                icon: const Icon(Icons.share),
                onPressed: () {
                  // Implement share functionality
                },
              ),
            ],
          ),
          
          // Recipe content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and category
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _recipe['title'],
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Text(
                                  _recipe['category'],
                                  style: TextStyle(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                const Text(' • '),
                                Text(
                                  _recipe['time'],
                                  style: TextStyle(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      
                      // Like count
                      Row(
                        children: [
                          const Icon(
                            Icons.favorite,
                            color: Colors.red,
                            size: 20,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '$_likeCount Likes',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Author
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundImage: AssetImage(_recipe['authorImage']),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _recipe['authorName'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Description
                  const Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(_recipe['description']),
                  
                  const SizedBox(height: 24),
                  
                  // Tabs
                  TabBar(
                    controller: _tabController,
                    tabs: const [
                      Tab(text: 'Ingredients'),
                      Tab(text: 'Steps'),
                    ],
                    labelColor: AppColors.primary,
                    unselectedLabelColor: AppColors.textSecondary,
                    indicatorColor: AppColors.primary,
                  ),
                  
                  SizedBox(
                    height: 250, // Fixed height for tab content
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        // Ingredients tab
                        _buildIngredientsTab(),
                        
                        // Steps tab
                        _buildStepsTab(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: CustomButton(
          text: 'Try This Recipe',
          onPressed: () {
            // Implement try recipe functionality
          },
        ),
      ),
    );
  }

  Widget _buildIngredientsTab() {
    return ListView.builder(
      itemCount: _recipe['ingredients'].length,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 16),
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Row(
            children: [
              const Icon(
                Icons.check_circle,
                color: AppColors.primary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(_recipe['ingredients'][index]),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStepsTab() {
    return ListView.builder(
      itemCount: _recipe['steps'].length,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 16),
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 12,
                backgroundColor: AppColors.primary,
                child: Text(
                  '${index + 1}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(_recipe['steps'][index]),
              ),
            ],
          ),
        );
      },
    );
  }
}