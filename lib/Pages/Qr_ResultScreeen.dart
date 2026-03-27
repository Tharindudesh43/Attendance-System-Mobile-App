import 'package:another_flushbar/flushbar.dart';
import 'package:attendance_system_flutter_application/Services/Firebase_Services.dart';
import 'package:attendance_system_flutter_application/Services/MongoDB_Services.dart';
import 'package:attendance_system_flutter_application/Widgets/ScanResult_Ui.dart';
import 'package:custom_rating_bar/custom_rating_bar.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:intl/intl.dart';

class QrResultscreeen extends StatefulWidget {
  String qr_scanned;
  String RegisterNo;
  String Name;
  String AcademicYear;
  String Semester;
  QrResultscreeen({
    super.key,
    required this.qr_scanned,
    required this.AcademicYear,
    required this.Semester,
    required this.Name,
    required this.RegisterNo,
  });

  @override
  State<QrResultscreeen> createState() => _QrResultscreeenState();
}

class _QrResultscreeenState extends State<QrResultscreeen> {
  int numberofselection = 0;
  int _rating = 0;
  final TextEditingController _feedbackController = TextEditingController();
  int feedbackskip_index = 0;
  String CurrentTime = '';
  String CurrentDate = '';
  Future<String?> DuplicateCheck({
    required String QrCode,
    required String Year,
    required String lecid_by_qr,
    required String RegisterNo,
    required String Name,
  }) async {
    MongodbServices.duplicatecheck(
      Year: Year,
      LecId_By_Qr: lecid_by_qr,
      Name: Name,
      QrCode: QrCode,
      RegisterNo: RegisterNo,
    ).then((value) {
      return value;
    });
  }

  String getCurrentTime() {
    final now = DateTime.now();
    return DateFormat('HH:mm:ss').format(now);
  }

  String getCurrentDate() {
    final now = DateTime.now();
    final date = DateFormat('yyyy-MM-dd').format(now);
    return '$date';
  }

  bool hasTimePassed(String timeStr, String DateStr) {
    List<dynamic> DateData = [];
    DateData = DateStr.split("-");
    if (timeStr.startsWith('E:')) {
      timeStr = timeStr.substring(2);
    }

    // Step 2: Split hours, minutes, seconds
    final parts = timeStr.split(':');
    if (parts.length != 3) return false;

    int hours = int.parse(parts[0]);
    int minutes = int.parse(parts[1]);
    int seconds = int.parse(parts[2]);
    int year = int.parse(DateData[0]);
    int month = int.parse(DateData[1]);
    int day = int.parse(DateData[2]);

    // Step 3: Create DateTime for today at that time
    final now = DateTime.now();
    final targetTime = DateTime(year, month, day, hours, minutes, seconds);

    // Step 4: Compare
    return DateTime.now().isAfter(targetTime);
  }

  bool isValidAttendanceQR(String scannedData) {
    try {
      final parts = scannedData.split('_');

      // Must have at least 8 parts to be valid
      if (parts.length < 12) return false;

      final id = parts[0];
      final subjectDetails = parts[parts.length - 6];
      final date = parts[parts.length - 3];
      final startTime = parts[parts.length - 2];
      final endTime = parts[parts.length - 1];

      print("ID: $id");
      print("Subject Details: $subjectDetails");
      print("Date: $date");
      print("Start Time: $startTime");
      print("End Time: $endTime");

      // Validate ID format (24-character hex string)
      final isValidId = RegExp(r'^[a-f0-9]{24}$').hasMatch(id);

      // Validate subjectDetails like SWT|31012|-|Software|Engineering
      final isValidSubject =
          subjectDetails.contains('|') && subjectDetails.split('|').length >= 5;

      // Validate time formats
      final isValidStart = startTime.startsWith('S:');
      final isValidEnd = endTime.startsWith('E:');

      return isValidId && isValidSubject && isValidStart && isValidEnd;
    } catch (e) {
      return false;
    }
  }

