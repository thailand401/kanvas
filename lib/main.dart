import 'package:flutter/material.dart';
import 'package:kanvat/drawslider.dart';
import 'package:kanvat/dragarea.dart';
import 'package:kanvat/layout.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    return MaterialApp(
      title: 'Flutter Custom Painter',
      theme: new ThemeData(scaffoldBackgroundColor: const Color(0xFFEFEFEF)),
      home: MyLayout(),
    );
  }
}
