// TODO: Honestly would prefer for this to be named camera_services.dart and refactor that old name to be picture_service.dart of something similar

import 'package:camera/camera.dart';

class GetCamerasService {
  List<CameraDescription> _cameras = [];

  List<CameraDescription> get cameras => _cameras;

  // Initialize the camera service by fetching available cameras
  Future<void> initialize() async {
    try {
      _cameras = await availableCameras();
    } catch (e) {
      print('Error initializing cameras: $e');  // TODO: Do not invoke 'print' in production code
      _cameras = []; // Set to empty if there's an error
    }
  }

  bool get hasCameras => _cameras.isNotEmpty;
}
