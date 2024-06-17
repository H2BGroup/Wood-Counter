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
      required this.points,
      required this.plateScale});

  final File image;
  final Offset platePosition;
  final Map<Offset, double> points;
  final double plateScale;

  @override
  State<StackLength> createState() => _StackLengthState();
}

class _StackLengthState extends State<StackLength> {
  final myController = TextEditingController();
  RegExp _numberRegex = RegExp(r'^\d*\.?\d*$');
  bool _isloading = false;
  bool _buttonEnable = false;

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
              style: TextStyle(fontWeight: FontWeight.w900, foreground: Paint() ..color = Colors.white, letterSpacing: 1)),
              centerTitle: true,
              backgroundColor: Color.fromARGB(255, 8, 130, 42),
              leading: Image.asset('assets/icons/stack.png'),
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(translation.giveLength,
                  style: TextStyle(fontWeight: FontWeight.bold, foreground: Paint() ..color = Colors.white, fontSize: 22)),
                  SizedBox(
                    width: 270.0,
                    child: 
                    TextField(
                    style: TextStyle(fontWeight: FontWeight.w500, foreground: Paint() ..color = Colors.white, fontSize: 15),
                    keyboardType: TextInputType.number,
                    controller: myController,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(_numberRegex)
                    ],
                    onChanged: (text) {
                      if (text.isNotEmpty) {
                        setState(() {
                          _buttonEnable = true;
                        });
                      } else {
                        _buttonEnable = false;
                      }
                    },
                    decoration: InputDecoration(
                      enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Color.fromARGB(255, 8, 67, 7), width: 4.0), borderRadius: BorderRadius.all(Radius.circular(15.0))),                   
                      hintText: translation.lengthInMeters,
                      hintStyle: TextStyle(fontWeight: FontWeight.w500, foreground: Paint() ..color = const Color.fromARGB(200, 255, 255, 255), fontSize: 15, fontStyle: FontStyle.italic),
                    ),
                  )
                  )
                  ,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(translation.returnButton, style: TextStyle(foreground: Paint() ..color = const Color.fromARGB(255, 8, 130, 42), fontWeight: FontWeight.w900, fontSize: 18))),
                      ElevatedButton(
                          onPressed: _buttonEnable == true
                              ? () async {
                                  setState(() {
                                    _isloading = true;
                                  });
                                  List<bool> plateMask = (await floodFill(
                                      widget.image,
                                      {widget.platePosition: 50}))!;
                                  List<bool> woodMask = (await floodFill(
                                      widget.image, widget.points))!;
                                  int plateArea = plateMask
                                      .where((object) => object == true)
                                      .length;
                                  int woodArea = woodMask
                                      .where((object) => object == true)
                                      .length;
                                  double stackVolume = calculateStackVolume(
                                      woodArea,
                                      plateArea,
                                      double.parse(myController.text),
                                      widget.plateScale);
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
                                }
                              : null,
                          child: Text(translation.nextButton, style: TextStyle(foreground: Paint() ..color = Color.fromARGB(255, 8, 130, 42), fontWeight: FontWeight.w900, fontSize: 18))),
                    ],
                  ),
                ],
              ),
            ),
          );
  }
}
