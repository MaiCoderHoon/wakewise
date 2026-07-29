import 'package:flutter/material.dart';

void main() {
  runApp(const WakewiseApp());
}

class WakewiseApp extends StatelessWidget{
  const WakewiseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'WakeWise',
      home: Scaffold(
        body: Center(
          child: Text('WakeWise'),
        ),
      ),
    );
  }
}