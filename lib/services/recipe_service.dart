import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/recipe.dart';
import '../constants.dart';

class RecipeService {
  final CollectionReference _recipesCollection =
      FirebaseFirestore.instance.collection(kRecipesCollection);

  // Barcha retseptlarni olish (real vaqt)
  Stream<List<Recipe>> getRecipes() {
    return _recipesCollection.snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Recipe.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList());
  }

  // Muayyan retseptni ID bo‘yicha olish
  Future<Recipe?> getRecipeById(String id) async {
    try {
      final doc = await _recipesCollection.doc(id).get();
      if (!doc.exists) return null;
      return Recipe.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    } catch (e) {
      throw Exception("Retseptni olishda xatolik: $e");
    }
  }

  // Yangi retsept qo‘shish
  Future<void> addRecipe(Recipe recipe) async {
    try {
      await _recipesCollection.add({
        'title': recipe.title,
        'ingredients': recipe.ingredients,
        'instructions': recipe.instructions,
        'photo_url': recipe.photoUrl,
        'author_id': recipe.authorId,
        'created_at': FieldValue.serverTimestamp(), // Qo‘shilgan vaqtni saqlash
      });
    } catch (e) {
      throw Exception("Retsept qo‘shishda xatolik: $e");
    }
  }

  // Foydalanuvchi retseptlarini olish (real vaqt)
  Stream<List<Recipe>> getUserRecipes(String userId) {
    return _recipesCollection
        .where('author_id', isEqualTo: userId)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Recipe.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList());
  }
}