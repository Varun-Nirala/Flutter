import 'package:flutter/material.dart';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_country_picker/flutter_country_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../helpers/common.dart';
import '../provider/owner_info_provider.dart';
import '../models/owner_info.dart';
import '../screens/home_screen.dart';

class VerifyNumberScreen extends StatefulWidget {
  static const routeName = "/";

  @override
  _VerifyNumberScreenState createState() => _VerifyNumberScreenState();
}

class _VerifyNumberScreenState extends State<VerifyNumberScreen> {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  Country _country = Country.IN;
  String _verificationId = "";
  String _status = "";
  bool askPermission = true;
  bool manuallyEnterSMSCode = false;

  void successfullySignedIn(BuildContext context) {
    Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
  }

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
        ),
        Container(
          alignment: Alignment.center,
          height: 35,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Flexible(
                flex: 5,
                child: Text(
                  '+${_country.dialingCode}',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                ),
              ),
              Flexible(
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.only(left: 25),
                  child: TextField(
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                    onSubmitted: (String val) {
                      if (val.isNotEmpty) {
                        OwnerInfo ownerInfo =
                            Provider.of<OwnerInfoProvider>(context)
                                .setUserInfo(val, _country.dialingCode);
                        _verifyPhoneNumber(context, ownerInfo.phoneNumber);
                      }
                    },
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hasFloatingPlaceholder: false,
                      labelText: 'Enter Number',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const Divider(
          height: 45,
        ),
        manuallyEnterSMSCode
            ? _getSMSCode(context)
            : SizedBox(
                height: 1,
              ),
      ],
    );
  }

  Widget _getSMSCode(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: 35,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Flexible(
            flex: 6,
            child: Text(
              'SMS Code',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
            ),
          ),
          SizedBox(
            width: 20,
          ),
          Flexible(
            flex: 2,
            child: TextField(
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              onSubmitted: (String val) {
                if (val.isNotEmpty) {
                  _signInWithPhoneNumber(context, val);
                }
              },
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hasFloatingPlaceholder: false,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Example code of how to sign in with phone.
  void _signInWithPhoneNumber(BuildContext context, String smsCode) async {
    final AuthCredential authCredential = PhoneAuthProvider.getCredential(
        verificationId: _verificationId, smsCode: smsCode);

    final AuthResult result =
        (await _firebaseAuth.signInWithCredential(authCredential));

    final FirebaseUser currentUser = await _firebaseAuth.currentUser();

    assert(result.user.uid == currentUser.uid);
    setState(() {
      if (result.user != null) {
        _status = 'Successfully signed in, uid: ' + result.user.uid;
        successfullySignedIn(context);
      } else {
        _status = 'Sign in failed';
      }
    });
  }

  // Verify the phone number
  void _verifyPhoneNumber(BuildContext context, String phoneNumber) async {
    final PhoneVerificationCompleted verificationCompleted =
        (AuthCredential phoneAuthCredential) async {
      _firebaseAuth.signInWithCredential(phoneAuthCredential);
      setState(() {
        _status = 'Received phone auth credential: $phoneAuthCredential';
        successfullySignedIn(context);
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
      setState(() {
        _status =
            'Auto Retrieval timeout, user have to manually enter the SMS code';
        manuallyEnterSMSCode = true;
      });
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
