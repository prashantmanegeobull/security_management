import 'package:image_picker/image_picker.dart';

class SelfieService {
  final ImagePicker _picker = ImagePicker();

  Future<XFile?> captureSelfie() async {
    return await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 70,
      preferredCameraDevice:
      CameraDevice.front,
    );
  }
}