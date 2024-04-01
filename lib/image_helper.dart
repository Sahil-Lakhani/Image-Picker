import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ImageHelper {
  late ImagePicker _imagePicker;
  late ImageCropper _imageCropper;

  ImageHelper() {
    _imagePicker = ImagePicker();
    _imageCropper = ImageCropper();
  }

  Future<XFile?> pickImage({
    ImageSource source = ImageSource.gallery,
    int imageQuality = 100,
  }) async {
    final XFile? file = await _imagePicker.pickImage(
      source: source,
      imageQuality: imageQuality,
    );
    return file;
  }

  Future<CroppedFile?> cropImage({
    required XFile file,
    CropStyle cropStyle = CropStyle.rectangle,
  }) async {
    try {
      final croppedFile = await _imageCropper.cropImage(
        sourcePath: file.path,
        cropStyle: cropStyle,
      );
      return croppedFile;
    } catch (e) {
      return null;
    }
  }
}
