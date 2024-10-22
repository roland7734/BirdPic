import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';

class ImagePreviewPage extends StatefulWidget {
  final CroppedFile image;

  const ImagePreviewPage({super.key, required this.image});

  @override
  _ImagePreviewPageState createState() => _ImagePreviewPageState();
}

class _ImagePreviewPageState extends State<ImagePreviewPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Image Preview"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: InteractiveViewer(
              child: Image(
            image: FileImage(
              File(widget.image.path),
            ),
          )),
        ),
      ),
    );
  }
}
