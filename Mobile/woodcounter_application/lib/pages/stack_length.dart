import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:woodcounter_application/calculations.dart';
import 'package:woodcounter_application/pages/calculate_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:woodcounter_application/pages/result.dart';

class StackLength extends StatefulWidget {
  const StackLength(
      {super.key,
      required this.image,
      required this.platePosition,
      required this.points});

  final File image;
  final Offset platePosition;
  final Map<Offset, double> points;

  @override
  State<StackLength> createState() => _StackLengthState();
}

class _StackLengthState extends State<StackLength> {
  final myController = TextEditingController();
  RegExp _numberRegex = RegExp(r'^\d*\.?\d*$');
  bool _isloading = false;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var translation = AppLocalizations.of(context)!;
    return _isloading
        ? const CalculateScreen()
        : Scaffold(
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
                  Text(translation.giveLength),
                  TextField(
                    keyboardType: TextInputType.number,
                    controller: myController,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(_numberRegex)
                    ],
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: translation.lengthInMeters,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(translation.returnButton)),
                      ElevatedButton(
                          onPressed: () async {
                            setState(() {
                              _isloading = true;
                            });
                            List<bool> plateMask = (await floodFill(
                                widget.image, {widget.platePosition: 50}))!;
                            List<bool> woodMask =
                                (await floodFill(widget.image, widget.points))!;
                            int plateArea = plateMask
                                .where((object) => object == true)
                                .length;
                            int woodArea = woodMask
                                .where((object) => object == true)
                                .length;
                            double stackVolume = calculateStackVolume(woodArea,
                                plateArea, double.parse(myController.text));
                            double error = calculateError(plateArea);
                            setState(() {
                              _isloading = false;
                            });
                            print(plateArea);
                            print(woodArea);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Result(
                                    image: widget.image,
                                    stackVolume: stackVolume,
                                    error: error),
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
