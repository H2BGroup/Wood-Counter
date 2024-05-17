import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:woodcounter_application/pages/home.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:woodcounter_application/pages/select_plate.dart';

var buttonStyle = TextStyle(foreground: Paint() ..color = backgroundColor, fontWeight: FontWeight.w900, fontSize: 18);

class SelectImage extends StatefulWidget {
  const SelectImage({super.key});

  @override
  State<SelectImage> createState() => _SelectImageState();
}

class _SelectImageState extends State<SelectImage> {
  File? _image;
  final ImagePicker _picker = ImagePicker();

  void _pickImage(ImageSource source) async {
    final XFile? result = await _picker.pickImage(source: source);

    if (result != null) {
      File file = File(result.path);
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
            Text(translation.appTitle, style: TextStyle(fontWeight: FontWeight.w900, foreground: Paint() ..color = Colors.white, letterSpacing: 1)),
        centerTitle: true,
        backgroundColor: backgroundColor,
        leading: Image.asset('assets/icons/stack.png'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(translation.pickPhoto,
            style: TextStyle(fontWeight: FontWeight.bold, foreground: Paint() ..color = Colors.white, fontSize: 22)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    onPressed: () => _pickImage(ImageSource.gallery), child: Text(translation.imageGalleryButton, style: buttonStyle)),
                ElevatedButton(onPressed: () => _pickImage(ImageSource.camera), child: Text(translation.takeAPhotoButton, style: buttonStyle)),
              ],
            ),
            if (_image != null) Image.file(_image!),
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
                    child: Text(translation.returnButton, style: buttonStyle)),
                ElevatedButton(
                    onPressed: _image != null ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SelectPlate(image: _image!),
                        ),
                      );
                    } : null,
                    child: Text(translation.nextButton, style: buttonStyle)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
