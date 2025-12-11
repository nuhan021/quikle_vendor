import 'package:flutter/material.dart';

/// A simple widget that displays an image from URL with fallback to asset image
class NetworkImageWithFallback extends StatefulWidget {
  final String imageUrl;
  final String fallback;
  final BoxFit fit;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;

  const NetworkImageWithFallback(
    this.imageUrl, {
    required this.fallback,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.borderRadius,
    Key? key,
  }) : super(key: key);

  @override
  State<NetworkImageWithFallback> createState() =>
      _NetworkImageWithFallbackState();
}

class _NetworkImageWithFallbackState extends State<NetworkImageWithFallback> {
  late ImageProvider<Object> _imageProvider;
  bool _loadFailed = false;

  @override
  void initState() {
    super.initState();
    _imageProvider = NetworkImage(widget.imageUrl);
  }

  @override
  Widget build(BuildContext context) {
    if (_loadFailed) {
      return _buildAssetImage();
    }

    return Image(
      image: _imageProvider,
      fit: widget.fit,
      width: widget.width,
      height: widget.height,
      errorBuilder: (context, error, stackTrace) {
        _loadFailed = true;
        return _buildAssetImage();
      },
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Container(
          width: widget.width,
          height: widget.height,
          color: Colors.grey[300],
          child: const Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  Widget _buildAssetImage() {
    return Image.asset(
      widget.fallback,
      fit: widget.fit,
      width: widget.width,
      height: widget.height,
    );
  }
}
