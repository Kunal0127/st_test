
import 'package:camera/camera.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CameraCubit extends Cubit<CameraController?> {
  CameraCubit() : super(null);

  Future<void> initializeCamera() async {
    final cameras = await availableCameras();
    final frontCamera = cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.front,
    );

    final controller = CameraController(frontCamera, ResolutionPreset.high);
    await controller.initialize();
    emit(controller);
  }

  @override
  Future<void> close() {
    state?.dispose();
    return super.close();
  }
}
