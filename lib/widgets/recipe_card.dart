import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/recipe.dart';
import '../constants.dart';

class RecipeCard extends StatelessWidget {
  final Recipe recipe;

  const RecipeCard({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2, // Kichik soya
      shape: RoundedRectangleBorder(borderRadius: kDefaultBorderRadius),
      margin: const EdgeInsets.symmetric(
        vertical: kSmallPadding,
        horizontal: kDefaultPadding,
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(kDefaultPadding),
        // Retsept nomi
        title: Text(
          recipe.title,
          style: kSubtitleStyle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        // Masalliqlar (qisqartirilgan)
        subtitle: Text(
          recipe.ingredients,
          style: kBodyStyle.copyWith(color: Colors.grey[600]),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        // Agar rasm bo‘lsa, uni ko‘rsatish
        leading: recipe.photoUrl != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  recipe.photoUrl!,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.broken_image,
                    size: 50,
                    color: Colors.grey,
                  ),
                ),
              )
            : const Icon(
                Icons.food_bank,
                size: 50,
                color: kPrimaryColor,
              ),
        // Retsept detallariga o‘tish
        onTap: () {
          context.go('/recipe/${recipe.id}');
        },
      ),
    );
  }
}