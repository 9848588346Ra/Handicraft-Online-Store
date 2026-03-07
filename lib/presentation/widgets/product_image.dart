import 'dart:io';

import 'package:flutter/material.dart';

/// Displays a product image from either an asset path or a file path.
class ProductImage extends StatelessWidget {
  const ProductImage({
    super.key,
    required this.imagePath,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
  });

  final String imagePath;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = (width == null || width == double.infinity) ? constraints.maxWidth : width!;
        final h = (height == null || height == double.infinity) ? constraints.maxHeight : height!;
        final errorWidget = Container(
          width: w,
          height: h,
          color: Colors.grey.shade200,
          child: Icon(Icons.image_not_supported, color: Colors.grey.shade500),
        );
        Widget image;
        if (imagePath.startsWith('assets/')) {
          image = Image.asset(
            imagePath,
            width: w,
            height: h,
            fit: fit,
            errorBuilder: (_, __, ___) => errorWidget,
          );
        } else {
          try {
            final file = File(imagePath);
            if (file.existsSync()) {
              image = Image.file(
                file,
                width: w,
                height: h,
                fit: fit,
                errorBuilder: (_, __, ___) => errorWidget,
              );
            } else {
              image = errorWidget;
            }
          } catch (_) {
            image = errorWidget;
          }
        }
        if (borderRadius != null) {
          return ClipRRect(
            borderRadius: borderRadius!,
            child: image,
          );
        }
        return image;
      },
    );
  }
}
