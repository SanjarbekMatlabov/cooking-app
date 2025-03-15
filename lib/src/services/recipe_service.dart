import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/recipe.dart';

class RecipeService {
  final CollectionReference _recipesCollection =
      FirebaseFirestore.instance.collection('recipes');
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Stream<QuerySnapshot> getApprovedRecipes() {
    return _recipesCollection.where('approved', isEqualTo: true).snapshots();
  }

  Stream<QuerySnapshot> getUserRecipes(String userId) {
    return _recipesCollection.where('userId', isEqualTo: userId).snapshots();
  }

  Future<Recipe> getRecipeById(String id) async {
    DocumentSnapshot doc = await _recipesCollection.doc(id).get();
    return Recipe.fromJson(doc.data() as Map<String, dynamic>);
  }

  Future<String> uploadImage(File image, String recipeId) async {
    Reference ref = _storage.ref().child('recipe_images/$recipeId.jpg');
    UploadTask uploadTask = ref.putFile(image);
    TaskSnapshot snapshot = await uploadTask;
    return await snapshot.ref.getDownloadURL();
  }

  Future<void> addRecipe(Recipe recipe, {bool approved = false}) async {
    Map<String, dynamic> recipeData = recipe.toJson();
    recipeData['approved'] = approved;
    recipeData['userId'] = FirebaseAuth.instance.currentUser?.uid ?? '';
    await _recipesCollection.doc(recipe.id).set(recipeData);
  }

  Future<void> updateRecipe(Recipe recipe) async {
    await _recipesCollection.doc(recipe.id).update(recipe.toJson());
  }
}