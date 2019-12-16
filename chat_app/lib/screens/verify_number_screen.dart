import 'package:flutter/material.dart';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_country_picker/flutter_country_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../helpers/common.dart';

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
  bool askPermission = true;

  @override
  Widget build(BuildContext context) {
    print(_status);
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
      body: Builder(
        builder: (BuildContext context) {
          return askPermission
              ? _showAlertDialog(context)
              : verifyPhoneNumberBody(context);
        },
      ),
    );
  }

  void _onAlertDialogePress(BuildContext context) async {
    try {
      bool val = await getPermissions(
          [PermissionGroup.contacts, PermissionGroup.storage]);

      if (val) {
        setState(() {
          askPermission = false;
        });
      } else {
        Future.delayed(Duration(seconds: 10), () => exit(0));
        Scaffold.of(context).showSnackBar(SnackBar(
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 10),
          content: Text('Required permissions are not granted. Exiting app...'),
          action: SnackBarAction(
            label: 'Exit',
            onPressed: () {
              exit(0);
            },
          ),
        ));
      }
    } catch (error) {
      throw error;
    }
  }

  AlertDialog _showAlertDialog(BuildContext context) {
    return AlertDialog(
      title: Text(
        'To easily connect with friends and famliy, and send and receive photos and videos, allow chatApp access to your contacts and your device\'s photos, media, and files.',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      actions: <Widget>[
        Container(
          alignment: Alignment.center,
          child: FlatButton(
            child: Text('Continue'),
            onPressed: () => _onAlertDialogePress(context),
          ),
        ),
      ],
    );
  }

  Widget verifyPhoneNumberBody(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        const Divider(
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
        const Divider(
          height: 15,
        ),
        CountryPicker(
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
        const Divider(
          height: 15,
          thickness: 2,
        ),
        Container(
          alignment: Alignment.center,
          height: 35,
          width: MediaQuery.of(context).size.width - 100,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                width: 50,
                child: Text(
                  '+${_country.dialingCode}',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                ),
              ),
              const SizedBox(
                width: 50,
              ),
              Expanded(
                child: TextField(
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                  onSubmitted: (String val) {
                    setState(() {
                      _phoneNumber = val;
                      _verifyPhoneNumber(_phoneNumber);
                    });
                  },
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hasFloatingPlaceholder: false,
                    labelText: 'Enter Number',
                  ),
                ),
              ),
            ],
          ),
        ),
        const Divider(
          height: 15,
          thickness: 2,
        ),
      ],
    );
  }

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
}
