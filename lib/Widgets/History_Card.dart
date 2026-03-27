import 'package:custom_rating_bar/custom_rating_bar.dart';
import 'package:flutter/material.dart';

class HistoryCard extends StatefulWidget {
  String? subject;
  String? year;
  String? semester;
  String? date;
  String? time;
  String? topic;
  String? topicdescription;
  String? rating;
  HistoryCard({
    super.key,
    required this.rating,
    required this.subject,
    required this.year,
    required this.semester,
    required this.date,
    required this.time,
    required this.topic,
    required this.topicdescription,
  });

  @override
  State<HistoryCard> createState() => _ToDoListCardCompletedState();
}

class _ToDoListCardCompletedState extends State<HistoryCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(
            color: const Color.fromARGB(255, 4, 118, 167).withOpacity(0.5),
            width: 0.5,
          ),
          color: const Color.fromARGB(255, 230, 233, 231),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: Colors.black12, blurRadius: 6, spreadRadius: 1),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 4,
              height: 60,
              decoration: BoxDecoration(
                color: widget.year == '1st Year'
                    ? Color.fromRGBO(2, 109, 148, 1)
                    : widget.year == '2nd Year'
                    ? Color.fromRGBO(255, 193, 7, 1)
                    : widget.year == '3rd Year'
                    ? Color.fromRGBO(76, 175, 80, 1)
                    : Color.fromRGBO(244, 67, 54, 1),
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
                      color: Colors.black.withOpacity(0.5),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: widget.year == '1st Year'
                              ? Color.fromRGBO(2, 109, 148, 1)
                              : widget.year == '2nd Year'
                              ? Color.fromRGBO(255, 193, 7, 1)
                              : widget.year == '3rd Year'
                              ? Color.fromRGBO(76, 175, 80, 1)
                              : Color.fromRGBO(244, 67, 54, 1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          widget.year!,
                          style: TextStyle(
                            color: const Color.fromARGB(255, 255, 255, 255),
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(width: 4),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: widget.semester == "1st Semester"
                              ? const Color.fromARGB(255, 238, 22, 155)
                              : const Color.fromARGB(255, 230, 85, 85),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          widget.semester!,
                          style: TextStyle(
                            color: const Color.fromARGB(255, 255, 255, 255),
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6),
                  Row(
                    key: widget.key,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color.fromARGB(255, 255, 255, 255),
                            width: 1,
                          ),
                          color: const Color.fromARGB(255, 66, 65, 65),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.date_range_rounded,
                              size: 14,
                              color: Color.fromARGB(255, 255, 255, 255),
                            ),
                            SizedBox(width: 4),
                            Text(
                              widget.date!,
                              style: TextStyle(
                                fontSize: 10,
                                color: const Color.fromARGB(255, 255, 255, 255),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 8),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color.fromARGB(255, 255, 255, 255),
                            width: 1,
                          ),
                          color: const Color.fromARGB(255, 66, 65, 65),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.timelapse,
                              size: 14,
                              color: Color.fromARGB(255, 255, 255, 255),
                            ),
                            SizedBox(width: 2),
                            Text(
                              widget.time!,
                              style: TextStyle(
                                color: const Color.fromARGB(255, 255, 255, 255),
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 8),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color.fromARGB(255, 255, 255, 255),
                            width: 1,
                          ),
                          color: const Color.fromARGB(255, 66, 65, 65),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.rate_review_outlined,
                              size: 14,
                              color: Color.fromARGB(255, 255, 255, 255),
                            ),
                            SizedBox(width: 2),
                            IgnorePointer(
                              ignoring: true,
                              child: RatingBar(
                                filledIcon: Icons.star,
                                emptyIcon: Icons.star_border,
                                // onRatingChanged: (value) {
                                //   _rating = value.toInt();
                                // },
                                initialRating: widget.rating != null
                                    ? double.parse(widget.rating!)
                                    : 0.0,
                                maxRating: 5,
                                size: 13,

                                onRatingChanged: (double value) {},
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(width: 10),
            IconButton(
              icon: const Icon(
                Icons.info_outline,
                size: 20,
                color: Color.fromRGBO(2, 109, 148, 1),
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      backgroundColor: const Color.fromARGB(
                        255,
                        255,
                        255,
                        255,
                      ), // Change dialog background color here
                      title: Text(
                        widget.topic ?? 'No Topic',
                        style: TextStyle(
                          color: Color.fromRGBO(2, 109, 148, 1),
                          fontWeight: FontWeight.w500,
                          fontSize: 17,
                        ),
                      ),

                      content: Text(
                        widget.topicdescription ?? 'No Description',
                        style: TextStyle(
                          color: Color.fromRGBO(2, 109, 148, 1),
                          fontWeight: FontWeight.w400,
                          fontSize: 15,
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            'Close',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Color.fromRGBO(2, 109, 148, 1),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
