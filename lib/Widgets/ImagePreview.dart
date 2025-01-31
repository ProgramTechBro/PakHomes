import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Controller/Provider/ImageHandleProvider.dart';


class ImagePreview extends StatelessWidget {
  final int index;

  const ImagePreview({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.file(
            context.read<ImageHandlerProvider>().imageFiles[index],
            height: 150,
            width: 150,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          top: 5,
          right: 5,
          child: GestureDetector(
            onTap: () => context.read<ImageHandlerProvider>().removeImage(index),
            child: Container(
              color: Colors.black54,
              child: Icon(Icons.close, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
