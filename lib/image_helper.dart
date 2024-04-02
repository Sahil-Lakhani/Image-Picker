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
    SmartDialog.dismiss(status: SmartStatus.allAttach);

    var status = await Permission.photos.status;

    try {
      if (status.isDenied ) {
        status = await Permission.photos.request();
      }
      if (status.isPermanentlyDenied) {
        await SmartDialog.showToast(
          "Please enable photos storage permission in settings.",
        );
        Timer(const Duration(seconds: 3), SmartDialog.dismiss);
        return null;
      }

      final XFile? file = await _imagePicker.pickImage(
        source: source,
        imageQuality: imageQuality,
      );
  
      return file;
    } on PlatformException catch (e) {
      debugPrint(e.message.toString());
      await SmartDialog.showToast(
        "Please enable photos storage permission in settings.",
      );
      Timer(const Duration(seconds: 3), SmartDialog.dismiss);
    }
    return null;
  }

  Future<CroppedFile?> cropImage({
    required XFile file,
    required CropStyle cropStyle ,
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
