// The CameraCubit is responsible for managing the state of the camera and handling user events, such as initializing the camera or taking a picture.
import 'package:auto_route/auto_route.dart';
import 'package:bloc/bloc.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
// TODO: Use relative project path?
import '../../../../router/app_router.gr.dart';
import '../../data/services/camera_service.dart';
import '../../domain/usecase/capture_photo.dart';

// TODO: This class is currently un-implemented. Everything is ran within the camera_page.dart file
//       In the future I would like to adhere to clean arch inf and utilize these classes
class CameraCubit extends Cubit<CameraController?> {
  final TakePictureUseCase takePictureUseCase;
  final CameraService cameraService;

  CameraCubit(this.takePictureUseCase, this.cameraService) : super(null);

  Future<void> initializeCamera(List<CameraDescription> cameras) async {
    await cameraService.initializeCamera(cameras);
    emit(cameraService.controller);
  }

  Future<void> captureImage(BuildContext context) async {
    final image = await takePictureUseCase.execute();

    // Use AutoRouter to navigate to ImageViewPage
    // if (!context.mounted) return; // TODO: Confirm this is a valid thing to do before impl....
    context.router.push(
      ImageViewRoute(imagePath: image.path), // Pass the image path as an argument
    );
  }

  @override
  Future<void> close() {
    cameraService.dispose();
    return super.close();
  }
}