// The ImageViewPage displays the captured image using the file path.
import 'dart:io';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

// TODO: I suppose we basically add some functionality here to then send this image in base64 encoding to the backend
//       This would be in the form of a button.... Which then would return us to the chat page
//       We can also decide to do the cropping of the image here or offload to the backend
@RoutePage()
class ImageViewPage extends StatelessWidget {
  final String imagePath;

  //   const ImageViewPage({Key? key, required this.imagePath}) : super(key: key); // Original but looks wrong
  const ImageViewPage({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Captured Image'),
      ),
      body: Center(
        child: imagePath.isNotEmpty
            ? Image.file(File(imagePath))
            : Text('No image captured'),
      ),
    );
  }
}
