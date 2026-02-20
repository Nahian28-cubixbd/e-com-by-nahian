import 'package:flutter/material.dart';
import '../../domain/entities/category.dart';
import '../pages/category_products_page.dart';
import '../../../../core/theme/app_theme.dart';

class CategoryGrid extends StatelessWidget {
  final List<Category> categories;

  const CategoryGrid({super.key, required this.categories});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.4,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        return CategoryCard(category: categories[index]);
      },
    );
  }
}

class CategoryCard extends StatelessWidget {
  final Category category;

  const CategoryCard({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final colorPair = _getCategoryColor(category.slug);
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => CategoryProductsPage(category: category),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: colorPair,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: colorPair[0].withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              right: -10,
              top: -10,
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.1),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    _getCategoryIcon(category.slug),
                    color: Colors.white,
                    size: 28,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        category.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.2,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        'View products →',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Color> _getCategoryColor(String slug) {
    final Map<String, List<Color>> colorMap = {
      'beauty': [const Color(0xFFFF6B9D), const Color(0xFFC44569)],
      'fragrances': [const Color(0xFFA18CD1), const Color(0xFFFBC2EB)],
      'furniture': [const Color(0xFF6C5CE7), const Color(0xFFA29BFE)],
      'groceries': [const Color(0xFF00B894), const Color(0xFF00CEC9)],
      'home-decoration': [const Color(0xFFFD79A8), const Color(0xFFE84393)],
      'kitchen-accessories': [const Color(0xFFFF7675), const Color(0xFFD63031)],
      'laptops': [const Color(0xFF0984E3), const Color(0xFF74B9FF)],
      'mens-shirts': [const Color(0xFF2D3436), const Color(0xFF636E72)],
      'mens-shoes': [const Color(0xFF6D4C41), const Color(0xFF8D6E63)],
      'mens-watches': [const Color(0xFF1A1A2E), const Color(0xFF16213E)],
      'mobile-accessories': [const Color(0xFF0652DD), const Color(0xFF1289A7)],
      'motorcycle': [const Color(0xFFED4C67), const Color(0xFFB53471)],
      'skin-care': [const Color(0xFFFFC8DD), const Color(0xFFFFAFCC)],
      'smartphones': [const Color(0xFF4A90E2), const Color(0xFF5C6BC0)],
      'sports-accessories': [const Color(0xFF11998E), const Color(0xFF38EF7D)],
      'sunglasses': [const Color(0xFFF9CA24), const Color(0xFFF0932B)],
      'tablets': [const Color(0xFF6C5CE7), const Color(0xFF74B9FF)],
      'tops': [const Color(0xFFFF9FF3), const Color(0xFFF368E0)],
      'vehicle': [const Color(0xFF57606F), const Color(0xFF2F3542)],
      'womens-bags': [const Color(0xFFFF6B81), const Color(0xFFFF4757)],
      'womens-dresses': [const Color(0xFFECAD3F), const Color(0xFFF9CA24)],
      'womens-jewellery': [const Color(0xFFCCCBCB), const Color(0xFF95AABE)],
      'womens-shoes': [const Color(0xFFFF8C42), const Color(0xFFF79F1F)],
      'womens-watches': [const Color(0xFFB8860B), const Color(0xFFDAA520)],
    };
    return colorMap[slug] ??
        [AppColors.primary, AppColors.surface];
  }

  IconData _getCategoryIcon(String slug) {
    final Map<String, IconData> iconMap = {
      'beauty': Icons.face_retouching_natural_rounded,
      'fragrances': Icons.spa_rounded,
      'furniture': Icons.chair_rounded,
      'groceries': Icons.shopping_basket_rounded,
      'home-decoration': Icons.home_rounded,
      'kitchen-accessories': Icons.kitchen_rounded,
      'laptops': Icons.laptop_rounded,
      'mens-shirts': Icons.checkroom_rounded,
      'mens-shoes': Icons.sports_rounded,
      'mens-watches': Icons.watch_rounded,
      'mobile-accessories': Icons.phone_iphone_rounded,
      'motorcycle': Icons.two_wheeler_rounded,
      'skin-care': Icons.face_rounded,
      'smartphones': Icons.smartphone_rounded,
      'sports-accessories': Icons.sports_basketball_rounded,
      'sunglasses': Icons.wb_sunny_rounded,
      'tablets': Icons.tablet_rounded,
      'tops': Icons.dry_cleaning_rounded,
      'vehicle': Icons.directions_car_rounded,
      'womens-bags': Icons.shopping_bag_rounded,
      'womens-dresses': Icons.woman_rounded,
      'womens-jewellery': Icons.diamond_rounded,
      'womens-shoes': Icons.dry_cleaning_rounded,
      'womens-watches': Icons.watch_rounded,
    };
    return iconMap[slug] ?? Icons.category_rounded;
  }
}
