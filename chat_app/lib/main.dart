import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './provider/curr_screen_provider.dart';
import './provider/contacts_provider.dart';
import './provider/chat_provider.dart';

import './screens/home_screen.dart';
import './screens/select_contact_screen.dart';
import './screens/chat_screen.dart';

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
        ChangeNotifierProvider.value(
          value: ChatProvider(),
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
          ChatScreen.routeName: (ctx) => ChatScreen(),
        },
        onUnknownRoute: (settings) {
          return MaterialPageRoute(builder: (ctx) => HomeScreen());
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
