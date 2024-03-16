import 'dart:io';

import 'package:flutter/material.dart';
import 'package:woodcounter_application/pages/select_plate.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DrawBorder extends StatefulWidget {
  const DrawBorder({super.key, required this.image});

  final File image;

  @override
  State<DrawBorder> createState() => _DrawBorderState();
}

class _DrawBorderState extends State<DrawBorder> {
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
            Text(translation.drawBorder),
            Image.file(widget.image),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(translation.returnButton)),
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              SelectPlate(image: widget.image),
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
