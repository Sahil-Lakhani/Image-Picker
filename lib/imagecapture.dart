import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImageCapture extends StatefulWidget {
  const ImageCapture({super.key});

  @override
  createState() => _ImageCaptureState();
}

class _ImageCaptureState extends State<ImageCapture> {
  XFile? _imageFile;

  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _imageFile = pickedFile;
      });
    }

    void _clear() {
      setState(() {
        _imageFile = null;
      });
    }
  }

  Future<void> _cropImage() async {
    final ImageCropper cropper = ImageCropper();
    final croppedFile = await cropper.cropImage(
      sourcePath: _imageFile!.path,
    );
    setState(() {
      _imageFile = XFile(croppedFile!.path);
    });
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
      ),
    );
  }
}
