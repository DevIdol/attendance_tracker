import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerWidget extends StatelessWidget {
  final File? imageFile;
  final ValueChanged<File?> onImageSelected;

  const ImagePickerWidget({
    super.key,
    required this.imageFile,
    required this.onImageSelected,
  });

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) onImageSelected(File(picked.path));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundImage: imageFile != null ? FileImage(imageFile!) : null,
          child: imageFile == null ? const Icon(Icons.person, size: 50) : null,
        ),
        TextButton(
          onPressed: _pickImage,
          child: const Text('Select Image'),
        ),
      ],
    );
  }
}
