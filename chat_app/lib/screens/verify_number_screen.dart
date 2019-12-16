import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_country_picker/flutter_country_picker.dart';

class VerifyNumberScreen extends StatefulWidget {
  static const routeName = "/verify-number-screen";
  @override
  _VerifyNumberScreenState createState() => _VerifyNumberScreenState();
}

class _VerifyNumberScreenState extends State<VerifyNumberScreen> {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  Country _country = Country.IN;
  String _phoneNumber = "";
  String _verificationId = "";
  String _status = "";

  // Example code of how to sign in with phone.
  void _signInWithPhoneNumber(String smsCode) async {
    final AuthCredential authCredential = PhoneAuthProvider.getCredential(
        verificationId: _verificationId, smsCode: smsCode);

    final AuthResult result =
        (await _firebaseAuth.signInWithCredential(authCredential));

    final FirebaseUser currentUser = await _firebaseAuth.currentUser();

    assert(result.user.uid == currentUser.uid);
    setState(() {
      if (result.user != null) {
        _status = 'Successfully signed in, uid: ' + result.user.uid;
      } else {
        _status = 'Sign in failed';
      }
    });
  }

  // Verify the phone number
  void _verifyPhoneNumber(String phoneNumber) async {
    final PhoneVerificationCompleted verificationCompleted =
        (AuthCredential phoneAuthCredential) async {
      _firebaseAuth.signInWithCredential(phoneAuthCredential);
      setState(() {
        _status = 'Received phone auth credential: $phoneAuthCredential';
      });
    };

    final PhoneVerificationFailed verificationFailed =
        (AuthException authException) async {
      setState(() {
        _status =
            'Phone number verification failed. Code: ${authException.code}. Message: ${authException.message}';
      });
    };

    final PhoneCodeSent codeSent =
        (String verificationId, [int forceREsendingToken]) async {
      _verificationId = verificationId;
    };

    final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) async {
      _verificationId = verificationId;
      // Ask user to manually input the OTP
    };

    await _firebaseAuth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: Duration(seconds: 60),
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.0,
        title: Text(
          'Verify your phone number',
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
        backgroundColor: Colors.white,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Divider(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
            child: Text(
              'ChatApp will send an SMS message (other charges may apply) to verify your phone number. Enter your country code and phone number.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ),
          Divider(
            height: 15,
          ),
          Center(
            child: CountryPicker(
              selectedCountry: _country,
              dense: false,
              showFlag: true, //displays flag, true by default
              showDialingCode: false, //displays dialing code, false by default
              showName: true, //displays country name, true by default
              showCurrency: false, //eg. 'British pound'
              showCurrencyISO: false, //eg. 'GBP'
              onChanged: (Country country) {
                setState(() {
                  _country = country;
                });
              },
            ),
          ),
          Divider(
            height: 15,
            thickness: 2,
          ),
          // Text(
          //   _country.dialingCode,
          //   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          // ),
          // TextField(
          //   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          //   onSubmitted: (String val) {
          //     setState(() {
          //       _phoneNumber = val;
          //       _verifyPhoneNumber(_phoneNumber);
          //     });
          //   },
          //   keyboardType: TextInputType.number,
          //   decoration: InputDecoration(
          //     hasFloatingPlaceholder: false,
          //     labelText: 'Enter Number',
          //   ),
          // ),
        ],
      ),
    );
  }
}

// Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: <Widget>[
//           TextField(
//             onSubmitted: (String val) {
//               setState(() {
//                 _phoneNumber = val;
//                 _verifyPhoneNumber(_phoneNumber);
//               });
//             },
//             keyboardType: TextInputType.number,
//             decoration: InputDecoration(
//               hasFloatingPlaceholder: false,
//               labelText: 'Enter Number',
//             ),
//           ),
//           TextField(
//             onSubmitted: (String val) {
//               setState(() {
//                 _signInWithPhoneNumber(val);
//               });
//             },
//             keyboardType: TextInputType.number,
//             decoration: InputDecoration(
//               hasFloatingPlaceholder: false,
//               labelText: 'Enter OTP',
//             ),
//           ),
//           Text(
//             _status,
//             style: TextStyle(fontSize: 20),
//           ),
//         ],
//       )
