import 'package:chat_app/provider/curr_screen_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/home_screen.dart';

void main() => runApp(ChatApp());

class ChatApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => CurrScreenProvider(),
      child: MaterialApp(
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
      ),
    );
  }
}
