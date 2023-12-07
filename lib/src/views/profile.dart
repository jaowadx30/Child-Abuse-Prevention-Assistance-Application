import 'dart:io';

import 'package:child_abuse_prevention/src/utils/colors.dart';
import 'package:child_abuse_prevention/src/views/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  FirebaseAuth auth = FirebaseAuth.instance;
  bool isLoaded = false;
  FirebaseFirestore db = FirebaseFirestore.instance;
  String userName = '';
  String age = '';
  String gender = '';
  String? mobile = '';
  String image = '';
  String birth = '';
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  late File _image;
  ImagePicker picker = ImagePicker();
  TextEditingController rescue = TextEditingController();
  TextEditingController birthCon = TextEditingController();
  TextEditingController ageCon = TextEditingController();
  TextEditingController nameCon = TextEditingController();
  bool isSave = false;

  @override
  void initState() {
    super.initState();
    getProfileData();
  }

  Future getProfileData() async {
    await db.collection('users').doc(auth.currentUser!.uid).get().then((value) {
      userName = value.data()!["name"];
      age = value.data()!["age"];
      gender = value.data()!['gender'];
      image = value.data()!['image'];
      mobile = auth.currentUser!.phoneNumber;
      birthCon.text = value.data()!['birth'];
      rescue.text = value.data()!['rescue'];
      nameCon.text = userName;
      ageCon.text = age;
      setState(() {
        isLoaded = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
            "My Account",
            style:
                TextStyle(color: Get.isDarkMode ? Colors.white : Colours.dark),
          ),
          // actions: [
          //   Padding(
          //     padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          //     child: ElevatedButton(
          //       onPressed: () async {
          //         await auth.signOut().then((value) {
          //           Navigator.pushAndRemoveUntil(
          //               context,
          //               MaterialPageRoute(builder: (context) => const Login()),
          //               (route) => false);
          //         });
          //       },
          //       style: ButtonStyle(
          //           backgroundColor:
          //               MaterialStateProperty.all(Colors.red.shade800)),
          //       child: Text(
          //         'Log Out',
          //         style: TextStyle(color: Colors.white, fontSize: 13),
          //       ),
          //     ),
          //   ),
          // ],
        ),
        body: SingleChildScrollView(
          child: isLoaded
              ? Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 20, right: 20, top: 20, bottom: 10),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 100,
                              height: 100,
                              clipBehavior: Clip.hardEdge,
                              decoration: const BoxDecoration(
                                  shape: BoxShape.circle, color: Colors.white),
                              child: image == ''
                                  ? Image.asset(
                                      'assets/images/avatar.png',
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    )
                                  : Image.network(
                                      image,
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                            const SizedBox(
                              height: 3,
                            ),
                            TextButton(
                                onPressed: () async {
                                  var pickedFile = await picker.pickImage(
                                      source: ImageSource.gallery);
                                  setState(() async {
                                    if (pickedFile != null) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text("Uploading..."),
                                      ));
                                      _image = File(pickedFile.path);
                                      await firebase_storage
                                          .FirebaseStorage.instance
                                          .ref('uploads/' +
                                              auth.currentUser!.uid +
                                              '.jpg')
                                          .putFile(_image)
                                          .then((p0) async {
                                        image = await p0.ref.getDownloadURL();
                                        await db
                                            .collection('users')
                                            .doc(auth.currentUser!.uid)
                                            .update({"image": image});
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          content: Text("Uploaded!!!"),
                                        ));
                                      });
                                      setState(() {});
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text("Nothing Selected"),
                                      ));
                                    }
                                  });
                                },
                                child: Text(
                                  "Change Picture",
                                  style: TextStyle(
                                      color: Get.isDarkMode
                                          ? Colors.yellow.shade800
                                          : Colors.blue),
                                )),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Profile Information",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                          color: Get.isDarkMode
                                              ? Colors.white
                                              : Colors.blue.shade900),
                                    ),
                                    TextButton.icon(
                                      onPressed: () {
                                        setState(() {
                                          isSave = !isSave;
                                        });
                                      },
                                      icon: Icon(
                                        Icons.edit,
                                        size: 15,
                                        color: Colors.deepOrange.shade800,
                                      ),
                                      label: Text(
                                        isSave ? "Cancel" : "Edit",
                                        style: TextStyle(
                                            color: Colors.deepOrange.shade800),
                                      ),
                                    )
                                  ],
                                ),

                                const Divider(
                                  thickness: 1.5,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "Your Name",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16),
                                ),
                                const SizedBox(
                                  height: 9,
                                ),
                                TextField(
                                  controller: nameCon,
                                  keyboardType: TextInputType.text,
                                  style: TextStyle(
                                      fontFamily:
                                          GoogleFonts.dmSans().fontFamily,
                                      color: Colors.black),
                                  decoration: InputDecoration(
                                      hintText: "",
                                      isDense: true,
                                      fillColor: Colors.blue.shade100,
                                      filled: true,
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius: BorderRadius.circular(10),
                                      )),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "Age",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16),
                                ),
                                const SizedBox(
                                  height: 9,
                                ),
                                TextField(
                                  controller: ageCon,
                                  keyboardType: TextInputType.number,
                                  style: TextStyle(
                                      fontFamily:
                                          GoogleFonts.dmSans().fontFamily,
                                      color: Colors.black),
                                  decoration: InputDecoration(
                                      hintText: "",
                                      isDense: true,
                                      fillColor: Colors.blue.shade100,
                                      filled: true,
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius: BorderRadius.circular(10),
                                      )),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                // Text(
                                //   "Gender",
                                //   style: TextStyle(
                                //       fontWeight: FontWeight.w600, fontSize: 16),
                                // ),
                                // const SizedBox(
                                //   height: 9,
                                // ),
                                // Container(
                                //   width: double.infinity,
                                //   decoration: BoxDecoration(
                                //       borderRadius: BorderRadius.circular(10),
                                //       color: Colors.blue.shade100),
                                //   child: Padding(
                                //     padding: const EdgeInsets.symmetric(
                                //         horizontal: 15, vertical: 13),
                                //     child: Text(gender,
                                //         style: TextStyle(color: Colors.black)),
                                //   ),
                                // ),
                                // const SizedBox(
                                //   height: 9,
                                // ),
                                Text(
                                  "Birth Certificate No",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16),
                                ),
                                const SizedBox(
                                  height: 9,
                                ),
                                TextField(
                                  controller: birthCon,
                                  keyboardType: TextInputType.number,
                                  style: TextStyle(
                                      fontFamily:
                                          GoogleFonts.dmSans().fontFamily,
                                      color: Colors.black),
                                  decoration: InputDecoration(
                                      hintText: "",
                                      isDense: true,
                                      fillColor: Colors.blue.shade100,
                                      filled: true,
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius: BorderRadius.circular(10),
                                      )),
                                ),
                                const SizedBox(
                                  height: 9,
                                ),
                                Text(
                                  "Emergency Contact Number",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16),
                                ),
                                const SizedBox(
                                  height: 9,
                                ),
                                TextField(
                                  controller: rescue,
                                  keyboardType: TextInputType.phone,
                                  style: TextStyle(
                                      fontFamily:
                                          GoogleFonts.dmSans().fontFamily,
                                      color: Colors.black),
                                  decoration: InputDecoration(
                                      hintText: "01*********",
                                      isDense: true,
                                      fillColor: Colors.blue.shade100,
                                      filled: true,
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius: BorderRadius.circular(10),
                                      )),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: isSave
                                      ? ElevatedButton(
                                          onPressed: () async {
                                            if (rescue.value.text.isEmpty ||
                                                rescue.value.text.length !=
                                                    11) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                      content: Text(
                                                          "Invalid Mobile Number")));
                                            } else {
                                              await db
                                                  .collection("users")
                                                  .doc(auth.currentUser!.uid)
                                                  .update({
                                                "rescue": rescue.value.text,
                                                "name": nameCon.value.text,
                                                "age": ageCon.value.text,
                                                "birth": birthCon.value.text
                                              }).then((value) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                        content:
                                                            Text("Updated")));
                                                setState(() {
                                                  isSave != isSave;
                                                });
                                              });
                                            }
                                          },
                                          child: Text("Update"))
                                      : Container(),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    // Positioned(
                    //   top: 0,
                    //   right: 0,
                    //   child: TextButton.icon(
                    //     icon: Icon(
                    //       Icons.logout,
                    //       color: Colors.redAccent,
                    //     ),
                    //     onPressed: () async {
                    //       await auth.signOut().then((value) {
                    //         Navigator.pushAndRemoveUntil(
                    //             context,
                    //             MaterialPageRoute(
                    //                 builder: (context) => const Login()),
                    //             (route) => false);
                    //       });
                    //     },
                    //     label: Text(
                    //       'Log Out',
                    //       style: TextStyle(color: Colors.redAccent),
                    //     ),
                    //   ),
                    // ),
                  ],
                )
              : const Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}
