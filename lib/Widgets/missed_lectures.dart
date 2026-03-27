import 'package:flutter/material.dart';


class MissedLectures extends StatefulWidget {
  String? subject;
  String? year;
  String? semester;
  String? date;
  String? time;
  MissedLectures({
    super.key,
    required this.subject,
    required this.year,
    required this.semester,
    required this.date,
    required this.time,
  });

  @override
  State<MissedLectures> createState() => _MissedLecturesState();
}

class _MissedLecturesState extends State<MissedLectures> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        width: 190,
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 232, 225, 149),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: Colors.black12, blurRadius: 6, spreadRadius: 1),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 6,
              height: 70,
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.subject!,
                    style: TextStyle(
                      color: Colors.red.withOpacity(0.8),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    widget.year!,
                    style: TextStyle(
                      color: Colors.red.withOpacity(0.8),
                      fontSize: 12,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.semester!,
                        style: TextStyle(
                          color: Colors.red.withOpacity(0.8),
                          fontSize: 12,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      SizedBox(width: 95),
                      Icon(
                        Icons.missed_video_call_sharp,
                        size: 30,
                        color: Colors.red,
                      ),
                    ],
                  ),
                  SizedBox(height: 6),
                  Row(
                    key: widget.key,
                    children: [
                      Icon(
                        Icons.date_range_rounded,
                        size: 14,
                        color: Colors.red,
                      ),
                      SizedBox(width: 4),
                      Text(
                        widget.date!,
                        // DateFormat('yyyy-MM-dd').format(DateTime(2021)),
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.red,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.timelapse, size: 14, color: Colors.red),
                      SizedBox(width: 2),
                      Text(
                        widget.time!,
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(width: 20),

                      // SizedBox(width: 6),
                    ],
                  ),
                ],
              ),
            ),
            // SizedBox(
            //   width: 10,
            // ),
          ],
        ),
      ),
    );
  }
}
