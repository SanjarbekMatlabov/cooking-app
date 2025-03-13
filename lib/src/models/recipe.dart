class Recipe {
  final String id;
  final String name;
  final String description;
  final double rating;
  final List<String> ingredients;
  final List<String> steps;
  final int cookingTime;
  final String imageUrl;

  Recipe({
    required this.id,
    required this.name,
    required this.description,
    required this.rating,
    required this.ingredients,
    required this.steps,
    required this.cookingTime,
    required this.imageUrl,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'] ?? '',
      name: json['name'] ?? 'Unnamed Recipe',
      description: json['description'] ?? '',
      rating: (json['rating'] ?? 0.0).toDouble(),
      ingredients: List<String>.from(json['ingredients'] ?? []),
      steps: List<String>.from(json['steps'] ?? []),
      cookingTime: json['cookingTime'] ?? 0,
      imageUrl: json['imageUrl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'rating': rating,
        'ingredients': ingredients,
        'steps': steps,
        'cookingTime': cookingTime,
        'imageUrl': imageUrl,
      };
}