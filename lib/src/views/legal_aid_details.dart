import 'dart:convert';

import 'package:child_abuse_prevention/src/model/legal_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_html/flutter_html.dart';

class LegalAidDetails extends StatefulWidget {
  const LegalAidDetails({super.key, required this.data});
  final LegalData data;

  @override
  State<LegalAidDetails> createState() => _LegalAidDetailsState();
}

class _LegalAidDetailsState extends State<LegalAidDetails> {
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
                      image: NetworkImage(widget.data.image),
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
                      widget.data.title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w800,
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
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
            child: ListView(
              shrinkWrap: true,
              children: [
                Html(
                  data: widget.data.desc,
                  style: {
                    'b': Style(fontWeight: FontWeight.w700),
                    'p': Style(
                        fontSize: FontSize.medium,
                        textAlign: TextAlign.justify),
                  },
                )
              ],
            ),
          ),
        ),
      ],
    ));
  }
}
