import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = "/login-screen";
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

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
        title: Text('Login Screen'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          TextField(
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
          TextField(
            onSubmitted: (String val) {
              setState(() {
                _signInWithPhoneNumber(val);
              });
            },
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hasFloatingPlaceholder: false,
              labelText: 'Enter OTP',
            ),
          ),
          Text(_status, style: TextStyle(fontSize: 20),),
        ],
      ),
    );
  }
}
