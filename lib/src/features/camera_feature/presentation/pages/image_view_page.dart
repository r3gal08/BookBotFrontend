// image_view_page.dart

import 'dart:convert';
import 'dart:io';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:http/http.dart' as http;

@RoutePage()
class ImageViewPage extends StatefulWidget {
  final String imagePath;

  const ImageViewPage({Key? key, required this.imagePath}) : super(key: key);

  @override
  _ImageViewPageState createState() => _ImageViewPageState();
}

class _ImageViewPageState extends State<ImageViewPage> {
  late File imageFile;

  @override
  void initState() {
    super.initState();
    imageFile = File(widget.imagePath);

    // Automatically invoke the crop method when the page is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _cropImage();
    });
  }

  // TODO: Re-implement image file check. Ex:
  // return Scaffold(
  // appBar: AppBar(
  // title: Text('Captured Image'),
  // ),
  // body: Center(
  // child: imagePath.isNotEmpty
  // ? Image.file(File(imagePath))
  //     : Text('No image captured'),
  // ),
  // );

  // TODO: could be smoother with how this transition is happening. Currently you see the "send" button along with the image file for a split second before moving int the cropping functionality
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crop Image'),
      ),
      body: Center(
        child: imageFile.existsSync()
            ? Image.file(imageFile)
            : const Text('No image available'),
      ),
      floatingActionButton: ElevatedButton(
        onPressed: () async {
          // Example: Upload image to backend or perform another action
          await sendImageToBackend(imageFile);
          Navigator.pop(context);
        },
        child: const Text("Send"),
      ),
    );
  }

  // TODO: Can we alter crop UI to allow for me to crop from the center? Or just vertical crops
  Future<void> _cropImage() async {
    // TODO: Implement aspect ratio settings for IOS and web?
    // TODO: Is it always null though? Safe to have this here I suppose, but if I implement my previous todos on camera page this will always be not null
    if (imageFile != null) {
      CroppedFile? cropped = await ImageCropper().cropImage(
          sourcePath: imageFile.path,
          uiSettings: [
            AndroidUiSettings(
              toolbarTitle: 'Cropper',
              cropGridColor: Colors.black,
              toolbarColor: Colors.deepOrange,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false,
              aspectRatioPresets: [
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.original,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio16x9
              ],
            ),
            IOSUiSettings(title: 'Crop')
          ]);

      // Update image file variable with setState()
      if (cropped != null) {
        setState(() {
          imageFile = File(cropped.path);
        });
      } else {
        // If cropping is canceled, navigate back or show a message
        Navigator.pop(context);
      }
    }
  }

  // Function to send the image to the backend
  Future<void> sendImageToBackend(File imageFile) async {
    final bytes = await imageFile.readAsBytes();

    final response = await http.post(
      Uri.parse('http://<placeholder>:<placeholder>/upload'),  // TODO: Export to variable/settings file
      headers: {
        'Content-Type': 'application/json',  // Sending JSON data
      },
      body: jsonEncode({
        'image': base64Encode(bytes),  // Base64 encode the image bytes
      }),
    );

    if (response.statusCode == 200) {
      print('Image uploaded successfully!');
    } else {
      print('Failed to upload image.');
    }
  }
}
