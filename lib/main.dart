import 'package:flutter/material.dart';
import 'package:labtest1/electricalcalculator.dart';

void main() {
  runApp(MaterialApp(
    title: 'Electrical Usage Calculator',
    theme: ThemeData(
      primarySwatch: Colors.blue,
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
    ),
    home: ElectricalCalc(),
  ));

}

