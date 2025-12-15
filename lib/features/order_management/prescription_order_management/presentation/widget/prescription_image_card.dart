import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quikle_vendor/core/utils/constants/icon_path.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';

class PrescriptionImageCard extends StatelessWidget {
  final String? imagePath;

  const PrescriptionImageCard({super.key, this.imagePath});

  void _openImageViewer(BuildContext context, String? imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty) {
      return;
    }
    final imageProvider = Image.network(imageUrl).image;
    showImageViewer(
      context,
      imageProvider,
      onViewerDismissed: () {},
      doubleTapZoomable: true,
      swipeDismissible: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: AspectRatio(aspectRatio: 3 / 4, child: _buildImage(context)),
    );
  }

  Widget _buildImage(BuildContext context) {
    if (imagePath == null || imagePath!.isEmpty) {
      return Container(
        color: Colors.grey[200],
        child: Center(
          child: Image.asset(
            IconPath.logo,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Colors.grey[300],
                child: Center(
                  child: Text(
                    'Image not available',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),
              );
            },
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: () => _openImageViewer(context, imagePath),
      child: Image.network(
        imagePath!,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Colors.grey[200],
            child: Center(
              child: Image.asset(
                IconPath.logo,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[300],
                    child: Center(
                      child: Text(
                        'Image not available',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                  : null,
            ),
          );
        },
      ),
    );
  }
}
