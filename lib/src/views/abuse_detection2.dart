import 'package:child_abuse_prevention/src/utils/colors.dart';
import 'package:child_abuse_prevention/src/views/abuse_detection3.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:group_radio_button/group_radio_button.dart';

class AbuseDetection2 extends StatefulWidget {
  const AbuseDetection2({super.key, required this.inputs});
  final List<double> inputs;

  @override
  State<AbuseDetection2> createState() => _AbuseDetection2State();
}

class _AbuseDetection2State extends State<AbuseDetection2> {
  List<double> inputs = [];
  Map<int, String> gender = {0: "Male", 1: "Female"};
  Map<int, String> answer = {1: "Yes", 0: "No"};
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
        height: 60,
        child: Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 9),
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                AbuseDetection3(inputs: inputs)));
                  },
                  child: Text("Next")),
            )),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Have you been the subject of boycott or isolation?",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.55,
                child: RadioGroup<double>.builder(
                  groupValue: inputs[7],
                  onChanged: (value) => setState(() {
                    print(value);
                    inputs[7] = value!;
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
                "Is proper hygiene being ensured where you live?",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.55,
                child: RadioGroup<double>.builder(
                  groupValue: inputs[8],
                  onChanged: (value) => setState(() {
                    print(value);
                    inputs[8] = value!;
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
                "Were you choked?",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.55,
                child: RadioGroup<double>.builder(
                  groupValue: inputs[9],
                  onChanged: (value) => setState(() {
                    print(value);
                    inputs[9] = value!;
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
                "Did anyone make any sexual advancements towards you?",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.55,
                child: RadioGroup<double>.builder(
                  groupValue: inputs[10],
                  onChanged: (value) => setState(() {
                    print(value);
                    inputs[10] = value!;
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
                "Were you insulted?",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.55,
                child: RadioGroup<double>.builder(
                  groupValue: inputs[11],
                  onChanged: (value) => setState(() {
                    print(value);
                    inputs[11] = value!;
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
                "Have you been teased?",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.55,
                child: RadioGroup<double>.builder(
                  groupValue: inputs[12],
                  onChanged: (value) => setState(() {
                    print(value);
                    inputs[12] = value!;
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
                "Were you restrained physically?",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.55,
                child: RadioGroup<double>.builder(
                  groupValue: inputs[13],
                  onChanged: (value) => setState(() {
                    print(value);
                    inputs[13] = value!;
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
