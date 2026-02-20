import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../cart/presentation/cubit/cart_cubit.dart';
import '../../../cart/presentation/pages/cart_page.dart';
import '../../../categories/presentation/pages/categories_page.dart';
import '../../presentation/pages/all_products_page.dart';
import '../../../../core/theme/app_theme.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'E-Com by Nahian',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.5,
              ),
            ),
            Text(
              'Discover amazing products',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w400,
                color: Colors.white70,
              ),
            ),
          ],
        ),
        toolbarHeight: 64,
        actions: [
          BlocBuilder<CartCubit, CartState>(
            builder: (context, state) {
              return Padding(
                padding: const EdgeInsets.only(right: 16),
                child: GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CartPage()),
                  ),
                  child: badges.Badge(
                    showBadge: state.totalItemCount > 0,
                    badgeContent: Text(
                      state.totalItemCount.toString(),
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w700),
                    ),
                    badgeStyle: const badges.BadgeStyle(
                      badgeColor: AppColors.accentLight,
                      padding: EdgeInsets.all(5),
                    ),
                    child: const Icon(Icons.shopping_cart_outlined,
                        color: Colors.white, size: 26),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // _buildHeroBanner(),
            const SizedBox(height: 28),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Shop by',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                  letterSpacing: -0.3,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: _NavCard(
                      title: 'All Products',
                      subtitle: 'Browse our full\ncollection',
                      icon: Icons.grid_view_rounded,
                      gradient: const LinearGradient(
                        colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const AllProductsPage()),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: _NavCard(
                      title: 'Categories',
                      subtitle: 'Shop by\ncategory',
                      icon: Icons.category_rounded,
                      gradient: const LinearGradient(
                        colors: [Color(0xFFE94560), Color(0xFFFF6B6B)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const CategoriesPage()),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            _buildFeaturesSection(),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  // Widget _buildHeroBanner() {
  //   return Container(
  //     margin: const EdgeInsets.all(20),
  //     height: 160,
  //     decoration: BoxDecoration(
  //       borderRadius: BorderRadius.circular(20),
  //       gradient: const LinearGradient(
  //         colors: [Color(0xFF1A1A2E), Color(0xFF0F3460)],
  //         begin: Alignment.topLeft,
  //         end: Alignment.bottomRight,
  //       ),
  //       boxShadow: [
  //         BoxShadow(
  //           color: const Color(0xFF1A1A2E).withOpacity(0.3),
  //           blurRadius: 20,
  //           offset: const Offset(0, 8),
  //         ),
  //       ],
  //     ),
  //     child: Stack(
  //       children: [
  //         Positioned(
  //           right: -20,
  //           top: -20,
  //           child: Container(
  //             width: 150,
  //             height: 150,
  //             decoration: BoxDecoration(
  //               shape: BoxShape.circle,
  //               color: AppColors.accent.withOpacity(0.15),
  //             ),
  //           ),
  //         ),
  //         Positioned(
  //           right: 30,
  //           bottom: -30,
  //           child: Container(
  //             width: 100,
  //             height: 100,
  //             decoration: BoxDecoration(
  //               shape: BoxShape.circle,
  //               color: Colors.white.withOpacity(0.05),
  //             ),
  //           ),
  //         ),
  //         Padding(
  //           padding: const EdgeInsets.all(24),
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: [
  //               Container(
  //                 padding:
  //                     const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
  //                 decoration: BoxDecoration(
  //                   color: AppColors.accent.withOpacity(0.2),
  //                   borderRadius: BorderRadius.circular(20),
  //                 ),
  //                 child: const Text(
  //                   '🛍 NEW ARRIVALS',
  //                   style: TextStyle(
  //                     color: AppColors.accentLight,
  //                     fontSize: 11,
  //                     fontWeight: FontWeight.w600,
  //                     letterSpacing: 0.5,
  //                   ),
  //                 ),
  //               ),
  //               const SizedBox(height: 10),
  //               const Text(
  //                 'Up to 30% off\nselected items',
  //                 style: TextStyle(
  //                   color: Colors.white,
  //                   fontSize: 22,
  //                   fontWeight: FontWeight.w700,
  //                   height: 1.2,
  //                   letterSpacing: -0.3,
  //                 ),
  //               ),
  //               const SizedBox(height: 10),
  //               const Text(
  //                 'Shop the latest trends',
  //                 style: TextStyle(
  //                   color: Colors.white60,
  //                   fontSize: 12,
  //                   fontWeight: FontWeight.w400,
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildFeaturesSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Why Us?',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: const [
              Expanded(
                  child: _FeatureChip(
                      icon: Icons.local_shipping_outlined,
                      label: 'Fast Delivery')),
              SizedBox(width: 10),
              Expanded(
                  child: _FeatureChip(
                      icon: Icons.verified_outlined, label: 'Verified')),
              SizedBox(width: 10),
              Expanded(
                  child: _FeatureChip(
                      icon: Icons.lock_outlined, label: 'Secure Pay')),
            ],
          ),
        ],
      ),
    );
  }
}

class _NavCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final LinearGradient gradient;
  final VoidCallback onTap;

  const _NavCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.gradient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 150,
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: gradient.colors.first.withOpacity(0.35),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              right: -15,
              bottom: -15,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.08),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, color: Colors.white, size: 22),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.2,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 11,
                          height: 1.4,
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
}

class _FeatureChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _FeatureChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.accent, size: 22),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
          ),
        ],
      ),
    );
  }
}
