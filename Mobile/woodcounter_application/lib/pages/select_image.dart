import 'dart:io';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:woodcounter_application/pages/draw_border.dart';
import 'package:woodcounter_application/pages/home.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SelectImage extends StatefulWidget {
  const SelectImage({super.key});

  @override
  State<SelectImage> createState() => _SelectImageState();
}

class _SelectImageState extends State<SelectImage> {
  var _image;

  void _pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      File file = File(result.files.single.path!);
      setState(() {
        _image = file;
      });
    } else {
      // User canceled the picker
    }
  }

  @override
  Widget build(BuildContext context) {
    var translation = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title:
            Text(translation.appTitle, style: const TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.green,
        leading: Image.asset('assets/icons/stack.png'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    onPressed: _pickImage, child: Text(translation.imageGalleryButton)),
                ElevatedButton(onPressed: () {}, child: Text(translation.takeAPhotoButton)),
              ],
            ),
            if (_image != null) Image.file(_image),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomePage()),
                      );
                    },
                    child: Text(translation.returnButton)),
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DrawBorder(image: _image),
                        ),
                      );
                    },
                    child: Text(translation.nextButton)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
