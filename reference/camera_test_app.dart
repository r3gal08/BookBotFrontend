// Reference: https://medium.com/@olasoji.od/flutter-widget-implementing-camera-feature-in-your-flutter-app-b083ebd74058

import 'dart:io';                       // Needed for working with files (to display the captured image from file storage)
import 'package:camera/camera.dart';    // Camera package to control the device's camera
import 'package:flutter/material.dart'; // Flutter Material package for UI components

void main() async {
  // Ensures that Flutter bindings are initialized before running the app
  // Note:  If your main() function only calls runApp(MyApp()); without additional asynchronous setup, you can omit "WidgetsFlutterBinding.ensureInitialized()"
  WidgetsFlutterBinding.ensureInitialized();

  // Fetches the list of available cameras on the device asynchronously
  final cameras = await availableCameras();

  // Runs the app with a Material design and sets the CameraApp widget as the home screen
  runApp(MaterialApp(home: CameraApp(cameras: cameras)));
}

// Stateful widget to control the camera and take pictures
class CameraApp extends StatefulWidget {
  final List<CameraDescription> cameras; // List of available cameras on the device

  const CameraApp({super.key, required this.cameras});

  @override
  State<CameraApp> createState() => _CameraAppState();
}

// Note: "_*" makes this class private
class _CameraAppState extends State<CameraApp> {
  // CameraController to manage camera operations like preview, capturing pictures
  late CameraController controller;

  // Variable to hold the captured image file after taking a picture
  XFile? imageFile;

  @override
  void initState() {
    super.initState();

    // Initializes the camera controller with the first camera in the list and high resolution
    controller = CameraController(widget.cameras[0], ResolutionPreset.max);

    // Begins the camera initialization and sets up the camera stream for preview
    controller.initialize().then((_) {
      if (!mounted) return; // Checks if the widget is still in the widget tree before calling setState

      setState(() {}); // Rebuilds the widget once the camera is initialized
    }).catchError((Object e) {
      // Error handling in case the camera fails to initialize
      if (e is CameraException) {
        // Checks for specific camera access issues
        switch (e.code) {
          case 'CameraAccessDenied':
          // TODO: Handle errors here
            print('Camera access was denied');
            break;
          default:
          // TODO: Handle errors here
            print('Unknown camera error: $e');
            break;
        }
      }
    });
  }

  @override
  void dispose() {
    // Releases the camera resources when this widget is removed from the widget tree
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Checks if the camera controller is initialized before showing the preview
    if (!controller.value.isInitialized) {
      return Container(); // Shows an empty container if the camera is not yet initialized
    }

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.deepBlue, // Uses the custom deep blue color from AppColors class
          leading: BackButton(
            color: Colors.white, // White color for the back button
            onPressed: () {
              Navigator.pop(context); // Navigates back to the previous screen
            },
          ),
          centerTitle: true, // Centers the title text
          title: Text(
            'Take a picture',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Stack(
          children: <Widget>[
            // Displays the live camera preview
            CameraPreview(controller),
            Align(
              alignment: Alignment.bottomCenter, // Positions the button at the bottom center of the screen
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16.0), // Adds space from the bottom of the screen
                child: FloatingActionButton(
                  onPressed: _takePicture, // Calls the _takePicture method to capture an image
                  backgroundColor: Colors.white,
                  foregroundColor: AppColors.deepBlue,
                  child: Icon(Icons.camera), // Camera icon for the button
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Note: Currently photos are temporarily stored in memory
  // TODO: Will this eventually lead to memory issues? Are we required to clean up?
  // Method to capture an image
  void _takePicture() async {
    try {
      // Uses the camera controller to capture an image and save it as an XFile object
      final XFile picture = await controller.takePicture();

      setState(() {
        imageFile = picture; // Updates the state with the captured image file
      });

      // Navigates to ImageViewPage to display the captured image
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ImageViewPage(imagePath: imageFile!.path),
        ),
      );
    } catch (e) {
      // Logs any errors encountered while trying to take the picture
      print("Error taking picture: $e");
    }
  }
}

// Custom color class to hold app-specific colors
class AppColors {
  static const Color deepBlue = Color(0xFF003366); // Defines a constant deep blue color
}

// Stateless widget to display the captured image
class ImageViewPage extends StatelessWidget {
  final String imagePath; // Path of the captured image to display

  const ImageViewPage({Key? key, required this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Captured Image', // Title of the screen
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.deepBlue, // Uses the same deep blue color for the app bar
      ),
      body: Center(
        child: imagePath.isNotEmpty
            ? Image.file(File(imagePath)) // Displays the image from file if the path is valid
            : Text('No image captured'), // Displays a message if the image path is empty
      ),
    );
  }
}
