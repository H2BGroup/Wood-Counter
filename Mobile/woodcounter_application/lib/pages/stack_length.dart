import 'dart:io';

import 'package:flutter/material.dart';
import 'package:woodcounter_application/pages/result.dart';
import 'package:woodcounter_application/pages/threshold.dart';


class StackLength extends StatefulWidget {
  const StackLength({super.key});

  @override
  State<StackLength> createState() => _StackLengthState();
}

class _StackLengthState extends State<StackLength> {
  @override
  Widget build(BuildContext context) {
    final image = ModalRoute.of(context)!.settings.arguments as File;

    return Scaffold(
      appBar: AppBar(
        title:
            Text('WoodCounter', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.green,
        leading: Image.asset('assets/icons/stack.png'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Podaj długość stosu'),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: '[Długość w metrach]',
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SetThreshold(),
                          settings: RouteSettings(
                            arguments: image,
                          ),
                        ),
                      );
                    },
                    child: Text('Cofnij')),
                ElevatedButton(onPressed: () {
                  Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Result(),
                          settings: RouteSettings(
                            arguments: image,
                          ),
                        ),
                      );
                }, child: Text('Dalej')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
