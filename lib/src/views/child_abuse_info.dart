import 'package:child_abuse_prevention/src/model/police_data.dart';
import 'package:child_abuse_prevention/src/utils/colors.dart';
import 'package:child_abuse_prevention/src/utils/data.dart';
import 'package:child_abuse_prevention/src/views/instant_help.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChildAbuseInfo extends StatefulWidget {
  const ChildAbuseInfo({super.key, required this.polices});
  final List<Police> polices;

  @override
  State<ChildAbuseInfo> createState() => _ChildAbuseInfoState();
}

class _ChildAbuseInfoState extends State<ChildAbuseInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          ElevatedButton(
              onPressed: () {},
              child: Text("Do you think someone is being abused?")),
          ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            InstantHelp(polices: widget.polices)));
              },
              child: Text("Seek Instant Help")),
        ],
      ),
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
          "What is Child Abuse?",
          style: TextStyle(color: Get.isDarkMode ? Colors.white : Colours.dark),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Types of Child Abuse",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              Text(
                Dummy.types,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "Physical Abuse:",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
              ),
              Text(
                Dummy.physical,
                textAlign: TextAlign.justify,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "Sexual Abuse:",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
              ),
              Text(
                Dummy.sexual,
                textAlign: TextAlign.justify,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "Emotional abuse:",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
              ),
              Text(
                Dummy.emotional,
                textAlign: TextAlign.justify,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "Neglect:",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
              ),
              Text(
                Dummy.neglect,
                textAlign: TextAlign.justify,
              ),
              Text(
                "Effects of Child Abuse",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                Dummy.effect,
                textAlign: TextAlign.justify,
              ),
              const SizedBox(
                height: 100,
              )
            ],
          ),
        ),
      ),
    );
  }
}
