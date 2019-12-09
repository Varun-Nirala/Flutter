import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './provider/curr_screen_provider.dart';
import './provider/contacts_provider.dart';

import './screens/home_screen.dart';
import './screens/select_contact_screen.dart';

void main() => runApp(ChatApp());

class ChatApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: CurrScreenProvider(),
        ),
        ChangeNotifierProvider.value(
          value: ContactsProvider(),
        ),
      ],
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
        home: HomeScreen(),
        initialRoute: HomeScreen.routeName,
        routes: {
          SelectContactScreen.routeName: (ctx) => SelectContactScreen(),
        },
        onUnknownRoute: (settings) {
          return MaterialPageRoute(builder: (ctx) => HomeScreen());
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
