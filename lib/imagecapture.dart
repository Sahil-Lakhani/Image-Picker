import 'dart:io';

import 'package:custom_image_app/image_helper.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImageCapture extends StatefulWidget {
  const ImageCapture({super.key});

  @override
  createState() => _ImageCaptureState();
}

class _ImageCaptureState extends State<ImageCapture> {
  final ImageHelper _imageHelper = ImageHelper();
  XFile? _imageFile;

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _imageHelper.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _imageFile = pickedFile;
      });
    }
  }

  Future<void> _cropImage() async {
    if (_imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a picture first.'),
        ),
      );
      return;
    }

    final croppedFile = await _imageHelper.cropImage(
      file: _imageFile!,
      cropStyle: CropStyle.circle,
    );

    if (croppedFile != null) {
      setState(() {
        _imageFile = XFile(croppedFile.path);
      });
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cropped image not selected. Showing original image.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Capture'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _imageFile == null
                ? const Text('No image selected.')
                : ClipOval(
                    child: Image.file(
                      File(_imageFile!.path),
                      width: 200,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ),

            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _cropImage,
              child: const Text('Edit Image'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconButton(
              onPressed: () => _pickImage(ImageSource.camera),
              icon: const Icon(Icons.camera),
            ),
            IconButton(
              onPressed: () => _pickImage(ImageSource.gallery),
              icon: const Icon(Icons.photo_library),
            ),
          ],
        ),
      ),
    );
  }
}
