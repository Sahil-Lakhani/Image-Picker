import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImageHelper {
  ImageHelper({
    ImagePicker? imagePicker,
    ImageCropper? imageCropper,
  })  : _imagePicker = imagePicker ?? ImagePicker(),
        _imageCropper = imageCropper ?? ImageCropper();

  final ImagePicker _imagePicker;
  final ImageCropper _imageCropper;

  Future <XFile?> pickImage({
    ImageSource source = ImageSource.gallery,
    int imageQuality = 100,
  }) async {
    final file = await _imagePicker.pickImage(source: source, imageQuality: imageQuality);
    if (file != null) {
      return file;
    } else {
      return null;
    }
  }

  Future<CroppedFile?> cropImage({
    required XFile file,
    CropStyle cropStyle = CropStyle.rectangle,
  })  =>  _imageCropper.cropImage(
    sourcePath: file.path,
    cropStyle: cropStyle,
  );
}
