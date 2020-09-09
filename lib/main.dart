import 'package:flutter/material.dart';

import 'package:weather_app/screens/loading_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: Color(0xFFE5F0FC),
        primaryColor: Color(0xFFE5F0FC),
        iconTheme: IconThemeData(
            color: Colors.blueGrey.shade700, size: 30, opacity: 1.0),
        textTheme: TextTheme(
          bodyText2: TextStyle(color: Colors.black87, fontSize: 16),
        ),
      ),
      home: LoadingScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
