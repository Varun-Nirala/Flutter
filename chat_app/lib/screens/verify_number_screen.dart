import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_country_picker/flutter_country_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../helpers/contacts.dart';
import '../helpers/common.dart';
import '../provider/owner_info_provider.dart';
import '../screens/home_screen.dart';

class VerifyNumberScreen extends StatefulWidget {
  static const routeName = "/";

  @override
  _VerifyNumberScreenState createState() => _VerifyNumberScreenState();
}

class _VerifyNumberScreenState extends State<VerifyNumberScreen> {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  Country _country = Country.IN;
  String _phoneNumber = "";
  String _verificationId = "";
  String _status = "";
  bool askPermission = false;
  bool manuallyEnterSMSCode = false;
  String _smsCode = "";

  var _bIsInit = true;
  var _bIsLoading = false;

  var _bVerifyingNumber = false;

  String get getPhoneNo {
    return '+' + _country.dialingCode + _phoneNumber;
  }

  void _showSnackBar(BuildContext context, String text,
      [bool bExit = false, int timeInSec = 10]) {
    Scaffold.of(context).removeCurrentSnackBar();
    if (bExit) {
      Scaffold.of(context).showSnackBar(SnackBar(
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: timeInSec),
        content: Text(text),
        action: SnackBarAction(
          label: 'Exit',
          onPressed: () {
            exit(0);
          },
        ),
      ));
    } else {
      Scaffold.of(context).showSnackBar(SnackBar(
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: timeInSec),
        content: Text(text),
      ));
    }
  }

  Future<void> successfullySignedIn(BuildContext context) async {
    // Save Data to Device Storage
    if (!_bIsLoading) {
      await Provider.of<OwnerInfoProvider>(context, listen: false)
          .setUserInfo(_phoneNumber, _country.dialingCode, true);
    }
    String ownerNumber = '+' + _country.dialingCode + _phoneNumber;
    await Contacts().fetchAndSetContacts(ownerNumber);
    Navigator.of(context)
        .pushReplacementNamed(HomeScreen.routeName, arguments: ownerNumber);
  }

  @override
  void didChangeDependencies() {
    if (_bIsInit) {
      _bIsLoading = true;
      Provider.of<OwnerInfoProvider>(context)
          .fetchAndSetOwner()
          .then((ownerInfo) {
        if (ownerInfo != null) {
          _phoneNumber = ownerInfo.userNumber;

          for (Country c in Country.ALL) {
            if (c.dialingCode == ownerInfo.userCountryCode) {
              _country = c;
            }
          }
          setState(() {
            if (_firebaseAuth.currentUser() != null) {
              askPermission = false;
              successfullySignedIn(context);
            } else {
              _status = 'Sign in failed';
              _bIsLoading = false;
            }
          });
        } else {
          _bIsLoading = false;
          askPermission = true;
        }
      }).catchError((_) {
        _bIsLoading = false;
        askPermission = true;
      });
    }
    _bIsInit = false;
    super.didChangeDependencies();
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
      body: _bIsLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Builder(
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
          [Permission.contacts, Permission.storage]);

      if (val) {
        setState(() {
          askPermission = false;
        });
      } else {
        Future.delayed(const Duration(seconds: 10), () => exit(0));
        _showSnackBar(context,
            'Required permissions are not granted. Exiting app...', true);
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
            child: const Text('Continue'),
            onPressed: () => _onAlertDialogePress(context),
          ),
        ),
      ],
    );
  }

  Widget verifyPhoneNumberBody(BuildContext context) {
    return _bVerifyingNumber
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              const Divider(
                height: 10,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
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
                showDialingCode:
                    false, //displays dialing code, false by default
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
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 25),
                      ),
                    ),
                    Flexible(
                      flex: 4,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 25),
                        child: TextField(
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 25),
                          onSubmitted: (String val) {
                            if (val.isNotEmpty && val.length >= 10) {
                              _phoneNumber = val;
                              _verifyPhoneNumber(context, getPhoneNo);
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
          const SizedBox(
            width: 20,
          ),
          Flexible(
            flex: 2,
            child: TextField(
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              onTap: () => Scaffold.of(context).removeCurrentSnackBar(),
              onSubmitted: (String val) {
                if (val.isNotEmpty) {
                  _smsCode = val;
                  _signInWithPhoneNumber(context);
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
  Future<void> _signInWithPhoneNumber(BuildContext context) async {
    setState(() {
      _bVerifyingNumber = true;
    });

    final AuthCredential authCredential = PhoneAuthProvider.getCredential(
        verificationId: _verificationId, smsCode: _smsCode);

    final AuthResult result =
        await _firebaseAuth.signInWithCredential(authCredential);

    final FirebaseUser currentUser = await _firebaseAuth.currentUser();

    assert(result.user.uid == currentUser.uid);
    setState(() {
      if (result.user != null) {
        askPermission = false;
        _status = 'Successfully signed in, uid: ' + result.user.uid;
        successfullySignedIn(context);
      } else {
        _status = 'Sign in failed';
        _bIsLoading = false;
      }
    });
  }

  // Verify the phone number
  void _verifyPhoneNumber(BuildContext context, String phoneNumber) async {
    _showSnackBar(context, 'Waiting for SMS Code', false, 5);

    final PhoneVerificationCompleted verificationCompleted =
        (AuthCredential authCredential) async {
      _showSnackBar(context, 'Verification Complete. Loging In.', false, 5);

      setState(() {
        _bVerifyingNumber = true;
      });

      final AuthResult result =
          await _firebaseAuth.signInWithCredential(authCredential);

      final FirebaseUser currentUser = await _firebaseAuth.currentUser();

      assert(result.user.uid == currentUser.uid);
      setState(() {
        if (result.user != null) {
          askPermission = false;
          _status = 'Successfully signed in, uid: ' + result.user.uid;
          successfullySignedIn(context);
        } else {
          _status = 'Sign in failed';
          _bIsLoading = false;
        }
      });
    };

    final PhoneVerificationFailed verificationFailed =
        (AuthException authException) async {
      _showSnackBar(
          context,
          'Authentication Failed. Code: ${authException.code}. Message: ${authException.message}',
          true);
      setState(() {
        _status =
            'Phone number verification failed. Code: ${authException.code}. Message: ${authException.message}';
      });
    };

    final PhoneCodeSent codeSent =
        (String verificationId, [int forceResendingToken]) async {
      _showSnackBar(context, 'SMS Code Sent. Trying Auto Retrieval.', false, 60);
      _verificationId = verificationId;
    };

    final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) async {
      _showSnackBar(context, 'SMS Code Auto Retrieval timeout. Enter manually.', false, 5);
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
