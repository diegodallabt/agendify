import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ImageItem extends StatelessWidget {
  final String url;
  final bool isSelected;
  final VoidCallback onTap;
  final double width;
  final double height;
  final double borderRadius;
  final double clipRadius;
  final double horizontalMargin;

  const ImageItem({
    super.key,
    required this.url,
    required this.isSelected,
    required this.onTap,
    this.width = 150,
    this.height = 100,
    this.borderRadius = 12,
    this.clipRadius = 9,
    this.horizontalMargin = 4,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: horizontalMargin),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? primaryColor : Colors.transparent,
            width: isSelected ? 3 : 0,
          ),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(clipRadius),
          child: Image.network(
            url,
            fit: BoxFit.cover,
            width: width,
            height: height,
            frameBuilder: (context, child, frame, wasSync) {
              if (wasSync || frame != null) {
                return child;
              }
              return Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Container(
                  width: width,
                  height: height,
                  color: Colors.grey.shade300,
                ),
              );
            },
            errorBuilder: (context, error, stack) {
              return Container(
                width: width,
                height: height,
                color: Colors.grey.shade300,
                alignment: Alignment.center,
                child: const Icon(Icons.broken_image, color: Colors.grey),
              );
            },
          ),
        ),
      ),
    );
  }
}
