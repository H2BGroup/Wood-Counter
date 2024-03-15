import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:woodcounter_application/calculations.dart';
import 'package:woodcounter_application/pages/result.dart';

class StackLength extends StatefulWidget {
  const StackLength({super.key, required this.image, required this.plateArea, required this.stackArea});

  final File image;
  final int plateArea;
  final int stackArea;

  @override
  State<StackLength> createState() => _StackLengthState();
}

class _StackLengthState extends State<StackLength> {

  final myController = TextEditingController();
  RegExp _numberRegex = RegExp(r'^\d*\.?\d*$');

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('WoodCounter', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.green,
        leading: Image.asset('assets/icons/stack.png'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Podaj długość stosu'),
            TextField(
              keyboardType: TextInputType.number,
              controller: myController,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(_numberRegex)
              ], 
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: '[Długość w metrach]',
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Cofnij')),
                ElevatedButton(
                    onPressed: () {
                      double stackVolume = calculateStackVolume(widget.stackArea, widget.plateArea, double.parse(myController.text));

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Result(image: widget.image, stackVolume: stackVolume,),
                        ),
                      );
                    },
                    child: const Text('Dalej')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
