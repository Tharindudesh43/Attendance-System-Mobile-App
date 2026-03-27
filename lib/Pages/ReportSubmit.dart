import 'package:another_flushbar/flushbar.dart';
import 'package:attendance_system_flutter_application/Pages/DiscoverPage.dart';
import 'package:attendance_system_flutter_application/Providers/riverpod.dart';
import 'package:attendance_system_flutter_application/Services/Firebase_Services.dart';
import 'package:attendance_system_flutter_application/Services/MongoDB_Services.dart';
import 'package:attendance_system_flutter_application/Widgets/Date_Picker.dart';
import 'package:attendance_system_flutter_application/Widgets/Report_Textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Reportsubmit extends ConsumerStatefulWidget {
  const Reportsubmit({super.key});

  @override
  ConsumerState<Reportsubmit> createState() => _ReportsubmitState();
}

class _ReportsubmitState extends ConsumerState<Reportsubmit> {
  final TextEditingController reporttitleFieldController =
      TextEditingController();
  final TextEditingController reportdescriptionFieldController =
      TextEditingController();
  final TextEditingController registrationnumberFieldController =
      TextEditingController();
  String? reprottitleErrorText;
  String? reprotdescriptionErrorText;
  String? registrationnumberErrorText;
  String? registrationNumber;
  String? _uploadedUrl;
  bool isloading = false;

  String? anonymouscheck = 'ON';
  DateTime? selectedDate;
  String? nowtime;

