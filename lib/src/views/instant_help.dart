import 'dart:io';

import 'package:child_abuse_prevention/src/model/link_short.dart';
import 'package:child_abuse_prevention/src/utils/colors.dart';
import 'package:child_abuse_prevention/src/utils/config.dart';
import 'package:child_abuse_prevention/src/widgets/global.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import '../model/police_data.dart';

class InstantHelp extends StatefulWidget {
  const InstantHelp({super.key, required this.polices});
  final List<Police> polices;

  @override
  State<InstantHelp> createState() => _InstantHelpState();
}

class _InstantHelpState extends State<InstantHelp> {
  String districtValue = '';
  String thanaValue = '';
  FirebaseAuth auth = FirebaseAuth.instance;
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  late DocumentSnapshot<Map<String, dynamic>> result;
  List<Police> polices = [];
  List<DropdownMenuItem<String>> districtList = [];
  List<DropdownMenuItem<String>> droplist = [
    const DropdownMenuItem(value: '', child: Text('Select a Thana'))
  ];
  bool isLoaded = false;
  bool isPolice = false;
  final ImagePicker _picker = ImagePicker();
  String districtName = 'Select District';
  String thanaName = 'Select Thana';
  TextEditingController searchDis = TextEditingController();
  TextEditingController searchTha = TextEditingController();
  FirebaseFirestore db = FirebaseFirestore.instance;
  List<String> districts = [];
  List<String> temp = [];
  late OverlayEntry loader;

  loadDistrict() async {
    // districtList.clear();
    // districtList.add((const DropdownMenuItem(
    //     value: '',
    //     child: Text(
    //       'Select District',
    //     ))));
    widget.polices.forEach((element) {
      districts.add(element.district);
    });
    temp = districts.toSet().toList();
    districts = districts.toSet().toList();
    // districts.forEach((element) {
    //   districtList.add((DropdownMenuItem(
    //       value: element,
    //       child: Text(
    //         '${element}',
    //       ))));
    // });
    setState(() {
      isLoaded = true;
    });
  }

  loadSearch(String val) {
    temp = [];
    districts.forEach((element) {
      if (element.toLowerCase().contains(val.toLowerCase())) {
        temp.add(element);
      }
    });
    setState(() {});
  }

