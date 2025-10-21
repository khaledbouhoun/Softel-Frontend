import 'package:flutter/material.dart';
import 'package:softel/core/constant/color.dart';

class PromoBanner extends StatelessWidget {
  final String text;
  final String buttonText;
  final VoidCallback onButtonPressed;
  final String imageAsset;
  const PromoBanner({super.key, required this.text, required this.buttonText, required this.onButtonPressed, required this.imageAsset});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      height: 180,
      decoration: BoxDecoration(color: AppColor.primaryColor.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  text,
                  style:  TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColor.primaryColor),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: onButtonPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                  ),
                  child: Text(buttonText),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(imageAsset, height: 90, width: 90, fit: BoxFit.cover),
          ),
        ],
      ),
    );
  }
}
