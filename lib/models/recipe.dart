class Recipe {
  final String id;
  final String title;
  final String ingredients;
  final String instructions;
  final String? photoUrl;
  final String authorId;

  Recipe({
    required this.id,
    required this.title,
    required this.ingredients,
    required this.instructions,
    this.photoUrl,
    required this.authorId,
  });

  factory Recipe.fromMap(Map<String, dynamic> data, String id) {
    return Recipe(
      id: id,
      title: data['title'] ?? '',
      ingredients: data['ingredients'] ?? '',
      instructions: data['instructions'] ?? '',
      photoUrl: data['photo_url'],
      authorId: data['author_id'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'ingredients': ingredients,
      'instructions': instructions,
      'photo_url': photoUrl,
      'author_id': authorId,
    };
  }
}