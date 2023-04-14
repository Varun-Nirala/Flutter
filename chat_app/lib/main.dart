import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './provider/curr_screen_provider.dart';
import './provider/chat_provider.dart';
import './provider/active_chats_provider.dart';
import './provider/owner_info_provider.dart';

import './screens/home_screen.dart';
import './screens/select_contact_screen.dart';
import './screens/chat_screen.dart';
import './screens/verify_number_screen.dart';

import 'package:firebase_core/firebase_core.dart';
/*
cmd:    keytool -list -v -alias androiddebugkey -keystore %USERPROFILE%\.android\debug.keystore
          MD5:  C8:47:A3:22:18:8F:35:6C:A0:31:3D:81:F7:9B:B4:5C
          SHA1: 88:33:01:7C:83:5C:10:17:FA:DC:D2:8E:33:CA:0C:25:93:CF:FE:3B
          SHA256: 36:01:F1:58:68:D6:3D:02:1B:89:47:86:71:B2:9A:E7:2F:1B:A4:83:51:06:15:1F:84:0B:B1:8F:41:FB:50:74
          Signature algorithm name: SHA1withRSA
          
          Certificate fingerprints:
          SHA1: 00:B8:C0:B7:F0:1C:9B:1F:8F:BA:C0:50:8F:52:88:25:4F:62:4D:0C
          SHA256: 9B:CD:1E:91:3C:54:7C:DC:C4:0D:06:B1:F8:C2:9F:65:1D:9E:DD:A7:D9:D0:46:92:DA:A0:CE:56:FF:BE:1B:CA
          Signature algorithm name: SHA1withRSA (weak)
          Subject Public Key Algorithm: 2048-bit RSA key
          Version: 1

@TODO Have to create the release one
cmd:    keytool -genkey -v -keystore c:/Users/CODENAME/key.jks -storetype JKS -keyalg RSA -keysize 2048 -validity 10000 -alias key
*/

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(ChatApp());
}

class ChatApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: CurrScreenProvider(),
        ),
        ChangeNotifierProvider.value(
          value: ChatProvider(),
        ),
        ChangeNotifierProvider.value(
          value: OwnerInfoProvider(),
        ),
        ChangeNotifierProvider.value(
          value: ActiveChatsProvider(),
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