  static const List<String> reportcategory = [
    "Ragging",
    "Academic",
    "Hostel Issue",
  ];
  String _selectedCategory = reportcategory[0];

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now();
    //registrationNumber = ref.watch(riverpodUserData).UserData[0].registernumber;
  }

  File? imageFile1;
  File? imageFile2;
  File? imageFile3;
  String? imageUrl1;
  String? imageUrl2;
  String? imageUrl3;

  Future<void> pickImage(ImageSource source, {required num imageNumber}) async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: source);

      if (pickedFile != null) {
        setState(() {
          if (imageNumber == 1) {
            imageFile1 = File(pickedFile.path);
          } else if (imageNumber == 2) {
            imageFile2 = File(pickedFile.path);
          } else if (imageNumber == 3) {
            imageFile3 = File(pickedFile.path);
          }
        });
      }
    } catch (e) {
      Flushbar(
        message: "Error picking image: $e",
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
  }

  List<bool> isselected = [true, false];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Report Submission', style: TextStyle(color: Colors.white)),
        backgroundColor: Color.fromRGBO(2, 109, 148, 1),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Text(
                        "Anonymity:",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ToggleButtons(
                        constraints: const BoxConstraints(
                          minHeight: 30,
                          minWidth: 50, // smaller button width
                        ),
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 6,
                            ), // reduce padding
                            child: Text(
                              "ON",
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                              ), // smaller text
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 6),
                            child: Text(
                              "OFF",
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                        isSelected: isselected,
                        onPressed: (int index) {
                          setState(() {
                            for (int i = 0; i < isselected.length; i++) {
                              isselected[i] = (i == index);
                            }
                            bool isAnonymous = isselected[0];
                            anonymouscheck = isselected[0] ? "ON" : "OFF";
                            print(anonymouscheck);
                            print("Anonymous Reporting: $isAnonymous");
                          });
                        },
                        borderRadius: BorderRadius.circular(10),
                        selectedColor: Colors.white,
                        fillColor: Color.fromRGBO(2, 109, 148, 1),
                        color: Colors.black,
                        borderColor: Colors.grey,
                        selectedBorderColor: Color.fromRGBO(2, 109, 148, 1),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            anonymouscheck == "OFF"
                ? ReportTextfield(
                    enabled: false,
                    textfieldvalue:
                        "Registration Number will add automatically",
                    controller: registrationnumberFieldController,
                    errorText: registrationnumberErrorText,
                  )
                : const SizedBox.shrink(),
            ReportTextfield(
              textfieldvalue: "Report Title",
              controller: reporttitleFieldController,
              errorText: reprottitleErrorText,
            ),
            ReportTextfield(
              textfieldvalue: "Report Description",
              controller: reportdescriptionFieldController,
              errorText: reprotdescriptionErrorText,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 12, right: 12),
                  child: Icon(Icons.date_range_rounded, size: 20),
                ),
                DatePicker(
                  selectedDate: selectedDate,
                  onDateSelected: (date) {
                    setState(() {
                      selectedDate = date;
                    });
                  },
                ),
                Container(
                  width: 190, // Ensure the container has a defined width
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.category,
                        color: Color.fromRGBO(2, 109, 148, 1),
                        size: 16,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: const BorderSide(
                          color: Color.fromRGBO(2, 109, 148, 1),
                          width: 1.0,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: const BorderSide(
                          color: Color.fromRGBO(2, 109, 148, 1),
                          width: 1.0,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: const BorderSide(
                          color: Color.fromRGBO(2, 109, 148, 1),
                          width: 2.0,
                        ),
                      ),
                      filled: true,
                      fillColor: const Color.fromRGBO(192, 214, 222, 1),
                    ),
                    icon: const Icon(
                      Icons.arrow_drop_down_circle,
                      size: 14,
                      color: Color.fromRGBO(2, 109, 148, 1),
                    ),
                    value: _selectedCategory,
                    items: reportcategory.map((category) {
                      return DropdownMenuItem(
                        value: category,
                        child: Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: Text(
                            category,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedCategory = value as String;
                      });
                    },
                    dropdownColor: const Color.fromRGBO(192, 214, 222, 1),
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Color.fromRGBO(2, 109, 148, 1).withOpacity(0.1),
                  border: Border.all(
                    color: const Color.fromARGB(
                      255,
                      201,
                      201,
                      205,
                    ), // Border color
                    width: 1.0, // Border width
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ImageContainer(
                          imageNumber: 1,
                          imageFile: imageFile1,
                          onImagePicked: (file) =>
                              setState(() => imageFile1 = file),
                        ),
                        ImageContainer(
                          imageNumber: 2,
                          imageFile: imageFile2,
                          onImagePicked: (file) =>
                              setState(() => imageFile2 = file),
                        ),
                        ImageContainer(
                          imageNumber: 3,
                          imageFile: imageFile3,
                          onImagePicked: (file) =>
                              setState(() => imageFile3 = file),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                setState(() {
                  isloading = true;
                });
                FirebaseServices FirebaseServicesObject =
                    new FirebaseServices();
                if (reporttitleFieldController.text.isNotEmpty &&
                    reportdescriptionFieldController.text.isNotEmpty) {
                  if (imageFile1 != null ||
                      imageFile2 != null ||
                      imageFile3 != null) {
                    FirebaseServicesObject.uploadImagestoCloudinary(
                      imageFile1: imageFile1,
                      imageFile2: imageFile2,
                      imageFile3: imageFile3,
                    ).then((value) {
                      if (value ==
                          'An unexpected error occurred. Please try again') {
                        Flushbar(
                          message:
                              "An unexpected error occurred. Please try again!",
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
                          backgroundColor: const Color.fromARGB(
                            255,
                            209,
                            219,
                            227,
                          ),
                          leftBarIndicatorColor: Color.fromRGBO(2, 109, 148, 1),
                          messageColor: Colors.black,
                        ).show(context);
                        setState(() {
                          isloading = false;
                        });
                      } else if (value ==
                          'Request timed out. Please try again') {
                        Flushbar(
                          message: "Request timed out. Please try again!",
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
                          backgroundColor: const Color.fromARGB(
                            255,
                            209,
                            219,
                            227,
                          ),
                          leftBarIndicatorColor: Color.fromRGBO(2, 109, 148, 1),
                          messageColor: Colors.black,
                        ).show(context);
                        setState(() {
                          isloading = false;
                        });
                      } else if (value ==
                          'No internet connection. Please try again') {
                        Flushbar(
                          message: "No internet connection. Please try again!",
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
                          backgroundColor: const Color.fromARGB(
                            255,
                            209,
                            219,
                            227,
                          ),
                          leftBarIndicatorColor: Color.fromRGBO(2, 109, 148, 1),
                          messageColor: Colors.black,
                        ).show(context);
                        setState(() {
                          isloading = false;
                        });
                      } else if (value == 'No images selected') {
                        Flushbar(
                          message: "No images selected!",
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
                          backgroundColor: const Color.fromARGB(
                            255,
                            209,
                            219,
                            227,
                          ),
                          leftBarIndicatorColor: Color.fromRGBO(2, 109, 148, 1),
                          messageColor: Colors.black,
                        ).show(context);
                        setState(() {
                          isloading = false;
                        });
                      } else {
                        FirebaseServicesObject.addreport(
                          report_type: _selectedCategory,
                          title: reporttitleFieldController.text.trim(),
                          description: reportdescriptionFieldController.text
                              .trim(),
                          images: value,
                          status: "Not Watched",
                          date: DateFormat('dd MMM yyyy').format(selectedDate!),
                          // date: selectedDate.toString(),
                          anonymity: anonymouscheck == "ON" ? true : false,
                          time: DateFormat(
                            'HH:mm',
                          ).format(DateTime.now()).toString(),
                        ).then((result) {
                          if (result["message"] ==
                              "user report added successfully") {
                            MongodbServices MongodbServicesObject =
                                MongodbServices();
                            print(result['userId']);
                            MongodbServicesObject.insertreport(
                              reportId: result["reportId"],
                              anonymity: anonymouscheck == "ON" ? true : false,
                              date: DateFormat(
                                'dd MMM yyyy',
                              ).format(selectedDate!),
                              description: reportdescriptionFieldController.text
                                  .trim(),
                              images: value,
                              report_type: _selectedCategory,
                              status: "Not Watched",
                              time: DateFormat(
                                'HH:mm',
                              ).format(DateTime.now()).toString(),
                              title: reporttitleFieldController.text.trim(),
                              registrationnumber: result["registrationnumber"],
                              student_email: result["studentemail"],
                              userId: result["userId"],
                            ).then((response) {
                              if (response == "report submitted to mongodb") {
                                Flushbar(
                                  message: "Report submitted successfully!",
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
                                  backgroundColor: const Color.fromARGB(
                                    255,
                                    209,
                                    219,
                                    227,
                                  ),
                                  leftBarIndicatorColor: Color.fromRGBO(
                                    2,
                                    109,
                                    148,
                                    1,
                                  ),
                                  messageColor: Colors.black,
                                ).show(context);
                                setState(() {
                                  isloading = false;
                                });
                              } else {
                                Flushbar(
                                  message:
                                      "Error Occured While submit to ADMIN!",
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
                                  backgroundColor: const Color.fromARGB(
                                    255,
                                    209,
                                    219,
                                    227,
                                  ),
                                  leftBarIndicatorColor: Color.fromRGBO(
                                    2,
                                    109,
                                    148,
                                    1,
                                  ),
                                  messageColor: Colors.black,
                                ).show(context);
                                setState(() {
                                  isloading = false;
                                });
                              }
                            });
                          } else if (result ==
                              "No internet connection. Please try again(report)") {
                            Flushbar(
                              message:
                                  "No internet connection. Please try again(report): $result",
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
                              backgroundColor: const Color.fromARGB(
                                255,
                                209,
                                219,
                                227,
                              ),
                              leftBarIndicatorColor: Color.fromRGBO(
                                2,
                                109,
                                148,
                                1,
                              ),
                              messageColor: Colors.black,
                            ).show(context);
                            setState(() {
                              isloading = false;
                            });
                          } else if (result ==
                              "Request timed out. Please try again(report)") {
                            Flushbar(
                              message:
                                  "Request timed out. Please try again(report): $result",
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
                              backgroundColor: const Color.fromARGB(
                                255,
                                209,
                                219,
                                227,
                              ),
                              leftBarIndicatorColor: Color.fromRGBO(
                                2,
                                109,
                                148,
                                1,
                              ),
                              messageColor: Colors.black,
                            ).show(context);
                            setState(() {
                              isloading = false;
                            });
                          } else if (result ==
                              "report submission failed(report)") {
                            Flushbar(
                              message: "Failed to submit report: $result",
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
                              backgroundColor: const Color.fromARGB(
                                255,
                                209,
                                219,
                                227,
                              ),
                              leftBarIndicatorColor: Color.fromRGBO(
                                2,
                                109,
                                148,
                                1,
                              ),
                              messageColor: Colors.black,
                            ).show(context);
                            setState(() {
                              isloading = false;
                            });
                          }
                        });
                      }
                      print(value);
                    });
                  } else {
                    Flushbar(
                      message:
                          "Please select at least one image before uploading.",
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
                    setState(() {
                      isloading = false;
                    });
                  }
                } else {
                  Flushbar(
                    message: "Fill Report form fully !",

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
                  setState(() {
                    isloading = false;
                  });
                }
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: const Color.fromRGBO(2, 109, 148, 1),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 70,
                      right: 70,
                      top: 15,
                      bottom: 15,
                    ),
                    child: isloading
                        ? const SizedBox(
                            width: 25,
                            height: 25,
                            child: Center(
                              child: SizedBox(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                          )
                        : Text(
                            "Report",
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ImageContainer extends StatefulWidget {
  int imageNumber;
  File? imageFile;
  final Function(File?) onImagePicked;
  ImageContainer({
    super.key,
    required this.imageNumber,
    required this.imageFile,
    required this.onImagePicked,
  });

  @override
  State<ImageContainer> createState() => _ImageContainerState();
}

class _ImageContainerState extends State<ImageContainer> {
  Future<void> pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      final file = File(pickedFile.path);
      widget.onImagePicked(file); // notify parent
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 15.0,
        right: 15.0,
        top: 20.0,
        bottom: 20.0,
      ),
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 205, 199, 199),
          borderRadius: BorderRadius.circular(10),
        ),
        child: widget.imageFile == null
            ? InkWell(
                onTap: () => pickImage(ImageSource.gallery),
                child: const Center(
                  child: Icon(Icons.add_a_photo_outlined, size: 35),
                ),
              )
            : Container(
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.file(
                          widget.imageFile!,
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      child: InkWell(
                        onTap: () => widget.onImagePicked(null),
                        child: Padding(
                          padding: const EdgeInsets.all(7.0),
                          child: Container(
                            width: 27,
                            height: 27,
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Icon(
                              Icons.close,
                              size: 22,
                              weight: 200,

                              color: Colors.white,
                            ),
                          ),
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
