import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:softel/core/constant/color.dart';

class ProductCard extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String price;
  final bool isFavorite;
  final bool hasDiscount;
  final String discountText;
  final VoidCallback onAddToCart;
  final VoidCallback onFavorite;
  const ProductCard({
    super.key,
    required this.imageUrl,
    required this.name,
    required this.price,
    required this.isFavorite,
    required this.hasDiscount,
    required this.discountText,
    required this.onAddToCart,
    required this.onFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      elevation: 2,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: CachedNetworkImage(imageUrl: imageUrl, height: 90, width: double.infinity, fit: BoxFit.cover),
                    ),
                    if (hasDiscount)
                      Positioned(
                        top: 8,
                        left: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(color: AppColor.primaryColor, borderRadius: BorderRadius.circular(8)),
                          child: Text(
                            discountText,
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                        ),
                      ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: GestureDetector(
                        onTap: onFavorite,
                        child: Icon(isFavorite ? Icons.favorite : Icons.favorite_border, color: isFavorite ? Colors.red : Colors.grey),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                const SizedBox(height: 4),
                Text(
                  price,
                  style: const TextStyle(color: Colors.deepOrange, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Material(
                    color: AppColor.primaryColor,
                    shape: const CircleBorder(),
                    child: IconButton(
                      icon: const Icon(Icons.shopping_bag, color: Colors.white),
                      onPressed: onAddToCart,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
