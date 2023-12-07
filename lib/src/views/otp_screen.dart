import 'package:child_abuse_prevention/src/views/home.dart';
import 'package:child_abuse_prevention/src/views/start_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({Key? key, required this.number}) : super(key: key);
  final String number;

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore db = FirebaseFirestore.instance;
  late String verificationCode;
  late int _resend;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    verificationCode = "0";
    verifyAuth();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black,
            )),
        title: const Text(
          'Verify Phone',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Stack(
            alignment: AlignmentDirectional.bottomCenter,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/otp_bg.jpg',
                    width: MediaQuery.of(context).size.width,
                  ),
                  Text(
                    'Enter Verification Code',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 21),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: PinCodeTextField(
                      pinTheme: PinTheme.defaults(
                          shape: PinCodeFieldShape.box,
                          inactiveColor: Colors.orange),
                      appContext: context,
                      length: 6,
                      onChanged: (value) {},
                      onCompleted: (value) async {
                        try {
                          await FirebaseAuth.instance
                              .signInWithCredential(
                                  PhoneAuthProvider.credential(
                                      verificationId: verificationCode,
                                      smsCode: value))
                              .then((value) async {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const StartScreen()),
                                (route) => false);
                          });
                        } catch (e) {
                          print(e);
                        }
                      },
                    ),
                  ),
                  Text(
                    'A verification code is sent to ${widget.number}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    'Didn\'t receive code?',
                    style: TextStyle(color: Colors.red),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'Resend',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.green),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future verifyAuth() async {
    print(widget.number);
    print("Called");
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: widget.number,
        verificationCompleted: (PhoneAuthCredential credential) async {
          try {
            print("Sign in");
            await auth.signInWithCredential(credential).then((value) async {
              // if(value.additionalUserInfo!.isNewUser){

              // }else{
              //   Navigator.pushAndRemoveUntil(
              //     context,
              //     MaterialPageRoute(builder: (context) => const Home()),
              //     (route) => false);
              // }
              await Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const StartScreen()),
                  (route) => false);
            });
          } catch (e) {
            FocusScope.of(context).unfocus();
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Network error, Try again")));
          }
        },
        verificationFailed: (FirebaseAuthException e) {
          FocusScope.of(context).unfocus();
          if (e.code == 'invalid-phone-number') {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text("Invalid Phone Number")));
          } else {
            print(e);
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Something wrong occurred")));
          }
        },
        codeSent: (String verificationId, int? resendToken) {
          print("code sent");
          setState(() {
            verificationCode = verificationId;
            _resend = resendToken!;
          });
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          setState(() {
            verificationCode = verificationId;
          });
        },
        timeout: Duration(seconds: 40));
  }
}
