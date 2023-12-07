import 'package:child_abuse_prevention/src/utils/colors.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';

class HowTo extends StatefulWidget {
  const HowTo({super.key});

  @override
  State<HowTo> createState() => _HowToState();
}

class _HowToState extends State<HowTo> {
  List<ExpandableController> controller = [
    ExpandableController(),
    ExpandableController(),
    ExpandableController(),
    ExpandableController()
  ];
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
          "App Guide",
          style: TextStyle(color: Get.isDarkMode ? Colors.white : Colours.dark),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "How to\nUse the App",
                    style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 28),
                  ),
                  Image.asset("assets/images/help.png",height: 70)
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: ExpandablePanel(
                    header: const Text(
                      "Abuse Detection",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 18),
                    ),
                    expanded: Text(
                      "1. Click the Abuse Detection from home\n2. Answer necessary questions\n3. Then Submit. It will detect what kind of abuse you might have faced.",
                      softWrap: true,
                      style: TextStyle(fontSize: 16),
                    ),
                    controller: controller[0],
                    collapsed: Container(),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: ExpandablePanel(
                    header: const Text(
                      "Instant Help Guide",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 18),
                    ),
                    expanded: Text(
                      "1. Search nearby police station by providing District and Thana information.\n2. To call, click on the call icon\n3. If you want to send an evidence to nearby police station, select your evidence from file menu, and upload it and send with your location.",
                      softWrap: true,
                      style: TextStyle(fontSize: 16),
                    ),
                    controller: controller[1],
                    collapsed: Container(),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: ExpandablePanel(
                    header: const Text(
                      "Legal Aid",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 18),
                    ),
                    expanded: const Text(
                      "1. Legal Aid feature presents law and regulations which might be necessary for child abuse prevention. \n2. By clicking the law, you can find the neccesary details regarding the law.\n",
                      softWrap: true,
                      style: TextStyle(fontSize: 16),
                    ),
                    controller: controller[2],
                    collapsed: Container(),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: ExpandablePanel(
                    header: const Text(
                      "Immediate Help",
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 18),
                    ),
                    expanded: const Text(
                      "1. Shake your mobile in case of emergency situation. It will send your location to your local gurdiance. \n2. You can seek help from home menu also by holding help button.\n3. You can also use overlay optio to take immediate action which can be enable from settings. ",
                      softWrap: true,
                      style: TextStyle(fontSize: 16),
                    ),
                    controller: controller[3],
                    collapsed: Container(),
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
