// ignore: file_names
import 'dart:io';

import 'package:custom_image_app/image_helper.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';

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
        children: const [
          ProfileImage(initials: 'ZS'),
          // MultipleImages(),
        ],
      ),
    );
  }
}

final ImageHelper imageHelper = ImageHelper();

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
    return Column(
      children: [
        Center(
          child: CircleAvatar(
            radius: 114, // Half of 228
            backgroundColor: Colors.grey,
            child: _image != null
                ? ClipOval(
                    child: Image.file(
                      _image!,
                      width: 228,
                      height: 228,
                      fit: BoxFit.cover,
                    ),
                  )
                : Container(
                    width: 228,
                    height: 228,
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
        ),
        const SizedBox(height: 20),
        TextButton(
          onPressed: () async {
            final files = await imageHelper.pickImage();
            if (files != null) {
              final file = files;

              final croppedFile = await imageHelper.cropImage(
                file: file,
                cropStyle: CropStyle.circle,
              );
              if (croppedFile != null) {
                setState(() {
                  _image = File(croppedFile.path);
                });
              }
            }
          },
          child: const Text('Select Image'),
        ),
      ],
    );
  }
}
