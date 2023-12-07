import 'package:child_abuse_prevention/src/model/location_response.dart';
import 'package:child_abuse_prevention/src/model/police_data.dart';
import 'package:child_abuse_prevention/src/settings/settings_controller.dart';
import 'package:child_abuse_prevention/src/settings/settings_service.dart';
import 'package:child_abuse_prevention/src/utils/colors.dart';
import 'package:child_abuse_prevention/src/views/abuse_detection.dart';
import 'package:child_abuse_prevention/src/views/child_abuse_info.dart';
import 'package:child_abuse_prevention/src/views/howto.dart';
import 'package:child_abuse_prevention/src/views/instant_help.dart';
import 'package:child_abuse_prevention/src/views/legal_aid.dart';
import 'package:child_abuse_prevention/src/views/profile.dart';
import 'package:child_abuse_prevention/src/views/settings.dart';
import 'package:child_abuse_prevention/src/widgets/circular_progress.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:shake/shake.dart';

import 'package:system_alert_window/system_alert_window.dart' as fw;
import 'package:http/http.dart' as http;

import '../utils/config.dart';

class Home extends StatefulWidget {
  const Home({super.key, required this.polices});
  final List<Police> polices;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  SettingsController controller = SettingsController(SettingsService());
  late LocationPermission permission;
  FirebaseFirestore db = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  bool isLoaded = false;
  late Position position;
  late LocationResponse location;

  final GlobalKey _one = GlobalKey();
  final GlobalKey _two = GlobalKey();
  final GlobalKey _three = GlobalKey();
  final GlobalKey _four = GlobalKey();
  final GlobalKey _five = GlobalKey();

