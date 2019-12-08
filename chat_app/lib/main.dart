import 'package:flutter/material.dart';

import './screens/home_screen.dart';

void main() => runApp(ChatApp());

class ChatApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.teal,
        primaryColor: Colors.teal[800],
        accentColor: Colors.lightGreen,
        errorColor: Colors.red,
        appBarTheme: AppBarTheme(
          color: Colors.teal[800],
        ),
      ),
      initialRoute: HomeScreen.routeName,
      onUnknownRoute: (settings) {
        return MaterialPageRoute(builder: (ctx) => HomeScreen());
      },
      debugShowCheckedModeBanner: false,

      home: HomeScreen(),
    );
  }
}
