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

final ImageHelper imageHelper = ImageHelper();

class _ImageCaptureState extends State<ImageCapture> {
  XFile? _imageFile;

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await imageHelper.pickImage(source: source);
    setState(() {
      _imageFile = pickedFile;
    });
  }

  Future<void> _cropImage() async {
    if (_imageFile == null) {
      // Prompt user to select a picture if _imageFile is null
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a picture first.'),
        ),
      );
      return;
    }
    final croppedFile = await imageHelper.cropImage(
      file: _imageFile!,
      cropStyle: CropStyle.rectangle,
    );
    if (croppedFile != null) {
      setState(() {
        _imageFile = XFile(croppedFile.path);
      });
    } else {
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
                : Image.file(
                    File(_imageFile!.path),
                    height: 400,
                  ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _cropImage(),
              child: const Text('Crop Image'),
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
        // Uploader(file: _imageFile)
      ),
    );
  }
}

class Uploader extends StatefulWidget {
  const Uploader({super.key});

  @override
  State<Uploader> createState() => _UploaderState();
}

class _UploaderState extends State<Uploader> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
