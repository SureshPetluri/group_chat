import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

Future<Map<String, dynamic>> pickImageFromCameraOrGallery(
  BuildContext context,
  List<String> extensions,
) async {
  String base64Image = "";
  String image = "";

  if (!kIsWeb) {
    final picker = ImagePicker();
    String source = await showModalBottomSheet(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildPickerOption(context, 'Camera', Icons.camera_alt_rounded),
            _buildPickerOption(context, 'Gallery', Icons.image),
          ],
        ),
      ),
    );

    if (source.isNotEmpty) {
      XFile? pickedFile;
      if (source == 'Camera') {
        pickedFile = await picker.pickImage(
          source: ImageSource.camera,
          imageQuality: 50,
          maxHeight: 500,
          maxWidth: 500,
        );
      } else if (source == 'Gallery') {
        pickedFile = await picker.pickImage(source: ImageSource.gallery);
      }

      if (pickedFile != null) {
        Uint8List imageBytes = await pickedFile.readAsBytes();
        base64Image = base64Encode(imageBytes);
        image = pickedFile.name;
      }
    }
  } else {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: extensions,
    );

    if (result != null && result.files.isNotEmpty) {
      PlatformFile pickedFile = result.files.single;
      Uint8List imageBytes = pickedFile.bytes ?? Uint8List.fromList([]);
      base64Image = base64Encode(imageBytes);
      image = pickedFile.name;
    }
  }

  return {"base64Image": base64Image, "image": image};
}

Widget _buildPickerOption(BuildContext context, String label, IconData icon) {
  return InkWell(
    onTap: () => Navigator.pop(context, label),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 40),
        Text(label),
      ],
    ),
  );
}
