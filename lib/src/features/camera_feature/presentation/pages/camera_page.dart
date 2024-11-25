// Reference: https://medium.com/@olasoji.od/flutter-widget-implementing-camera-feature-in-your-flutter-app-b083ebd74058

// The CameraPage handles the UI for displaying the camera preview and taking pictures.
// Currently camera_page also performs data and domain functionality but I plan to update this in the future...
// That is, everything within the camera functionality is contained to camera_page and image_view_page, at this time
import 'package:auto_route/auto_route.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:ollama_flutter_app/src/router/app_router.gr.dart';
//import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class CameraPage extends StatefulWidget {
  final List<CameraDescription> cameras;
  const CameraPage({super.key, required this.cameras});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

// Note: "_" makes the class private :)
class _CameraPageState extends State<CameraPage> {
  // CameraController to manage camera operations like preview, capturing pictures
  late CameraController controller;

  // Variable to hold the captured image file after taking a picture
  XFile? imageFile;

  @override
  void initState() {
    super.initState();

    // Initializes the camera controller with the first camera in the list and high resolution
    // TODO: We are currently just selecting whatever the first camera is, likely should be an option in the settings or at the very least
    //      some additional logic for selecting the camera that one would expect (IE: Expected lense, front, rear, etc...)
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
            // TODO: Handle errors here - print in production bad
            print('Camera access was denied');
            break;
          default:
            // TODO: Handle errors here - print in production bad
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

      // TODO: Handle potential null pointer exception
      // Navigates to ImageViewPage to display the captured image
      // ! == null assertion operator. Which tells dart that this value is not null at this point.
      //    this of course runs the risk of causing a null pointer exception, and therfore we should handle this....
      // if (!context.mounted) return; // TODO: Confirm this is a valid thing to do before impl....
      context.router.push(ImageViewRoute(imagePath: imageFile!.path));
    } catch (e) {
      // Logs any errors encountered while trying to take the picture
      print("Error taking picture: $e");
    }
  }
}

// TODO: Create a global presentation class for things like this, or look at a better way for pulling colors.
class AppColors {
  static const Color deepBlue = Color(0xFF003366); // Defines a constant deep blue color
}