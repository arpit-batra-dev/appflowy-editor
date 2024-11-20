import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:photo_view/photo_view.dart';
import 'package:flutter/services.dart';

class ImagePreviewScreen extends StatefulWidget {
  final String imageUrl;

  const ImagePreviewScreen({Key? key, required this.imageUrl})
      : super(key: key);

  @override
  _ImagePreviewScreenState createState() => _ImagePreviewScreenState();
}

class _ImagePreviewScreenState extends State<ImagePreviewScreen> {
  Orientation _currentOrientation = Orientation.portrait;
  late PhotoViewController _photoViewController;

  @override
  void initState() {
    super.initState();
    _photoViewController = PhotoViewController();
  }

  @override
  Widget build(BuildContext context) {
    final bool isNetworkImage =
        Uri.tryParse(widget.imageUrl)?.hasAbsolutePath ?? false;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: SvgPicture.asset('assets/svg/search-zoom-in.svg'),
            onPressed: _zoomIn,
          ),
          IconButton(
            icon: SvgPicture.asset('assets/svg/search-zoom-out.svg'),
            onPressed: _zoomOut,
          ),
          IconButton(
            icon: SvgPicture.asset('assets/svg/refresh.svg'),
            onPressed: _rotateImage,
          ),
        ],
      ),
      body: Center(
        child: PhotoView(
          controller: _photoViewController,
          enableRotation: true,
          imageProvider: isNetworkImage
              ? CachedNetworkImageProvider(widget.imageUrl)
              : AssetImage(widget.imageUrl) as ImageProvider,
          minScale: PhotoViewComputedScale.contained,
          maxScale: PhotoViewComputedScale.covered * 2,
          backgroundDecoration: const BoxDecoration(
            color: Colors.black,
          ),
          heroAttributes: PhotoViewHeroAttributes(tag: widget.imageUrl),
        ),
      ),
    );
  }

  void _zoomIn() {
    _photoViewController.scale = (_photoViewController.scale ?? 1.0) * 1.2;
  }

  void _zoomOut() {
    _photoViewController.scale = (_photoViewController.scale ?? 1.0) / 1.2;
  }

  void _rotateImage() {
    setState(() {
      if (_currentOrientation == Orientation.portrait) {
        _currentOrientation = Orientation.landscape;
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeRight,
          DeviceOrientation.landscapeLeft,
        ]);
      } else {
        _currentOrientation = Orientation.portrait;
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ]);
      }
    });
  }

  @override
  void dispose() {
    // When the screen is disposed, reset the orientation to portrait
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }
}
