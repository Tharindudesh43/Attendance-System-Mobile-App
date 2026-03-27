import 'package:attendance_system_flutter_application/Providers/riverpod.dart';
import 'package:attendance_system_flutter_application/Services/Firebase_Services.dart';
import 'package:attendance_system_flutter_application/Widgets/History_Card.dart';
import 'package:attendance_system_flutter_application/Widgets/Report_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class HistoryPage extends ConsumerStatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  ConsumerState<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends ConsumerState<HistoryPage> {
  bool isclicked = false;

  @override
  void initState() {
    super.initState();
    ref.refresh(userHistoryProvider);
    ref.refresh(userreportProvider);
  }

  @override
  Widget build(BuildContext context) {
    final ref = this.ref;
    final history = ref.watch(userHistoryProvider);
    final report = ref.watch(userreportProvider);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                const SizedBox(height: 10),
                InkWell(
                  onTap: () {
                    setState(() {
                      isclicked = false;
                    });
                  },
                  child: Container(
                    width: 130,
                    height: 35,
                    decoration: BoxDecoration(
                      color: isclicked == false
                          ? const Color.fromARGB(237, 255, 255, 255)
                          : Colors.grey.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Center(
                      child: Text(
                        "Attendace",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: isclicked == false
                              ? const Color.fromARGB(255, 0, 0, 0)
                              : const Color.fromARGB(255, 255, 255, 255),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Column(
              children: [
                const SizedBox(height: 10),
                InkWell(
                  onTap: () {
                    setState(() {
                      isclicked = true;
                    });
                  },
                  child: Container(
                    width: 130,
                    height: 35,
                    decoration: BoxDecoration(
                      color: isclicked == false
                          ? Colors.grey.withOpacity(0.5)
                          : const Color.fromARGB(237, 255, 255, 255),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Center(
                      child: Text(
                        "Reports",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: isclicked == false
                              ? const Color.fromARGB(255, 255, 255, 255)
                              : const Color.fromARGB(255, 0, 0, 0),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 5),
        //change to flases
        isclicked == false
            ? Expanded(
                child: Container(
                  color: Colors.transparent,
                  child: history.when(
                    data: (itemList) {
                      if (itemList.isEmpty) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 50),
                            child: Text(
                              "No Attendance History Data!",
                              style: TextStyle(
                                fontSize: 20,
                                color: Color.fromRGBO(2, 109, 148, 1),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        );
                      }

                      return SingleChildScrollView(
                        child: Column(
                          children: [
                            // other widgets
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: itemList.length,
                              reverse: true,
                              itemBuilder: (context, index) {
                                final item = itemList[index];
                                return HistoryCard(
                                  rating: item['rating'] ?? '',
                                  topic: item['topic'] ?? '',
                                  topicdescription:
                                      item['topicdescription'] ?? '',
                                  subject: item['subject'] ?? '',
                                  year: item['year'] ?? '',
                                  semester: item['semester'] ?? '',
                                  date: item['date'] ?? '',
                                  time: item['time'] ?? '',
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    },
                    loading: () => const Center(
                      child: SpinKitThreeBounce(color: Colors.blue, size: 30.0),
                    ),
                    error: (e, st) => Center(child: Text("Error: $e")),
                  ),
                ),
              )
            : Expanded(
                child: Container(
                  color: Colors.transparent,
                  child: report.when(
                    data: (itemList) {
                      if (itemList.isEmpty) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 50),
                            child: Text(
                              "No Report History Data!",
                              style: TextStyle(
                                fontSize: 20,
                                color: Color.fromRGBO(2, 109, 148, 1),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        );
                      }

                      return SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                report_type_identifier(type: "Watching"),
                                report_type_identifier(type: "Not Watched"),
                                report_type_identifier(type: "Mark as Done"),
                              ],
                            ),
                            // other widgets
                            ListView.builder(
                              shrinkWrap: true,
                              physics:
                                  NeverScrollableScrollPhysics(), // ✅ keep this ONLY if parent scrolls
                              itemCount: itemList.length,
                              reverse: true,
                              itemBuilder: (context, index) {
                                final item = itemList[index];
                                return ReportCard(
                                  reportId: item['report_id']?.toString() ?? '',
                                  title: item['title']?.toString() ?? '',
                                  description:
                                      item['description']?.toString() ?? '',
                                  status: item['status']?.toString() ?? '',
                                  date: item['date']?.toString() ?? '',
                                  time: item['time']?.toString() ?? '',
                                  student_email:
                                      item['student_email']?.toString() ?? '',
                                  images: item['images'] ?? [],
                                  report_type:
                                      item['report_type']?.toString() ?? '',
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    },
                    loading: () => const Center(
                      child: SpinKitThreeBounce(color: Colors.blue, size: 30.0),
                    ),
                    error: (e, st) => Center(child: Text("Error: $e")),
                  ),
                ),
              ),
      ],
    );
  }

  Padding report_type_identifier({required String type}) {
    return Padding(
      padding: const EdgeInsets.only(top: 7),
      child: Container(
        padding: EdgeInsets.only(left: 10, right: 10, top: 7, bottom: 7),
        // height: 30,
        decoration: BoxDecoration(
          border: Border.all(
            color: const Color.fromARGB(255, 85, 177, 219),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  color: type == "Not Watched"
                      ? Colors.grey
                      : type == "Watching"
                      ? const Color.fromARGB(255, 252, 228, 3)
                      : const Color.fromARGB(255, 0, 255, 0),
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
            ),
            Center(
              child: Text(
                type,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
