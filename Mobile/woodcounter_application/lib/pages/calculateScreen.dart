import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:woodcounter_application/calculations.dart';
import 'package:woodcounter_application/pages/result.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CalculateScreen extends StatefulWidget {
  const CalculateScreen({super.key});

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
            const SpinKitPouringHourGlass(
              color: Colors.white,
              size: 100,
            ),
            Text(translation.calculating),
          ],
        ),
      ),
    );
  }
}
