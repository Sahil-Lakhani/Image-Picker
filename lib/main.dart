import 'dart:io';

import 'package:custom_image_app/image_helper.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Image Selection Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const ProfileScreen(),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Picker & cropper'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(
          vertical: 80,
          horizontal: 20,
        ),
        children: const [ProfileImage(initials: 'ZS')],
      ),
    );
  }
}

final imageHelper = ImageHelper();

class ProfileImage extends StatefulWidget {
  const ProfileImage({super.key, required this.initials});
  final String initials;

  @override
  State<ProfileImage> createState() => _ProfileImageState();
}

class _ProfileImageState extends State<ProfileImage> {
  File? _image;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Center(
        child: _image != null
            ? Image.file(
                _image!,
                width: 228,
                height: 228,
                fit: BoxFit.cover,
              )
            : Container(
                width: 128,
                height: 128,
                color: Colors.grey[300],
                child: Center(
                  child: Text(
                    widget.initials,
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
      ),
      const SizedBox(height: 20),
      TextButton(
          onPressed: () async {
            final files = await imageHelper.pickImage();
            if (files.isNotEmpty) {
              final file = files.first;
              if (file != null) {
                final croppedFile = await imageHelper.cropImage(
                  file: file,
                  cropStyle: CropStyle.rectangle,
                );
                if (croppedFile != null) {
                  setState(() {
                    _image = File(croppedFile.path);
                  });
                }
              }
            }
          },
          child: const Text('Select Image '))
    ]);
  }
}
