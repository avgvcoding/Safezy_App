// lib/splash_screen.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'home_screen.dart'; // Import the HomeScreen

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Start a timer of 3 seconds and navigate to HomeScreen after that
    Timer(Duration(seconds: 2), () {
      // Navigate to HomeScreen and remove SplashScreen from the stack
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => DisasterPredictorHomePage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // You can choose any background color
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Display the logo
            Image.asset(
              'assets/logo.png',
              width: 200, // Adjust the size as needed
              height: 200,
            ),
            SizedBox(height: 30),
            // App Name
            Text(
              'Safezy App',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.blue, // Choose a color that fits your theme
              ),
            ),
            SizedBox(height: 10),
            // Tagline
            Text(
              'Safeguarding You Against Disasters',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700], // A subtle color for the tagline
              ),
            ),
          ],
        ),
      ),
    );
  }
}