  Future loadDetails() async {
    await db.collection('stations').doc(thanaValue).get().then((value) {
      if (value.exists) {
        result = value;
        setState(() {
          isPolice = true;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    loadDistrict();
    loader = Global.overlayLoader(context);
  }

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
          "Instant Help",
          style: TextStyle(color: Get.isDarkMode ? Colors.white : Colours.dark),
        ),
      ),
      body: isLoaded
          ? SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Select District')),
                    const SizedBox(
                      height: 8,
                    ),
                    InkWell(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return StatefulBuilder(
                                  builder: (context, setstate) {
                                return Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(25.0),
                                    child: Wrap(
                                      children: [
                                        Material(
                                          child: Padding(
                                            padding: const EdgeInsets.all(15.0),
                                            child: Column(
                                              children: [
                                                TextField(
                                                  onChanged: (String val) {
                                                    loadSearch(val);
                                                    setstate(() {});
                                                  },
                                                  controller: searchDis,
                                                  decoration: InputDecoration(
                                                      isDense: true,
                                                      prefixIcon: const Icon(
                                                          Icons.search),
                                                      hintText: "Search here",
                                                      border: OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                          borderSide:
                                                              BorderSide())),
                                                ),
                                                Container(
                                                  height: 400,
                                                  child: ListView.builder(
                                                      shrinkWrap: true,
                                                      itemCount: temp.length,
                                                      itemBuilder:
                                                          (context, index) {
                                                        return InkWell(
                                                          onTap: () async {
                                                            await db
                                                                .collection(
                                                                    'stations')
                                                                .where(
                                                                    'District',
                                                                    isEqualTo:
                                                                        temp[
                                                                            index])
                                                                .get()
                                                                .then(
                                                                    (snapshot) {
                                                              droplist.clear();
                                                              droplist = [
                                                                const DropdownMenuItem(
                                                                    value: '',
                                                                    child: Text(
                                                                        'Select a Thana')),
                                                                for (int i = 0;
                                                                    i <
                                                                        snapshot
                                                                            .docs
                                                                            .length;
                                                                    i++)
                                                                  DropdownMenuItem(
                                                                      value: snapshot
                                                                          .docs[
                                                                              i]
                                                                          .id,
                                                                      child: Text(
                                                                          snapshot.docs[i].get(
                                                                              'Thana'),
                                                                          maxLines:
                                                                              1))
                                                              ];
                                                              thanaValue = '';
                                                              districtName =
                                                                  temp[index];
                                                              setState(() {});
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            });
                                                          },
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(10.0),
                                                            child: Text(
                                                              temp[index],
                                                              style: TextStyle(
                                                                  fontSize: 18),
                                                            ),
                                                          ),
                                                        );
                                                      }),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              });
                            });
                      },
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(15)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                districtName,
                                style: const TextStyle(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w600),
                              ),
                              Icon(Icons.arrow_drop_down)
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Select Thana')),
                    const SizedBox(
                      height: 8,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(15)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: DropdownButton<String>(
                          isExpanded: true,
                          underline: Container(),
                          style: TextStyle(color: Colors.black87),
                          value: thanaValue,
                          items: droplist,
                          onChanged: (value) {
                            setState(() {
                              thanaValue = value!;
                            });
                            loadDetails();
                          },
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    isPolice
                        ? Container(
                            decoration: BoxDecoration(
                                color: Colors.blue.shade50,
                                borderRadius: BorderRadius.circular(15)),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 25, vertical: 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Divider(
                                  //   color: Colors.blue.shade800,
                                  //   thickness: 1,
                                  // ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  const Text(
                                    "Thana Details",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 15),
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Text(result.data()!['Thana'],
                                                style: TextStyle(
                                                    color: Colors.deepPurple,
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 18)),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                                "Designation: ${result.data()!['Designation']}",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 14)),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        width: 50,
                                        height: 50,
                                        decoration: BoxDecoration(
                                            color: Colors.deepPurple,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: IconButton(
                                            onPressed: () async {
                                              Position position =
                                                  await Geolocator
                                                      .getCurrentPosition();
                                              if (position != null) {
                                                http.Response r = await http.post(
                                                    Uri.parse(
                                                        "https://cutt.ly/api/api.php?key=${Config.access_token}&short=${Config.location}${position.latitude},${position.longitude}"),
                                                    headers: {
                                                      'Content-Type':
                                                          'application/json'
                                                    });
                                                var linkshort =
                                                    linkshortResponseFromJson(
                                                        r.body);
                                                print(
                                                    '${Config.location}${position.latitude},${position.longitude}');
                                                http.Response response =
                                                    await http.post(
                                                  Uri.parse(
                                                      'http://66.45.237.70/api.php?username=${Config.username}&password=${Config.password}&number=88${result.get('Mobile')}&message=Contact:${auth.currentUser!.phoneNumber} ${linkshort.url.shortLink}'),
                                                  // headers: {
                                                  //   'Content-Type':
                                                  //       'application/x-www-form-urlencoded'
                                                  // }
                                                );
                                                print(response.body);
                                                print(
                                                    'http://66.45.237.70/api.php?username=${Config.username}&password=${Config.password}&number=88${result.get('Mobile')}&message=Contact:${auth.currentUser!.phoneNumber}${Config.location}${position.latitude},${position.longitude}');

                                                showGeneralDialog(
                                                    context: context,
                                                    barrierDismissible: false,
                                                    pageBuilder:
                                                        (context, a, b) {
                                                      return Container();
                                                    },
                                                    transitionBuilder:
                                                        (context, a, b, child) {
                                                      return Transform.scale(
                                                          scale: a.value,
                                                          child: Dialog(
                                                              insetAnimationDuration:
                                                                  const Duration(
                                                                      milliseconds:
                                                                          500),
                                                              insetAnimationCurve:
                                                                  Curves
                                                                      .easeInBack,
                                                              insetPadding:
                                                                  const EdgeInsets
                                                                          .symmetric(
                                                                      horizontal:
                                                                          10),
                                                              shape: RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              15)),
                                                              child: Wrap(
                                                                crossAxisAlignment:
                                                                    WrapCrossAlignment
                                                                        .center,
                                                                alignment:
                                                                    WrapAlignment
                                                                        .center,
                                                                children: [
                                                                  Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      Padding(
                                                                        padding: const EdgeInsets.only(
                                                                            top:
                                                                                20,
                                                                            bottom:
                                                                                20,
                                                                            left:
                                                                                20,
                                                                            right:
                                                                                20),
                                                                        child: Column(
                                                                            children: [
                                                                              const Text(
                                                                                'Emergency',
                                                                                textAlign: TextAlign.center,
                                                                                style: TextStyle(color: Colors.deepPurple, fontSize: 16, fontWeight: FontWeight.w800),
                                                                              ),
                                                                              const SizedBox(
                                                                                height: 8,
                                                                              ),
                                                                              const Text('Your location has been sent to the police station', textAlign: TextAlign.center),
                                                                              const SizedBox(
                                                                                height: 10,
                                                                              ),
                                                                              ElevatedButton(
                                                                                onPressed: () {
                                                                                  Navigator.pop(context);
                                                                                },
                                                                                child: Text("OK"),
                                                                                style: ButtonStyle(shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)))),
                                                                              )
                                                                            ]),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              )));
                                                    });
                                              }
                                            },
                                            iconSize: 30,
                                            icon: const Icon(
                                              Icons.location_on,
                                              color: Colors.white,
                                            )),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Container(
                                        width: 50,
                                        height: 50,
                                        decoration: BoxDecoration(
                                            color: Colors.green,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: IconButton(
                                            onPressed: () {
                                              launchUrl(Uri.parse("tel://" +
                                                  result.get('Mobile')));
                                            },
                                            iconSize: 30,
                                            icon: const Icon(
                                              Icons.call,
                                              color: Colors.white,
                                            )),
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  ElevatedButton.icon(
                                      onPressed: () async {
                                        final XFile? video =
                                            await _picker.pickVideo(
                                                source: ImageSource.camera);
                                        if (video != null) {
                                          Overlay.of(context)!.insert(loader);
                                          await storage
                                              .ref('uploads/' +
                                                  video.name +
                                                  '.mp4')
                                              .putFile(File(video.path))
                                              .then((p0) async {
                                            String url =
                                                await p0.ref.getDownloadURL();
                                            print(url);
                                            http.Response ro = await http.post(
                                                Uri.parse(
                                                    "https://cutt.ly/api/api.php?key=${Config.access_token}&short=${Uri.encodeComponent(url)}"),
                                                headers: {
                                                  'Content-Type':
                                                      'application/json'
                                                });
                                            var vidLink =
                                                linkshortResponseFromJson(
                                                    ro.body);
                                            Position position = await Geolocator
                                                .getCurrentPosition();

                                            if (position != null) {
                                              http.Response r = await http.post(
                                                  Uri.parse(
                                                      "https://cutt.ly/api/api.php?key=${Config.access_token}&short=${Config.location}${position.latitude},${position.longitude}"),
                                                  headers: {
                                                    'Content-Type':
                                                        'application/json'
                                                  });
                                              var linkshort =
                                                  linkshortResponseFromJson(
                                                      r.body);
                                              http.Response response =
                                                  await http.post(
                                                      Uri.parse(
                                                          'http://66.45.237.70/api.php?username=${Config.username}&password=${Config.password}&number=88${result.get('Mobile')}&message=${vidLink.url.shortLink} ${linkshort.url.shortLink} Contact:${auth.currentUser!.phoneNumber}'),
                                                      headers: {
                                                    'Content-Type':
                                                        'application/x-www-form-urlencoded'
                                                  });
                                              print(response.body);
                                              print(
                                                  'http://66.45.237.70/api.php?username=${Config.username}&password=${Config.password}&number=88${result.get('Mobile')}&message=Contact:${auth.currentUser!.phoneNumber} ${Config.location}${position.latitude},${position.longitude}');
                                              loader.remove();
                                              showGeneralDialog(
                                                  context: context,
                                                  barrierDismissible: false,
                                                  pageBuilder: (context, a, b) {
                                                    return Container();
                                                  },
                                                  transitionBuilder:
                                                      (context, a, b, child) {
                                                    return Transform.scale(
                                                        scale: a.value,
                                                        child: Dialog(
                                                            insetAnimationDuration:
                                                                const Duration(
                                                                    milliseconds:
                                                                        500),
                                                            insetAnimationCurve:
                                                                Curves
                                                                    .easeInBack,
                                                            insetPadding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        10),
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            15)),
                                                            child: Wrap(
                                                              crossAxisAlignment:
                                                                  WrapCrossAlignment
                                                                      .center,
                                                              alignment:
                                                                  WrapAlignment
                                                                      .center,
                                                              children: [
                                                                Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                              .only(
                                                                          top:
                                                                              20,
                                                                          bottom:
                                                                              20,
                                                                          left:
                                                                              20,
                                                                          right:
                                                                              20),
                                                                      child: Column(
                                                                          children: [
                                                                            const Text(
                                                                              'Emergency',
                                                                              textAlign: TextAlign.center,
                                                                              style: TextStyle(color: Colors.deepPurple, fontSize: 16, fontWeight: FontWeight.w800),
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
                                                                              style: ButtonStyle(shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)))),
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

                                        //       final XFile? photo = await _picker
                                        //           .pickImage(source: ImageSource.camera);
                                        //       if (photo != null) {
                                        //         Overlay.of(context)!.insert(loader);
                                        //         await storage
                                        //             .ref('uploads/' + photo.name + '.jpg')
                                        //             .putFile(
                                        //               File(photo.path),
                                        //             )
                                        //             .then((p0) async {
                                        //           String url =
                                        //               await p0.ref.getDownloadURL();
                                        //           print(Uri.encodeComponent(url));

                                        //           http.Response ro = await http.post(
                                        //               Uri.parse(
                                        //                   "https://cutt.ly/api/api.php?key=${Config.access_token}&short=${Uri.encodeComponent(url)}"),
                                        //               headers: {
                                        //                 'Content-Type': 'application/json'
                                        //               });
                                        //           var imgLink =
                                        //               linkshortResponseFromJson(ro.body);
                                        //           Position position = await Geolocator
                                        //               .getCurrentPosition();
                                        //           if (position != null) {
                                        //             http.Response r = await http.post(
                                        //                 Uri.parse(
                                        //                     "https://cutt.ly/api/api.php?key=${Config.access_token}&short=${Config.location}${position.latitude},${position.longitude}"),
                                        //                 headers: {
                                        //                   'Content-Type':
                                        //                       'application/json'
                                        //                 });
                                        //             var linkshort =
                                        //                 linkshortResponseFromJson(r.body);
                                        //             print("Image link: " +
                                        //                 imgLink.url.shortLink);
                                        //             http.Response response = await http.post(
                                        //                 Uri.parse(
                                        //                     'http://66.45.237.70/api.php?username=${Config.username}&password=${Config.password}&number=88${result.get('Mobile')}&message=${imgLink.url.shortLink} ${linkshort.url.shortLink} Contact:${auth.currentUser!.phoneNumber}'),
                                        //                 headers: {
                                        //                   'Content-Type':
                                        //                       'application/x-www-form-urlencoded'
                                        //                 });
                                        //             print(response.body);
                                        //             print(
                                        //                 'http://66.45.237.70/api.php?username=${Config.username}&password=${Config.password}&number=88${result.get('Mobile')}&message=Contact:${auth.currentUser!.phoneNumber} ${linkshort.url.shortLink}');
                                        //             loader.remove();
                                        //             showAnimatedDialog(
                                        //                 context: context,
                                        //                 builder: (context) {
                                        //                   return CustomDialogWidget(
                                        //                     title: Text(
                                        //                       'Your location has been sent to the police station',
                                        //                       textAlign: TextAlign.center,
                                        //                     ),
                                        //                     content: Wrap(
                                        //                       children: [
                                        //                         Container(
                                        //                           child: Center(
                                        //                             child: ElevatedButton(
                                        //                               child: Text('Ok'),
                                        //                               onPressed: () {
                                        //                                 Navigator.pop(
                                        //                                     context);
                                        //                               },
                                        //                             ),
                                        //                           ),
                                        //                         ),
                                        //                       ],
                                        //                     ),
                                        //                   );
                                        //                 });
                                        //           }
                                        //         });
                                        //       }
                                        //     },
                                        //     style: ButtonStyle(
                                        //         backgroundColor:
                                        //             MaterialStateProperty.all(
                                        //                 Colors.deepPurple),
                                        //         minimumSize: MaterialStateProperty.all(
                                        //             const Size(double.infinity, 45))),
                                        //     icon: Icon(Icons.camera_alt_outlined),
                                        //     label:
                                        //         Text("Send Image Evidence & Location")),
                                        // const SizedBox(
                                        //   height: 5,
                                        // ),
                                        // ElevatedButton.icon(
                                        //     onPressed: () async {
                                        //
                                      },
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  Colors.blueAccent),
                                          shape: MaterialStateProperty.all(
                                              RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15))),
                                          minimumSize:
                                              MaterialStateProperty.all(
                                                  const Size(
                                                      double.infinity, 45))),
                                      icon: Icon(Icons.camera_alt_outlined),
                                      label: Text(
                                          "Send Video Evidence & Location")),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                ],
                              ),
                            ),
                          )
                        : Container(),
                  ],
                ),
              ),
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
