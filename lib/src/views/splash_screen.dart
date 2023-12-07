import 'package:child_abuse_prevention/src/views/home.dart';
import 'package:child_abuse_prevention/src/views/login.dart';
import 'package:child_abuse_prevention/src/views/start_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    auth.authStateChanges().listen((User? user) {
      if (user == null) {
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => const Login()));
        });
      } else {
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const StartScreen()));
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              fit: BoxFit.cover,
              image: AssetImage("assets/images/bg.jpg")),
          Center(
            child: Image.asset(
              'assets/images/logo.png',
              width: MediaQuery.of(context).size.width * 0.7,
            ),
          ),
        ],
      ),
    );
  }
}
