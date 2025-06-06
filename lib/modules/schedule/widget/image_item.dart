import 'package:flutter/material.dart';

class ImageItem extends StatelessWidget {
  final String url;
  final bool isSelected;
  final VoidCallback onTap;

  const ImageItem({
    required this.url,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? primaryColor : Colors.transparent,
            width: isSelected ? 3 : 0,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(9),
          child: Image.network(url, fit: BoxFit.cover, width: 150, height: 100),
        ),
      ),
    );
  }
}