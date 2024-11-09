// lThe CameraService will initialize the camera and capture an image. It will be injected into the Cubit to handle camera actions.
import 'package:camera/camera.dart';

// TODO: This class is currently un-implemented. Everything is ran within the camera_page.dart file
//       In the future I would like to adhere to clean arch inf and utilize these classes
class CameraService {
  late CameraController _controller;

  Future<void> initializeCamera(List<CameraDescription> cameras) async {
    _controller = CameraController(cameras[0], ResolutionPreset.max);
    await _controller.initialize();
  }

  CameraController get controller => _controller;

  Future<XFile> takePicture() async {
    return await _controller.takePicture();
  }

  void dispose() {
    _controller.dispose();
  }
}
