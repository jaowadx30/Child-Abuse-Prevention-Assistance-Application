import 'package:child_abuse_prevention/src/model/police_data.dart';
import 'package:child_abuse_prevention/src/views/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CreateUser extends StatefulWidget {
  const CreateUser({Key? key, required this.polices}) : super(key: key);
  final List<Police> polices;

  @override
  State<CreateUser> createState() => _CreateUserState();
}

class _CreateUserState extends State<CreateUser> {
  List gender = ["Male", "Female"];
  String? _value = "Male";
  TextEditingController name = TextEditingController();
  TextEditingController age = TextEditingController();
  TextEditingController birthNo = TextEditingController();
  TextEditingController rescue = TextEditingController();
  FirebaseFirestore db = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "Add Profile Information",
          style: TextStyle(fontSize: 18, color: Colors.blue),
        ),
      ),
      bottomSheet: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ElevatedButton(
            onPressed: () async {
              if (name.value.text.isEmpty) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text("Invalid Name")));
              } else if (age.value.text.isEmpty) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text("Invalid Age")));
              } else if (rescue.value.text.isEmpty ||
                  rescue.value.text.length != 11) {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Invalid Mobile Number")));
              } else {
                await db.collection("users").doc(auth.currentUser!.uid).set({
                  "name": name.value.text,
                  "age": age.value.text,
                  "gender": _value,
                  "birth": birthNo.value.text,
                  "rescue": rescue.value.text,
                  "image": "",
                }).then((value) {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Home(
                                polices: widget.polices,
                              )),
                      (route) => false);
                });
              }
            },
            child: Text("Continue"),
            style: ButtonStyle(
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20))),
                minimumSize:
                    MaterialStateProperty.all(const Size(double.infinity, 50)),
                backgroundColor: MaterialStateProperty.all(Colors.blue)),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 10,
              ),
              Text(
                "Your Name (Required)",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
              const SizedBox(
                height: 9,
              ),
              TextField(
                controller: name,
                decoration: InputDecoration(
                    isDense: true,
                    hintText: "Full Name",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide())),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "Age (Required)",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
              const SizedBox(
                height: 9,
              ),
              TextField(
                controller: age,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    hintText: "years",
                    isDense: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide())),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "Birth Certificate No",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
              const SizedBox(
                height: 9,
              ),
              TextField(
                controller: birthNo,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    hintText: "------------",
                    isDense: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide())),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "Gender",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
              const SizedBox(
                height: 9,
              ),
              for (int i = 1; i <= 2; i++)
                ListTile(
                  title: Text(
                    gender[i - 1],
                  ),
                  leading: Radio<String>(
                    value: gender[i - 1],
                    groupValue: _value,
                    activeColor: const Color.fromARGB(255, 45, 17, 254),
                    onChanged: (value) {
                      setState(() {
                        _value = value;
                      });
                    },
                  ),
                ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "Emergency Contact Number",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
              const SizedBox(
                height: 9,
              ),
              TextField(
                controller: rescue,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                    hintText: "01*********",
                    isDense: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide())),
              ),
              const SizedBox(
                height: 60,
              )
            ],
          ),
        ),
      ),
    );
  }
}
