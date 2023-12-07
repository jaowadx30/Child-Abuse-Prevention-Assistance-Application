import 'package:child_abuse_prevention/src/model/police_data.dart';
import 'package:child_abuse_prevention/src/views/create_user.dart';
import 'package:child_abuse_prevention/src/views/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:system_alert_window/system_alert_window.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({Key? key}) : super(key: key);

  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  List<Police> polices = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }


  getData() async {
    final bool? status = await SystemAlertWindow.checkPermissions(
        prefMode: SystemWindowPrefMode.OVERLAY);
    if (!status!) {
      await SystemAlertWindow.requestPermissions(
          prefMode: SystemWindowPrefMode.OVERLAY);
    }
    await db.collection('stations').get().then((value) async {
      print(value.docs.length);
      for (int i = 0; i < value.docs.length; i++) {
        polices.add(Police(
            value.docs[i].id,
            value.docs[i].get('Thana'),
            value.docs[i].get('Designation'),
            value.docs[i].get('Mobile'),
            value.docs[i].get('District')));

        if (value.docs.length == i + 1) {
          var ref =
              await db.collection("users").doc(auth.currentUser!.uid).get();

          if (ref.exists) {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => Home(
                          polices: polices,
                        )),
                (route) => false);
          } else {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CreateUser(polices: polices)));
          }
        }
      }
    });
  }
}
