// image_view_page.dart

import 'dart:io';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Captured Image'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Image.file(imageFile), // TODO: we should alter this to directly go into crop mode
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _cropImage,
                  child: const Text("Apply Crop"),  // TODO: This should instead be the button that send this image to our backend for analysis
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Cancel"),  // TODO: Do we need to clean up anything here?
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // TODO: Can we alter crop UI to allow for me to crop from the center? Or just vertical crops
  Future _cropImage() async {
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
      }
    }
  }
}
