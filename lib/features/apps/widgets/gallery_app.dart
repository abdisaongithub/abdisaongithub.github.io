import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class GalleryApp extends StatelessWidget {
  final List<String> images;
  final String title;

  const GalleryApp({
    super.key,
    required this.images,
    this.title = 'Photos',
  });

  @override
  Widget build(BuildContext context) {
    if (images.isEmpty) {
      return const Scaffold(
        body: Center(child: Text("No images available for this project.")),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(title, style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.grey[900],
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: PageView.builder(
        itemCount: images.length,
        itemBuilder: (context, index) {
          final path = images[index];
          return InteractiveViewer(
            child: Center(
              child: path.startsWith('http')
                  ? CachedNetworkImage(
                      imageUrl: path,
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error, color: Colors.white),
                    )
                  : Image.asset(
                      path,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.broken_image, color: Colors.white),
                    ),
            ),
          );
        },
      ),
    );
  }
}
