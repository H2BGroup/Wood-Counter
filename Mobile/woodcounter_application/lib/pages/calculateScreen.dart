import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:woodcounter_application/calculations.dart';
import 'package:woodcounter_application/pages/result.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CalculateScreen extends StatefulWidget {
  const CalculateScreen(
      {super.key,
      required this.image,
      required this.platePosition,
      required this.points,
      required this.stackLenght});

  final File image;
  final Offset platePosition;
  final Map<Offset, double> points;
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
            Text(translation.calculating),
            ElevatedButton(
                onPressed: () async {
                  List<bool> plateMask = (await floodFill(widget.image, {widget.platePosition: 50}))!;
                  List<bool> woodMask = (await floodFill(widget.image, widget.points))!;
                  int plateArea = plateMask.where((object) => object == true).length;
                  int woodArea = woodMask.where((object) => object == true).length;
                  double stackVolume = calculateStackVolume(woodArea, plateArea, widget.stackLenght);
                  double error = calculateError(plateArea);
                  print(plateArea);
                  print(woodArea);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Result(
                        image: widget.image,
                        stackVolume: stackVolume,
                        error: error
                      ),
                    ),
                  );
                },
                child: Text(translation.calculate)),
          ],
        ),
      ),
    );
  }
}
