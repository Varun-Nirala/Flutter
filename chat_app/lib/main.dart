import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './provider/curr_screen_provider.dart';
import './provider/contacts_provider.dart';
import './provider/chat_provider.dart';
import './provider/owner_info_provider.dart';

import './screens/home_screen.dart';
import './screens/select_contact_screen.dart';
import './screens/chat_screen.dart';
import './screens/verify_number_screen.dart';
/*
cmd:    keytool -list -v -alias androiddebugkey -keystore %USERPROFILE%\.android\debug.keystore
          MD5:  C8:47:A3:22:18:8F:35:6C:A0:31:3D:81:F7:9B:B4:5C
          SHA1: 88:33:01:7C:83:5C:10:17:FA:DC:D2:8E:33:CA:0C:25:93:CF:FE:3B
          SHA256: 36:01:F1:58:68:D6:3D:02:1B:89:47:86:71:B2:9A:E7:2F:1B:A4:83:51:06:15:1F:84:0B:B1:8F:41:FB:50:74
          Signature algorithm name: SHA1withRSA
          Version: 1

@TODO Have to create the release one
cmd:    keytool -exportcert -list -v -alias <your-key-name> -keystore <path-to-production-keystore>
*/

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
        ChangeNotifierProvider.value(
          value: OwnerInfoProvider(),
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
        home: VerifyNumberScreen(),
        initialRoute: VerifyNumberScreen.routeName,
        routes: {
          HomeScreen.routeName: (ctx) => HomeScreen(),
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