  Future<void> _showInitDialog() async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              scrollable: true,
              title: feedbackskip_index == 0
                  ? const Text(
                      "",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    )
                  : const Text(
                      "Session Feedback",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
              content: SingleChildScrollView(
                child: feedbackskip_index == 0
                    ? Column(
                        children: [
                          Text(
                            "Are you need to add feedback?",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      )
                    : Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              RatingBar(
                                filledIcon: Icons.star,
                                emptyIcon: Icons.star_border,
                                onRatingChanged: (value) {
                                  _rating = value.toInt();
                                },
                                initialRating: 1,
                                maxRating: 5,
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            controller: _feedbackController,
                            maxLength: 100,
                            decoration: const InputDecoration(
                              labelText: "Your feedback about this session",
                              labelStyle: TextStyle(fontSize: 12),
                              border: OutlineInputBorder(),
                              counterText: "",
                            ),
                            maxLines: 3,
                          ),
                        ],
                      ),
              ),

              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    if (feedbackskip_index == 0)
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop(true);
                        },
                        child: const Text("Skip"),
                      ),
                    if (feedbackskip_index == 0)
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            feedbackskip_index = 1; // update rating
                          });
                          feedbackskip_index = 1;
                          // Navigator.of(context).pop(true);
                        },
                        child: const Text("Yes, I Want"),
                      ),
                    if (feedbackskip_index != 0)
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop(true);
                        },
                        child: const Text("Submit"),
                      ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );

    if (result == true) {
      _continueInitialization();
    }
  }

  void _continueInitialization() {
    List<dynamic> QRData = [];
    QRData = widget.qr_scanned.split("_");
    print("DONEEEEEEEE");
    MongodbServices.insertattendace(
      currentime: CurrentTime,
      feedback: _feedbackController.text.trim(),
      rating: _rating, // Replace with actual rating value
      Qrcode: widget.qr_scanned,
      registerno: widget.RegisterNo,
      year: QRData[3],
      initialname: widget.Name,
      id: QRData[0],
    ).then((value) {
      if (value == 'Added Attendance') {
        String Semester = '';
        String Year = '';
        if (QRData[5] == '1stSemester') {
          Semester = '1st Semester';
        } else if (QRData[5] == '2ndSemester') {
          Semester = '2nd Semester';
        }
        if (QRData[3] == '1stYear') {
          Year = '1st Year';
        } else if (QRData[3] == '2ndYear') {
          Year = '2nd Year';
        } else if (QRData[3] == '3rdYear') {
          Year = '3rd Year';
        } else if (QRData[3] == '4thYear') {
          Year = '4th Year';
        }

        String Subject = QRData[6].split('|').join(' ');
        FirebaseServices.addattendancehistory_and_countadd(
          topic: QRData[7],
          topicdescription: QRData[8],
          date: CurrentDate,
          time: CurrentTime,
          semester: Semester,
          subject: Subject,
          year: Year,
          feedback: _feedbackController.text.trim(),
          rating: _rating,
        ).then((result) {
          if (result == 'Attendance added successfully') {
            setState(() {
              numberofselection = 1;
            });
            feedbackskip_index == 0
                ? ()
                : Flushbar(
                    message: "Feedback Submitted Successfully",
                    icon: Icon(
                      Icons.info_rounded,
                      size: 28.0,
                      color: Color.fromRGBO(2, 109, 148, 1),
                    ),
                    margin: EdgeInsets.all(6.0),
                    flushbarStyle: FlushbarStyle.FLOATING,
                    flushbarPosition: FlushbarPosition.BOTTOM,
                    textDirection: Directionality.of(context),
                    borderRadius: BorderRadius.circular(12),
                    duration: Duration(seconds: 4),
                    backgroundColor: const Color.fromARGB(255, 209, 219, 227),
                    leftBarIndicatorColor: Color.fromRGBO(2, 109, 148, 1),
                    messageColor: Colors.black,
                  ).show(context);
          } else {
            setState(() {
              numberofselection = 2;
            });
            Flushbar(
              message: "Feedback Submission Failed (User)",
              icon: Icon(
                Icons.info_rounded,
                size: 28.0,
                color: Color.fromRGBO(2, 109, 148, 1),
              ),
              margin: EdgeInsets.all(6.0),
              flushbarStyle: FlushbarStyle.FLOATING,
              flushbarPosition: FlushbarPosition.BOTTOM,
              textDirection: Directionality.of(context),
              borderRadius: BorderRadius.circular(12),
              duration: Duration(seconds: 4),
              backgroundColor: const Color.fromARGB(255, 209, 219, 227),
              leftBarIndicatorColor: Color.fromRGBO(2, 109, 148, 1),
              messageColor: Colors.black,
            ).show(context);
          }
        });
      } else if (value == 'Lecturer not found') {
        setState(() {
          numberofselection = 5;
        });
      } else if (value == 'error attendace') {
        setState(() {
          numberofselection = 2;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    print(widget.Name);
    print(widget.RegisterNo);
    CurrentDate = getCurrentDate();
    CurrentTime = getCurrentTime();

    List<dynamic> QRData = [];
    int count = 0;
    String LedID;
    QRData = widget.qr_scanned.split("_");

    if (isValidAttendanceQR(widget.qr_scanned)) {
      print("✅ Valid attendance QR");
      bool timeoutornot = hasTimePassed(QRData[11], QRData[9]);
      if (timeoutornot) {
        setState(() {
          numberofselection = 3;
        });
      } else {
        if (QRData[5].toString() == widget.Semester.replaceAll(' ', '') &&
            QRData[3].toString() == widget.AcademicYear.replaceAll(' ', '')) {
          MongodbServices.duplicatecheck(
            Year: QRData[3],
            LecId_By_Qr: QRData[0],
            Name: widget.Name,
            QrCode: widget.qr_scanned,
            RegisterNo: widget.RegisterNo,
          ).then((value) {
            if (value == 'Duplicates Found') {
              setState(() {
                numberofselection = 7;
              });
            } else if (value == 'No Duplicates' || value == 'Zero List') {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _showInitDialog();
              });
            } else if (value == 'Lecturer not found') {
              setState(() {
                numberofselection = 5;
              });
            } else if (value == 'error') {
              setState(() {
                numberofselection = 2;
              });
            }
          });
        } else {
          setState(() {
            numberofselection = 4;
          });
        }
      }
    } else {
      setState(() {
        numberofselection = 5;
      });
      print("❌ Invalid QR code. Please scan a valid attendance QR.");
      // Show an error dialog or toast
    }
    for (var element in QRData) {
      count = count + 1;
      if (count == 0) {
        LedID = element;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        foregroundColor: Colors.white,
        backgroundColor: Color.fromRGBO(2, 109, 148, 1),
        title: Text('Scan Result'),
      ),
      backgroundColor: Colors.white,
      body: numberofselection == 10
          ? ScanResultUI(
              selectedIndex: numberofselection,
              topic: widget.qr_scanned.split("_")[7],
              topicdescription: widget.qr_scanned.split("_")[8],
            )
          : numberofselection == 5
          ? ScanResultUI(
              selectedIndex: numberofselection,
              topic: widget.qr_scanned.split("_")[7],
              topicdescription: widget.qr_scanned.split("_")[8],
            )
          : numberofselection == 3
          ? ScanResultUI(
              selectedIndex: numberofselection,
              topic: widget.qr_scanned.split("_")[7],
              topicdescription: widget.qr_scanned.split("_")[8],
            )
          : numberofselection == 7
          ? ScanResultUI(
              selectedIndex: numberofselection,
              topic: widget.qr_scanned.split("_")[7],
              topicdescription: widget.qr_scanned.split("_")[8],
            )
          : numberofselection == 2
          ? ScanResultUI(
              selectedIndex: numberofselection,
              topic: widget.qr_scanned.split("_")[7],
              topicdescription: widget.qr_scanned.split("_")[8],
            )
          : numberofselection == 1
          ? ScanResultUI(
              selectedIndex: numberofselection,
              topic: widget.qr_scanned.split("_")[7],
              topicdescription: widget.qr_scanned.split("_")[8],
            )
          : numberofselection == 4
          ? ScanResultUI(
              selectedIndex: numberofselection,
              topic: widget.qr_scanned.split("_")[7],
              topicdescription: widget.qr_scanned.split("_")[8],
            )
          : numberofselection == 0
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: Lottie.asset(
                        repeat: true,
                        height: 200,
                        width: 200,
                        "assets/animations/Loading_Animation.json",
                      ),
                    ),
                  ],
                ),
              ],
            )
          : Text("dsddsds"),
    );
  }
}
