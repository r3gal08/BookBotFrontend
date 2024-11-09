// The domain layer holds the business logic. Here, capture_photo usecase interacts with CameraService to capture an image.
import 'package:camera/camera.dart';
// TODO: import packages relative to project source
import '../../data/services/camera_service.dart';

// TODO: This class is currently un-implemented. Everything is ran within the camera_page.dart file
//       In the future I would like to adhere to clean arch inf and utilize these classes
class TakePictureUseCase {
  final CameraService cameraService;

  TakePictureUseCase(this.cameraService);

  Future<XFile> execute() async {
    return await cameraService.takePicture();
  }
}
