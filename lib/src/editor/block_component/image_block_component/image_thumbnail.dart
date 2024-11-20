import 'package:appflowy_editor/src/editor/block_component/image_block_component/image_preview_screen.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ImageThumbnail extends StatelessWidget {
  final String imageUrl;
  final double aspectRatio;
  static const String _placeholderAsset = 'assets/topic/placeholder.png';

  const ImageThumbnail({
    Key? key,
    required this.imageUrl,
    this.aspectRatio = 16 / 9, // Default aspect ratio if not specified
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double imageHeight = MediaQuery.of(context).size.height * 0.35;

    return GestureDetector(
      onTap: () => _openImagePreview(context),
      child: _buildImageWidget(imageHeight),
    );
  }

  // Determines whether the imageUrl is a network URL or an asset
  Widget _buildImageWidget(double imageHeight) {
    final bool isNetworkImage =
        Uri.tryParse(imageUrl)?.hasAbsolutePath ?? false;

    return isNetworkImage
        ? CachedNetworkImage(
            imageUrl: imageUrl,
            placeholder: (context, url) => Image.asset(_placeholderAsset),
            errorWidget: (context, url, error) =>
                Image.asset(_placeholderAsset),
            fit: BoxFit.contain,
            // height: imageHeight,
          )
        : Image.asset(
            imageUrl, // In this case, the imageUrl is a local asset path
            fit: BoxFit.contain,
            // width: double.infinity,
            // height: imageHeight,
          );
  }

  void _openImagePreview(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ImagePreviewScreen(imageUrl: imageUrl),
      ),
    );
  }
}
