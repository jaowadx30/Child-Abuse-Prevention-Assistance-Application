import 'package:child_abuse_prevention/src/utils/colors.dart';
import 'package:child_abuse_prevention/src/views/abuse_detection2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:group_radio_button/group_radio_button.dart';

class AbuseDetection extends StatefulWidget {
  const AbuseDetection({super.key});

  @override
  State<AbuseDetection> createState() => _AbuseDetectionState();
}

class _AbuseDetectionState extends State<AbuseDetection> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  List<double> inputs = List.filled(20, 0);
  TextEditingController ageCon = TextEditingController();
  Map<int, String> gender = {1: "Male", 0: "Female"};
  Map<int, String> answer = {1: "Yes", 0: "No"};
  @override
  void initState() {
    super.initState();
    //getUserData();
  }

  Future getUserData() async {
    await db.collection("users").doc(auth.currentUser!.uid).get().then((value) {
      inputs[0] = double.parse(value.data()!['age']);
      inputs[1] = value.data()!['gender'] == 'Male' ? 0 : 1.0;
    });
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
          "Child Abuse Detection",
          style: TextStyle(color: Get.isDarkMode ? Colors.white : Colours.dark),
        ),
      ),
      bottomNavigationBar: SizedBox(
        height: 60,
        child: Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
              child: ElevatedButton(
                  onPressed: () {
                    if (ageCon.value.text.isEmpty ||
                        double.parse(ageCon.value.text) > 18 ||
                        double.parse(ageCon.value.text) < 0) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text("Please Enter Age Below 18")));
                    } else {
                      inputs[0] = double.parse(ageCon.value.text);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (contex) =>
                                  AbuseDetection2(inputs: inputs)));
                    }
                  },
                  child: const Text("Next")),
            )),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 10,
              ),
              const Text(
                "Please Enter Your Age",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
              const SizedBox(
                height: 7,
              ),
              TextField(
                controller: ageCon,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    isDense: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    )),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "Select Gender",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.55,
                child: RadioGroup<double>.builder(
                  groupValue: inputs[1],
                  onChanged: (value) => setState(() {
                    print(value);
                    inputs[1] = value!;
                  }),
                  direction: Axis.horizontal,
                  items: [0, 1],
                  itemBuilder: (item) => RadioButtonBuilder(
                    gender[item]!,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "Were you assaulted?",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.55,
                child: RadioGroup<double>.builder(
                  groupValue: inputs[2],
                  onChanged: (value) => setState(() {
                    print(value);
                    inputs[2] = value!;
                  }),
                  direction: Axis.horizontal,
                  items: [0, 1],
                  itemBuilder: (item) => RadioButtonBuilder(
                    answer[item]!,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "Were you yelled at?",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.55,
                child: RadioGroup<double>.builder(
                  groupValue: inputs[3],
                  onChanged: (value) => setState(() {
                    print(value);
                    inputs[3] = value!;
                  }),
                  direction: Axis.horizontal,
                  items: [0, 1],
                  itemBuilder: (item) => RadioButtonBuilder(
                    answer[item]!,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "Do you have any burns or cuts due to the assault?",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.55,
                child: RadioGroup<double>.builder(
                  groupValue: inputs[4],
                  onChanged: (value) => setState(() {
                    print(value);
                    inputs[4] = value!;
                  }),
                  direction: Axis.horizontal,
                  items: [0, 1],
                  itemBuilder: (item) => RadioButtonBuilder(
                    answer[item]!,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "Were you pressurized to do something?",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.55,
                child: RadioGroup<double>.builder(
                  groupValue: inputs[5],
                  onChanged: (value) => setState(() {
                    print(value);
                    inputs[5] = value!;
                  }),
                  direction: Axis.horizontal,
                  items: [0, 1],
                  itemBuilder: (item) => RadioButtonBuilder(
                    answer[item]!,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "Are you experiencing sleep disturbances?",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.55,
                child: RadioGroup<double>.builder(
                  groupValue: inputs[6],
                  onChanged: (value) => setState(() {
                    print(value);
                    inputs[6] = value!;
                  }),
                  direction: Axis.horizontal,
                  items: [0, 1],
                  itemBuilder: (item) => RadioButtonBuilder(
                    answer[item]!,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
