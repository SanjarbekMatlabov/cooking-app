import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/recipe.dart';

class RecipeService {
  final CollectionReference _recipesCollection =
      FirebaseFirestore.instance.collection('recipes');

  Stream<QuerySnapshot> getApprovedRecipes() {
    return _recipesCollection.where('approved', isEqualTo: true).snapshots();
  }

  Future<Recipe> getRecipeById(String id) async {
    DocumentSnapshot doc = await _recipesCollection.doc(id).get();
    return Recipe.fromJson(doc.data() as Map<String, dynamic>);
  }

  Future<void> addRecipe(Recipe recipe) async {
    await _recipesCollection.doc(recipe.id).set(recipe.toJson());
  }

  Future<void> updateRecipe(Recipe recipe) async {
    await _recipesCollection.doc(recipe.id).update(recipe.toJson());
  }
}