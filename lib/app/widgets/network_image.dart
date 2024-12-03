import 'package:flutter/material.dart';

Widget networkImage({
  required String imageUrl,
  double? height,
  double? width,
  BoxFit? fit,
  double scale = 1,
  Color? color,
}) {
  return imageUrl.contains("asset")
      ? Image.asset(
          imageUrl,
          height: height,
          width: width,
          fit: fit,
          color: color,
          scale: scale,
          errorBuilder: (context, error, stackTrace) {
            // Show the placeholder image on error
            return Image.asset(
              'asset/images/placeholder-image.png', // Fallback image for errors
              height: height,
              width: width,
              fit: fit,
              color: color,
            );
          },
        )
      : Image.network(
           imageUrl,
          height: height,
          width: width,
          fit: fit,
          color: color,
          scale: scale,
          /*placeholder: (BuildContext context, _) => Center(
            child: Image.asset(
              'asset/images/google.png', // Loading placeholder image
              height: height,
              width: width,
              fit: fit,
              color: color,
            ),
          ),*/
          errorBuilder: (context, error, stackTrace) {
            // Show the placeholder image on error
            return Image.asset(
              'asset/images/placeholder-image.png', // Fallback image for errors
              height: height,
              width: width,
              fit: fit,
              color: color,
            );
          },
        );
}
