import 'package:flutter/material.dart';
import 'package:ra_teste/views/home_page.dart';

void main() {
  runApp(const FlutterRA());  
}
class FlutterRA extends StatelessWidget {
  const FlutterRA({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AR Assets 3D',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: HomePage(),
    );
  }
}

