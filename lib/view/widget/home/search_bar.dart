import 'package:flutter/material.dart';
import 'package:softel/core/constant/color.dart';

class SearchBar extends StatelessWidget {
  final String hintText;
  final ValueChanged<String>? onSearch;
  final VoidCallback? onFilter;
  const SearchBar({super.key, required this.hintText, this.onSearch, this.onFilter});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              onChanged: onSearch,
              decoration: InputDecoration(
                hintText: hintText,
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: Colors.grey[100],
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Material(
            color: Colors.white,
            shape: const CircleBorder(),
            elevation: 2,
            child: IconButton(
              icon:  Icon(Icons.tune, color: AppColor.primaryColor),
              onPressed: onFilter,
            ),
          ),
        ],
      ),
    );
  }
}
