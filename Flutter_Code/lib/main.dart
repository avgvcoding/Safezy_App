// lib/main.dart

import 'package:flutter/material.dart';
import 'splash_screen.dart';

void main() {
  runApp(DisasterPredictorApp());
}

class DisasterPredictorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Disaster Predictor App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
