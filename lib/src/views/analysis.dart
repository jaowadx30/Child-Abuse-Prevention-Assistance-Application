import 'package:child_abuse_prevention/src/utils/colors.dart';
import 'package:child_abuse_prevention/src/utils/data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pie_chart/pie_chart.dart';

class Analysis extends StatefulWidget {
  const Analysis({super.key, required this.inputs, this.isNeglect = false});
  final List<double> inputs;
  final bool isNeglect;

  @override
  State<Analysis> createState() => _AnalysisState();
}

class _AnalysisState extends State<Analysis> {
  Map<String, double> dataMap = {
    "Yes": 5,
    "No": 9,
  };
  List<String> answer = [];
  bool isLoaded = false;
  @override
  void initState() {
    super.initState();
    createGraph();
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
          "Result Analysis",
          style: TextStyle(color: Get.isDarkMode ? Colors.white : Colours.dark),
        ),
      ),
      body: SingleChildScrollView(
        child: isLoaded
            ? Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  PieChart(
                    dataMap: dataMap,
                    totalValue: 19,
                    animationDuration: const Duration(milliseconds: 800),
                    chartLegendSpacing: 32,
                    chartRadius: MediaQuery.of(context).size.width / 3.2,
                    colorList: const [Colors.deepPurple, Colors.blue],
                    initialAngleInDegree: 0,
                    chartType: ChartType.ring,
                    ringStrokeWidth: 32,
                    centerText: "Responses",
                    legendOptions: const LegendOptions(
                      showLegendsInRow: false,
                      legendPosition: LegendPosition.right,
                      showLegends: true,
                      legendShape: BoxShape.circle,
                      legendTextStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    chartValuesOptions: const ChartValuesOptions(
                      showChartValueBackground: true,
                      showChartValues: true,
                      showChartValuesInPercentage: true,
                      showChartValuesOutside: false,
                      decimalPlaces: 1,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    widget.isNeglect ? "Answered No:" : "Answered Yes:",
                    style: TextStyle(
                        color: widget.isNeglect
                            ? Colors.red.shade700
                            : Colors.green.shade700,
                        fontWeight: FontWeight.w700,
                        fontSize: 20),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: answer.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Get.isDarkMode
                                        ? Colors.blue
                                        : Colors.blue.shade50),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  child: Text(
                                    "${index + 1}. " + answer[index],
                                    style: const TextStyle(fontSize: 17),
                                  ),
                                )),
                          );
                        }),
                  ),
                ],
              )
            : CircularProgressIndicator(),
      ),
    );
  }

  createGraph() {
    double y = 0;
    double n = 0;
    for (int i = 1; i < widget.inputs.length; i++) {
      if (widget.inputs[i] == 1) {
        answer.add(Dummy.questions[i]);
        y++;
      } else {
        n++;
      }
    }
    if (widget.isNeglect) {
      answer.clear();
      if (widget.inputs[8] == 0) {
        answer.add(Dummy.questions[8]);
      }
      if (widget.inputs[16] == 0) {
        answer.add(Dummy.questions[16]);
      }
      if (widget.inputs[17] == 0) {
        answer.add(Dummy.questions[17]);
      }
      if (widget.inputs[18] == 0) {
        answer.add(Dummy.questions[18]);
      }
      if (widget.inputs[19] == 0) {
        answer.add(Dummy.questions[19]);
      }
    }
    dataMap = {"Yes": y, "No": n};
    setState(() {
      isLoaded = true;
    });
  }
}
