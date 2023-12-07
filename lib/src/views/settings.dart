import 'package:child_abuse_prevention/src/utils/colors.dart';
import 'package:child_abuse_prevention/src/views/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:system_alert_window/system_alert_window.dart' as fw;

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<Setting> {
  bool isDark = Get.isDarkMode;
  bool overLay = false;
  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.keyboard_arrow_left,
            )),
        title: Text(
          "Settings",
          style: TextStyle(
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : Colours.dark),
        ),
      ),
      body: Column(
        children: [
          ListTile(
            leading: Icon(Icons.dark_mode),
            title: const Text("Dark Mode"),
            trailing: Switch(
                value: isDark,
                onChanged: (value) {
                  setState(() {
                    isDark = value;
                    Get.changeTheme(Get.isDarkMode
                        ? Colours.lightTheme
                        : Colours.darkTheme);
                    Get.appUpdate();
                  });
                  setState(() {});
                }),
          ),
          ListTile(
            leading: Icon(Icons.send),
            title: const Text("Open Emergency head"),
            trailing: Switch(
                value: overLay,
                onChanged: (value) {
                  setState(() {
                    overLay = value;
                  });
                  if (overLay) {
                    showOverLay();
                  } else {
                    fw.SystemAlertWindow.closeSystemWindow(
                        prefMode: fw.SystemWindowPrefMode.OVERLAY);
                  }
                }),
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text("Logout"),
            onTap: () async {
              await auth.signOut().then((value) {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const Login()),
                    (route) => false);
              });
            },
          )
        ],
      ),
    );
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
                text: "Get Help", fontSize: 10, textColor: Colors.white),
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
}
