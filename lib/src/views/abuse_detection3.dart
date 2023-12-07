import 'package:child_abuse_prevention/src/utils/colors.dart';
import 'package:child_abuse_prevention/src/utils/model.dart';
import 'package:child_abuse_prevention/src/views/abuse_learn.dart';
import 'package:child_abuse_prevention/src/views/analysis.dart';
import 'package:child_abuse_prevention/src/views/legal_aid.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:group_radio_button/group_radio_button.dart';

class AbuseDetection3 extends StatefulWidget {
  const AbuseDetection3({super.key, required this.inputs});
  final List<double> inputs;

  @override
  State<AbuseDetection3> createState() => _AbuseDetection3State();
}

class _AbuseDetection3State extends State<AbuseDetection3> {
  List<double> inputs = [];
  Map<int, String> answer = {1: "Yes", 0: "No"};
  int maxIndex = -1;
  @override
  void initState() {
    super.initState();
    inputs = widget.inputs;
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
      bottomSheet: Container(
        color: Get.isDarkMode ? Colors.black26 : Colors.white,
        height: 70,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 9),
          child: ElevatedButton(
            onPressed: () {
              List<double> answer = Model().score(inputs);
              String violance = "";
              double max = -10000;
              maxIndex = -1;
              for (int i = 0; i < answer.length; i++) {
                if (answer[i] > max) {
                  max = answer[i];
                  maxIndex = i;
                }
              }
              if (maxIndex == 2) {
                violance = "Physical";
              } else if (maxIndex == 0) {
                violance = "Emotional";
              } else if (maxIndex == 1) {
                violance = "Neglect";
              } else if (maxIndex == 3) {
                violance = "Sexual";
              }
              showResult(violance);
              print(answer);
            },
            child: Text(
              "Detect",
              style: TextStyle(
                  color: Colors.blue.shade900, fontWeight: FontWeight.w900),
            ),
            style: ButtonStyle(
                elevation: MaterialStateProperty.all(0),
                backgroundColor:
                    MaterialStateProperty.all(Colors.blue.shade100),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                      side: BorderSide(color: Colors.blue.shade900)),
                ),
                minimumSize:
                    MaterialStateProperty.all(const Size(double.infinity, 55))),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Do you have unrest or issues in your family?",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.55,
                child: RadioGroup<double>.builder(
                  groupValue: inputs[14],
                  onChanged: (value) => setState(() {
                    print(value);
                    inputs[14] = value!;
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
                "Are you afraid of any person owing to what happened?",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.55,
                child: RadioGroup<double>.builder(
                  groupValue: inputs[15],
                  onChanged: (value) => setState(() {
                    print(value);
                    inputs[15] = value!;
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
                "Are you provided with sufficient nutritious food?",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.55,
                child: RadioGroup<double>.builder(
                  groupValue: inputs[16],
                  onChanged: (value) => setState(() {
                    print(value);
                    inputs[16] = value!;
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
                "Do you receive proper healthcare?",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.55,
                child: RadioGroup<double>.builder(
                  groupValue: inputs[17],
                  onChanged: (value) => setState(() {
                    print(value);
                    inputs[17] = value!;
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
                "Do have proper living conditions?",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.55,
                child: RadioGroup<double>.builder(
                  groupValue: inputs[18],
                  onChanged: (value) => setState(() {
                    print(value);
                    inputs[18] = value!;
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
                "Are you provided with sufficient supervision?",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.55,
                child: RadioGroup<double>.builder(
                  groupValue: inputs[19],
                  onChanged: (value) => setState(() {
                    print(value);
                    inputs[19] = value!;
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

  showResult(String v) {
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
                  backgroundColor: Colors.white,
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
                              Text(
                                'Abuse Detected!!!',
                                style: TextStyle(
                                    color: Colors.blue.shade800,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w700),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Image.asset(
                                "assets/images/" + v + ".jpg",
                                height: 150,
                              ),
                              Text(v + " Abuse",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.red.shade700,
                                      fontSize: 17,
                                      fontWeight: FontWeight.w800)),
                              const SizedBox(
                                height: 10,
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const LegalAid()));
                                },
                                child: Text("Check About Legal Help",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w600)),
                                style: ButtonStyle(
                                    minimumSize: MaterialStateProperty.all(
                                        const Size(200, 45)),
                                    shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15)))),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              AbuseLearn(index: maxIndex)));
                                },
                                child: Text(
                                  "Possible Measures",
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        Colors.deepPurple.shade900),
                                    minimumSize: MaterialStateProperty.all(
                                        const Size(200, 45)),
                                    shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15)))),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Analysis(
                                                inputs: inputs,
                                                isNeglect: v=="Neglect",
                                              )));
                                },
                                child: Text(
                                  "Result Analysis",
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        Colors.green.shade700),
                                    minimumSize: MaterialStateProperty.all(
                                        const Size(200, 45)),
                                    shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15)))),
                              ),
                            ]),
                          ),
                        ],
                      ),
                    ],
                  )));
        });
  }
}
