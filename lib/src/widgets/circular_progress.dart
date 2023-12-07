import 'package:child_abuse_prevention/src/utils/config.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class CircularProgressButton extends StatefulWidget {
  const CircularProgressButton({Key? key}) : super(key: key);

  @override
  State<CircularProgressButton> createState() => _CircularProgressButtonState();
}

class _CircularProgressButtonState extends State<CircularProgressButton>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late LocationPermission permission;
  FirebaseFirestore db = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..addListener(() {
        setState(() {});
      });
  }

  void emergency() async {
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Permission Denied')));
      }
    } else if (permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
    }
    Position position = await Geolocator.getCurrentPosition();
    if (position != null) {
      // print(position.latitude);
      var ref = await db.collection('users').doc(auth.currentUser!.uid).get();
      var rescue = ref.data()!['rescue'];
      var response = await http.post(
          Uri.parse(
              'http://66.45.237.70/api.php?username=${Config.username}&password=${Config.password}&number=+88$rescue&message=Contact:${auth.currentUser!.phoneNumber} ${Config.location}${position.latitude},${position.longitude}'),
          headers: {'Content-Type': 'application/x-www-form-urlencoded'});

      showGeneralDialog(
          context: context,
          barrierDismissible: false,
          pageBuilder: (context, a, b) {
            return Container();
          },
          transitionBuilder: (context, a, b, child) {
            return Transform.scale(
                scale: a.value,
                child: Dialog(
                    insetAnimationDuration: const Duration(milliseconds: 500),
                    insetAnimationCurve: Curves.easeInBack,
                    insetPadding: const EdgeInsets.symmetric(horizontal: 10),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    child: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      alignment: WrapAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 20, bottom: 20, left: 20, right: 20),
                              child: Column(children: [
                                const Text(
                                  'Emergency',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.deepPurple,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                const Text('Message has been sent',
                                    textAlign: TextAlign.center),
                                const SizedBox(
                                  height: 10,
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text("OK"),
                                  style: ButtonStyle(
                                      shape: MaterialStateProperty.all(
                                          RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20)))),
                                )
                              ]),
                            ),
                          ],
                        ),
                      ],
                    )));
          });
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        Visibility(
          visible: true,
          child: SizedBox(
            width: 120,
            height: 120,
            child: CircularProgressIndicator(
              strokeWidth: 6,
              value: controller.value,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
          ),
        ),
        GestureDetector(
            onLongPressStart: (details) {
              controller.forward();
            },
            onLongPressEnd: (details) async {
              if (controller.value == 1.0) {
                controller.reset();
                emergency();
              } else {
                controller.reset();
                print("Not Today");
              }
            },
            child: Container(
              decoration: BoxDecoration(shape: BoxShape.circle),
              margin: EdgeInsets.all(0.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.waving_hand,
                    color: Colors.white,
                  ),
                  Text(
                    "Help",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 17),
                  )
                ],
              ),
              // onPressed: () {
              //   // if (is_logged_in.value) {
              //   //   showConfirmDialog();
              //   // } else {
              //   //   Navigator.push(context,
              //   //       MaterialPageRoute(builder: (context) {
              //   //     return Login();
              //   //   }));
              //   // }
              // }
            )),
      ],
    );
  }

  Future<void> _showMyDialog(String t, String M) async {
    return showGeneralDialog<void>(
      context: context,
      barrierDismissible: false,
      pageBuilder: (context, a, b) {
        return Container();
      },
      transitionBuilder: (context, a, b, child) {
        return Transform.scale(
          scale: a.value,
          child: AlertDialog(
            title: Text(t),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text(M),
                ],
              ),
            ),
            actions: <Widget>[
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.blue),
                ),
                child: Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
