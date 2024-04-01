import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';

class ImagePickerHelper {
  late ImagePicker _picker;

  ImagePickerHelper() {
    _picker = ImagePicker();
  }

  factory ImagePickerHelper.of(BuildContext context) => Provider.of(context);

  Future<List<XFile>> pickMultipleImages() async {
    SmartDialog.dismiss(status: SmartStatus.allAttach);

    var status = await Permission.photos.status;

    try {
      if (status.isDenied) {
        status = await Permission.photos.request();
      }

      if (status.isPermanentlyDenied) {
        await SmartDialog.showToast(
          "Please enable photos storage permission in settings.",
        );
        Timer(const Duration(seconds: 3), SmartDialog.dismiss);
        return [];
      }

      SmartDialog.showLoading(msg: 'Image Loading');
      final photos = await _picker.pickMultiImage(
        imageQuality: 75,
        requestFullMetadata: false,
      );
      await SmartDialog.dismiss(status: SmartStatus.loading);
      return photos;
    } on PlatformException catch (e) {
      debugPrint(e.message.toString());
      await SmartDialog.showToast(
        "Please enable photos storage permission in settings.",
      );
      Timer(const Duration(seconds: 3), SmartDialog.dismiss);
    }

    return [];
  }

  Future<XFile?> pickImage() async {
    SmartDialog.dismiss(status: SmartStatus.allAttach);

    var status = await Permission.photos.status;

    try {
      if (status.isDenied) {
        status = await Permission.photos.request();
      }

      if (status.isPermanentlyDenied) {
        await SmartDialog.showToast(
          "Please enable photos storage permission in settings.",
        );
        Timer(const Duration(seconds: 3), SmartDialog.dismiss);
        return null;
      }

      SmartDialog.showLoading(msg: 'Image Loading');
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 50,
        requestFullMetadata: false,
      );
      await SmartDialog.dismiss(status: SmartStatus.loading);
      return photo;
    } on PlatformException catch (e) {
      debugPrint(e.message.toString());
      await SmartDialog.showToast(
        "Please enable photos storage permission in settings.",
      );
      Timer(const Duration(seconds: 3), SmartDialog.dismiss);
    }

    return null;
  }

  /// Function to pick image from gallery and crop it
  /// - Returns: Future of `File?` as a result indicating cropped or non cropped image from gallery
  Future<File?> pickAndCrop(
      BuildContext context, XFile? xFile, bool? withCircleUi) async {
    xFile ??= await pickImage();

    if (xFile != null) {
      if (!xFile.path.contains('gif')) {
        final bytes = await xFile.readAsBytes();
        Uint8List image = Uint8List.fromList(bytes);

        await SmartDialog.dismiss();
        final croppedImage = await SmartDialog.show<dynamic>(
          builder: (context) {
            return Text('data');
          },
        );

        if (croppedImage is String && croppedImage.toString() == "None") {
          return null;
        }
        final imageBinaryData = croppedImage ?? image;
        if (imageBinaryData != null) {
          final tempDir = await getTemporaryDirectory();
          final file =
              "${tempDir.path}/image_${DateTime.now().toIso8601String()}";
          final imageFile = await File(file).writeAsBytes(imageBinaryData);
          return imageFile;
        }
      } else {
        return File(xFile.path);
      }
    }
    return null;
  }

  Future<XFile?> pickVideo() async {
    SmartDialog.dismiss(status: SmartStatus.allAttach);

    final permission =
        Platform.isIOS ? Permission.mediaLibrary : Permission.videos;
    var status = await permission.status;

    try {
      if (status.isDenied) {
        status = await permission.request();
      }

      if (status.isPermanentlyDenied) {
        await SmartDialog.showToast(
          "Please enable videos storage permission in settings.",
        );
        Timer(const Duration(seconds: 3), SmartDialog.dismiss);
        return null;
      }

      SmartDialog.showLoading(msg: 'Video Loading');
      final XFile? video = await _picker.pickVideo(
        source: ImageSource.gallery,
        maxDuration: const Duration(seconds: 1),
      );
      await SmartDialog.dismiss(status: SmartStatus.loading);
      return video;
    } on PlatformException catch (e) {
      debugPrint(e.message.toString());
      await SmartDialog.showToast(
        "Please enable video storage permission in settings.",
      );
      Timer(const Duration(seconds: 3), SmartDialog.dismiss);
    }

    return null;
  }

  Future<XFile?> clickImage() async {
    var status = await Permission.camera.status;
    try {
      if (status.isDenied) {
        status = await Permission.camera.request();
      }

      if (status.isPermanentlyDenied) {
        await SmartDialog.showToast(
          "Please enable camera permission in settings.",
        );
        Timer(const Duration(seconds: 3), SmartDialog.dismiss);

        return null;
      }

      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 88,
        requestFullMetadata: false,
      );
      return image;
    } on PlatformException catch (_) {
      await SmartDialog.showToast(
        "Please enable camera permission in settings.",
      );
      Timer(const Duration(seconds: 3), SmartDialog.dismiss);
    }

    return null;
  }
}
