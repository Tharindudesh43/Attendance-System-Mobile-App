// ignore: file_names
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class SubjectAttendancePie extends StatefulWidget {
  final String subjectName;
  final int attended;
  final int absent;

  const SubjectAttendancePie({
    super.key,
    required this.subjectName,
    required this.attended,
    required this.absent,
  });

  @override
  State<SubjectAttendancePie> createState() => _SubjectAttendancePieState();
}

class _SubjectAttendancePieState extends State<SubjectAttendancePie> {
  @override
  Widget build(BuildContext context) {
    final total = widget.attended + widget.absent;
    final percent = total == 0
        ? 0
        : (widget.attended / total * 100).toStringAsFixed(1);

    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 20, bottom: 25, right: 10),
      child: Container(
        width: 250,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 233, 236, 215),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Pie Chart
              SizedBox(
                height: 150,
                child: PieChart(
                  PieChartData(
                    sections: [
                      PieChartSectionData(
                        value: widget.attended.toDouble(),
                        color: const Color.fromARGB(255, 65, 218, 195),
                        title: "$percent%",
                        titleStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                          color: Color.fromARGB(255, 19, 19, 19),
                        ),
                        radius: 40,
                      ),
                      PieChartSectionData(
                        value: widget.absent.toDouble(),
                        color: const Color.fromARGB(255, 239, 102, 102),
                        title: "",
                        radius: 35,
                      ),
                    ],
                    centerSpaceRadius: 30,
                    sectionsSpace: 2,
                  ),
                ),
              ),
              Text(
                widget.subjectName,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 5),
              // Legend
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _legendItem(
                    color: const Color.fromARGB(255, 65, 218, 139),
                    text: "Marked: ${widget.attended}",
                  ),
                  _legendItem(
                    color: const Color.fromARGB(255, 239, 102, 102),
                    text: "Not Marked: ${widget.absent}",
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _legendItem({required Color color, required String text}) {
    return Row(
      children: [
        Container(
          height: 18,
          width: 15,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
