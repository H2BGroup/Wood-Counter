import 'dart:io';
import 'dart:ui' as ui;
import 'package:image/image.dart' as img;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:woodcounter_application/calculations.dart';
import 'package:woodcounter_application/pages/result.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:woodcounter_application/queuelinear_floodfiller.dart';

class CalculateScreen extends StatefulWidget {
  const CalculateScreen(
      {super.key,
      required this.image,
      required this.platePosition,
      required this.woodPosition,
      required this.threshold,
      required this.stackLenght});

  final File image;
  final Offset platePosition;
  final Offset woodPosition;
  final double threshold;
  final double stackLenght;

  @override
  State<CalculateScreen> createState() => _CalculateScreenState();
}

class _CalculateScreenState extends State<CalculateScreen> {
  @override
  Widget build(BuildContext context) {
    var translation = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(translation.appTitle,
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.green,
        leading: Image.asset('assets/icons/stack.png'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Obliczanie"),
            ElevatedButton(
                onPressed: () async {
                  int plateArea = (await floodFillCountPixels(widget.image, widget.platePosition, 50))!;
                  int woodArea = (await floodFillCountPixels(widget.image, widget.woodPosition, widget.threshold))!;
                  double stackVolume = calculateStackVolume(woodArea, plateArea, widget.stackLenght);
                  print(plateArea);
                  print(woodArea);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Result(
                        image: widget.image,
                        stackVolume: stackVolume,
                      ),
                    ),
                  );
                },
                child: Text("Oblicz")),
          ],
        ),
      ),
    );
  }
}