  fetchLocation() async {
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Permission Denied')));
      }
    }
    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    http.Response response = await http.get(Uri.parse(Config.geocoding +
        "longitude=${position.longitude}&latitude=${position.latitude}"));
    print(response.body);
    location = locationResponseFromJson(response.body);
    if (location.status == 200) {
      setState(() {
        isLoaded = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    controller.loadSettings();
    fetchLocation();

    ShakeDetector detector = ShakeDetector.autoStart(onPhoneShake: () async {
      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Permission Denied')));
        }
      }
      Position position = await Geolocator.getCurrentPosition();
      if (position != null) {
        print(position.latitude);
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
                                                    BorderRadius.circular(
                                                        20)))),
                                  )
                                ]),
                              ),
                            ],
                          ),
                        ],
                      )));
            });
      }
    });
  }

  void showOverLay() {
    fw.SystemWindowHeader header = fw.SystemWindowHeader(
        title: fw.SystemWindowText(
            text: "Immediate", fontSize: 10, textColor: Colors.black),
        padding: fw.SystemWindowPadding.setSymmetricPadding(12, 12),
        subTitle: fw.SystemWindowText(
            text: "Assistance",
            fontSize: 14,
            fontWeight: fw.FontWeight.BOLD,
            textColor: Colors.black87),
        decoration: fw.SystemWindowDecoration(
            startColor: Color.fromARGB(255, 179, 219, 255)),
        button: fw.SystemWindowButton(
            decoration: fw.SystemWindowDecoration(
                startColor: Color.fromARGB(255, 0, 67, 176)),
            text: fw.SystemWindowText(
                text: "Take Help", fontSize: 10, textColor: Colors.white),
            tag: "btn"),
        buttonPosition: fw.ButtonPosition.CENTER);

    fw.SystemAlertWindow.showSystemWindow(
        height: 80,
        width: 250,
        header: header,
        margin: fw.SystemWindowMargin(left: 8, right: 8, top: 200, bottom: 0),
        gravity: fw.SystemWindowGravity.TOP,
        notificationTitle: "Help",
        notificationBody: "Take Help",
        prefMode: fw.SystemWindowPrefMode.OVERLAY,
        backgroundColor: Colors.transparent,
        isDisableClicks: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "Child Abuse Prevention",
          style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Get.isDarkMode ? Colors.white : Colours.dark),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const HowTo()));
              },
              icon: Icon(Icons.info)),
          IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Setting()));
              },
              icon: Icon(Icons.settings)),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 30),
        child: FloatingActionButton.large(
            backgroundColor: Colors.black,
            onPressed: () {},
            child: const CircularProgressButton()),
      ),
      bottomNavigationBar: BottomAppBar(
        clipBehavior: Clip.antiAlias,
        color: Colors.white.withOpacity(0.6),
        child: Container(
          height: 60,
        ),
        // child: BackdropFilter(
        //   filter: ImageFilter.blur(sigmaX: 1.0, sigmaY: 1.0),
        //   child: BottomNavigationBar(
        //     backgroundColor: Colors.white.withOpacity(0.8),
        //     items: [
        //     BottomNavigationBarItem(icon: Icon(Icons.abc),label: "home"),
        //     BottomNavigationBarItem(icon: Icon(Icons.abc),label: "profile"),

        //   ]),
        // ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SizedBox(
                height: 5,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  border: Border.all(
                      color: Get.isDarkMode ? Colors.white : Colors.black),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.location_on,
                        color: Colors.green,
                        size: 20,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      isLoaded
                          ? SizedBox(
                              width: MediaQuery.of(context).size.width * 0.72,
                              child: Text(
                                '${location.place.address}, ${location.place.area}, ${location.place.city}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            )
                          : Text("....")
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              // InkWell(
              //   onTap: () {
              //     //ShowCaseWidget.of(context).startShowCase([_one]);
              //   },
              //   child: Container(
              //     width: MediaQuery.of(context).size.width,
              //     height: 110,
              //     decoration: BoxDecoration(
              //       color: Colors.blueAccent,
              //       borderRadius: BorderRadius.circular(15),
              //     ),
              //     child: Padding(
              //       padding:
              //           const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
              //       child: Row(
              //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //         children: [
              //           Column(
              //             crossAxisAlignment: CrossAxisAlignment.start,
              //             mainAxisAlignment: MainAxisAlignment.center,
              //             children: const [
              //               Text(
              //                 "App Guide",
              //                 style: TextStyle(
              //                   fontSize: 22,
              //                   color: Colors.white,
              //                   fontWeight: FontWeight.w600,
              //                 ),
              //               ),
              //               SizedBox(
              //                 height: 6,
              //               ),
              //               Text(
              //                 "How to use the app",
              //                 style: TextStyle(
              //                   fontSize: 15,
              //                   color: Colors.white,
              //                   fontWeight: FontWeight.w400,
              //                 ),
              //               ),
              //             ],
              //           ),
              //           Icon(
              //             Icons.info,
              //             color: Colors.white,
              //             size: 50,
              //           ),
              //         ],
              //       ),
              //     ),
              //   ),
              // ),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChildAbuseInfo(
                                polices: widget.polices,
                              )));
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 110,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(
                              "Child Abuse Info",
                              style: TextStyle(
                                fontSize: 22,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(
                              height: 6,
                            ),
                            Text(
                              "Know about Child Abuse",
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                        const Icon(
                          Icons.child_care,
                          color: Colors.white,
                          size: 50,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () async {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AbuseDetection()));
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 110,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(
                              "Abuse Detection",
                              style: TextStyle(
                                fontSize: 22,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(
                              height: 6,
                            ),
                            Text(
                              "Find out child abuse",
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                        const Icon(
                          Icons.healing,
                          color: Colors.white,
                          size: 50,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              //),
              const SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => InstantHelp(
                                polices: widget.polices,
                              )));
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 110,
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Instant Help",
                                style: TextStyle(
                                  fontSize: 22,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(
                                height: 6,
                              ),
                              Text(
                                "Seek help from nearby police stations",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.local_police,
                          color: Colors.white,
                          size: 50,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LegalAid()));
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 110,
                  decoration: BoxDecoration(
                    color: Colors.purple,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(
                              "Legal Aid",
                              style: TextStyle(
                                fontSize: 22,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(
                              height: 6,
                            ),
                            Text(
                              "Find out what the law says",
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                        const Icon(
                          Icons.policy,
                          color: Colors.white,
                          size: 50,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () {
                  // fw.SystemAlertWindow.closeSystemWindow(
                  //     prefMode: fw.SystemWindowPrefMode.OVERLAY);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const Profile()));
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 110,
                  decoration: BoxDecoration(
                    color: Colors.indigo,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(
                              "Account",
                              style: TextStyle(
                                fontSize: 22,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(
                              height: 6,
                            ),
                            Text(
                              "Update your information",
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                        const Icon(
                          Icons.account_circle,
                          color: Colors.white,
                          size: 50,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 200,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
