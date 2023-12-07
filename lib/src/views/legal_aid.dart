import 'package:child_abuse_prevention/src/model/legal_data.dart';
import 'package:child_abuse_prevention/src/utils/colors.dart';
import 'package:child_abuse_prevention/src/views/legal_aid_details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';

class LegalAid extends StatefulWidget {
  const LegalAid({super.key});

  @override
  State<LegalAid> createState() => _LegalAidState();
}

class _LegalAidState extends State<LegalAid> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  List<LegalData> data = [];
  bool isLoaded = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
  }

  void fetchData() async {
    await db.collection("legalaid").get().then((value) {
      value.docs.forEach((element) {
        data.add(LegalData(
            title: element.data()['title'],
            desc: element.data()['desc'],
            image: element.data()['image']));
      });
      setState(() {
        isLoaded = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 200,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/kids.jpg"),
                      opacity: 0.1,
                      fit: BoxFit.cover),
                  color: Colors.blue.shade200,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15))),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Legal Aid",
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w800,
                          color: Colors.white),
                    ),
                    Text(
                      "Find out what the law says",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
              child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.keyboard_arrow_left)),
            )
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        isLoaded
            ? Expanded(
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: data.length,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemBuilder: (context, int index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        LegalAidDetails(data: data[index])));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.blue.shade50,
                                borderRadius: BorderRadius.circular(15)),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 5),
                              child: Row(
                                children: [
                                  Container(
                                      clipBehavior: Clip.antiAlias,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      child: Image.network(
                                        data[index].image,
                                        width: 60,
                                        height: 70,
                                        fit: BoxFit.cover,
                                      )),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "  ${data[index].title}",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black,
                                              fontSize: 17),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        
                                        Html(
                                          data: data[index].desc,
                                          style: {
                                            'b': Style(
                                                fontWeight: FontWeight.w700),
                                            'p': Style(
                                                maxLines: 2,
                                                fontSize: FontSize.medium,
                                                textOverflow:
                                                    TextOverflow.ellipsis,
                                                color: Colors.black87,
                                                textAlign: TextAlign.justify),
                                          },
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
              )
            : Expanded(child: Center(child: CircularProgressIndicator()))
      ],
    ));
  }
}
