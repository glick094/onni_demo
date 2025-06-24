import 'package:flutter/material.dart';
import 'widgets/dashboard/circular_wedge_button.dart';

void main() {
  runApp(const TestApp());
}

class TestApp extends StatelessWidget {
  const TestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Circular Wedge Test',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const CircularWedgeLayoutTest(),
    );
  }
}