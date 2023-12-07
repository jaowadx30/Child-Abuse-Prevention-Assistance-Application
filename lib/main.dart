import 'package:child_abuse_prevention/src/utils/config.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:system_alert_window/system_alert_window.dart' as fw;
import 'src/app.dart';
import 'src/settings/settings_controller.dart';
import 'src/settings/settings_service.dart';
import 'package:http/http.dart' as http;

@pragma('vm:entry-point')
void callBack(String tag) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  if (tag == 'btn') {
    try {
      print(tag);
      Position position = await Geolocator.getCurrentPosition();
      if (position != null) {
        print(position.latitude);
        var ref = await FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .get();
        var rescue = ref.data()!['rescue'];
        var response = await http.post(
            Uri.parse(
                'http://66.45.237.70/api.php?username=${Config.username}&password=${Config.password}&number=+88$rescue&message=Contact:${FirebaseAuth.instance.currentUser!.phoneNumber} ${Config.location}${position.latitude},${position.longitude}'),
            headers: {'Content-Type': 'application/x-www-form-urlencoded'});
        Fluttertoast.showToast(msg: "Your message has been sent.");
      }
    } catch (e) {
      print(e);
    }
  } else {
    print("callback");
  }
}

void main() async {
  // Set up the SettingsController, which will glue user settings to multiple
  // Flutter Widgets.
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final settingsController = SettingsController(SettingsService());

  // Load the user's preferred theme while the splash screen is displayed.
  // This prevents a sudden theme change when the app is first displayed.
  await settingsController.loadSettings();

  fw.SystemAlertWindow.registerOnClickListener(callBack);
  // Run the app and pass in the SettingsController. The app listens to the
  // SettingsController for changes, then passes it further down to the
  // SettingsView.
  runApp(MyApp(settingsController: settingsController));
}
