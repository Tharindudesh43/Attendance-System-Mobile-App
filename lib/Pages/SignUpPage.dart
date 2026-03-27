import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:attendance_system_flutter_application/Services/Firebase_Authentications.dart'
    show FirebaseAuthentications;
import 'package:attendance_system_flutter_application/Services/Firebase_Services.dart';
import 'package:attendance_system_flutter_application/Utilities/Validations.dart'
    show Validation;
import 'package:attendance_system_flutter_application/Widgets/Custom_Button.dart'
    show CustomButton;
import 'package:attendance_system_flutter_application/Widgets/Custom_Textfield.dart'
    show custom_textfield;
import 'package:attendance_system_flutter_application/Widgets/Date_Picker.dart';

import 'package:attendance_system_flutter_application/Widgets/DropDown.dart'
    show Dropdown;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class SignupPage extends ConsumerStatefulWidget {
  SignupPage({super.key});

  @override
  ConsumerState<SignupPage> createState() => _SignupPage();
}

class _SignupPage extends ConsumerState<SignupPage> {
  final TextEditingController emailFieldController = TextEditingController();
  final TextEditingController passwordFieldController = TextEditingController();
  final TextEditingController fullnameFieldController = TextEditingController();
  final TextEditingController initialnameFieldController =
      TextEditingController();
  final TextEditingController mobilenumberFieldController =
      TextEditingController();
  final TextEditingController registrationnumberFieldController =
      TextEditingController();
  final TextEditingController degreenameFieldController =
      TextEditingController();

  List<String> Faculty = ['(FOT) Faculty of Technology'];
  List<String> Year = ['1st Year', '2nd Year', '3rd Year', '4th Year'];
  List<String> Semester = ['1st Semester', '2nd Semester'];
  List<String> Department = [
    '(DICT) Information and Communication Technology',
    '(DBST) Bio System and Technology',
  ];

  DateTime? selectedDate;

  bool isLoadingnormal = false;

  String? emailErrorText;
  String? passwordErrorText;
  String? fullnameErrorText;
  String? mobilenumberErrorText;
  String? registrationnumberErrorText;
  String? degreenameErrorText;
  String? intialnameErrorText;

  String selectedfaculty = "Faculty";
  String selectedDepartment = "Department";
  String selectedyear = "Year";
  String selectedsemester = "Semester";
  String front_of_the_registration_number = "SEU/IS/";

  bool loop = true;

  String _scanBarcode = 'Unknown';

  File? imageFile;
  String? imageUrl;

  Future<void> pickImage(ImageSource source) async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: source);

      if (pickedFile != null) {
        setState(() {
          imageFile = File(pickedFile.path);
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

  // Updated: Use MobileScanner for barcode scanning
  Future<void> scanBarcodeNormal() async {
    String? barcodeScanRes;
    try {
      // Navigate to a new page with MobileScanner
      barcodeScanRes = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => _BarcodeScannerPage(
            onDetect: (BarcodeCapture capture) {
              final String? scannedValue = capture.barcodes.first.rawValue;
              return scannedValue;
            },
          ),
        ),
      );
    } catch (e) {
      barcodeScanRes = 'Failed to scan barcode.';
    }

    if (barcodeScanRes != null && barcodeScanRes != 'Failed to scan barcode.') {
      setState(() {
        _scanBarcode = barcodeScanRes ?? 'Unknown';
        registrationnumberFieldController.text =
            front_of_the_registration_number + _scanBarcode;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    registrationnumberFieldController.text =
        "$front_of_the_registration_number";
    selectedDate = DateTime.now(); // ⬅️ Sets current date
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(5),
              child: Container(
                width: 83,
                height: 83,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color.fromARGB(255, 2, 109, 148),
                    width: 1.5,
                  ),
                  color: const Color.fromRGBO(2, 109, 148, 1),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: imageFile == null
                    ? InkWell(
                        onTap: () => pickImage(ImageSource.gallery),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 80,
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(100),
                                  topRight: Radius.circular(100),
                                ),
                                color: Colors.transparent,
                              ),
                            ),
                            Container(
                              width: 80,
                              height: 40,
                              child: Center(
                                child: Icon(
                                  Icons.person_2,
                                  size: 20,
                                  color: Colors.white,
                                ),
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(100),
                                  bottomRight: Radius.circular(100),
                                ),
                                color: const Color.fromARGB(
                                  255,
                                  0,
                                  0,
                                  0,
                                ).withOpacity(0.4),
                              ),
                            ),
                          ],
                        ),
                      )
                    : Container(
                        child: Stack(
                          children: [
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: Image.file(
                                  imageFile!,
                                  height: 100,
                                  width: 100,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                              right: 0,
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    imageFile = null; // 👈 remove image here
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
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
            ),
            Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
                color: Colors.white,
              ),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 5, right: 5),
                    child: Column(
                      children: [
                        // const SizedBox(height: 3),
                        custom_textfield(
                          textfieldvalue: "Full Name",
                          controller: fullnameFieldController,
                          errorText: fullnameErrorText,
                        ),
                        custom_textfield(
                          textfieldvalue: "Initial With Name",
                          controller: initialnameFieldController,
                          errorText: intialnameErrorText,
                        ),
                        custom_textfield(
                          textfieldvalue: "Email",
                          controller: emailFieldController,
                          errorText: emailErrorText,
                        ),
                        custom_textfield(
                          textfieldvalue: "Password",
                          controller: passwordFieldController,
                          errorText: passwordErrorText,
                        ),
                        custom_textfield(
                          textfieldvalue: "Degree Name",
                          controller: degreenameFieldController,
                          errorText: degreenameErrorText,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 37,
                      right: 8,
                      top: 5,
                      bottom: 5,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Dropdown(
                          Data: Faculty,
                          selecteddata: selectedfaculty,
                          onChanged: (value) {
                            setState(() {
                              selectedfaculty = value;
                            });
                          },
                        ),
                        Dropdown(
                          Data: Department,
                          selecteddata: selectedDepartment,
                          onChanged: (value) {
                            setState(() {
                              selectedDepartment = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 37,
                      right: 8,
                      top: 5,
                      bottom: 5,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Dropdown(
                          Data: Year,
                          selecteddata: selectedyear,
                          onChanged: (value) {
                            setState(() {
                              selectedyear = value;
                            });
                          },
                        ),
                        Dropdown(
                          Data: Semester,
                          selecteddata: selectedsemester,
                          onChanged: (value) {
                            setState(() {
                              selectedsemester = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8),
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          custom_textfield(
                            width: 170,
                            textfieldvalue: "Mobile Number",
                            controller: mobilenumberFieldController,
                            errorText: mobilenumberErrorText,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(Icons.cake_outlined, size: 20),
                          ),
                          DatePicker(
                            selectedDate: selectedDate,
                            onDateSelected: (date) {
                              setState(() {
                                selectedDate = date;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 6, right: 22),
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          custom_textfield(
                            width: 200,
                            textfieldvalue: "Registration Number",
                            controller: registrationnumberFieldController,
                            errorText: registrationnumberErrorText,
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromRGBO(
                                2,
                                109,
                                148,
                                1,
                              ), // background color
                              foregroundColor:
                                  Colors.white, // text (and icon) color
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 10,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () => scanBarcodeNormal(),
                            child: const Text(
                              'Scan Your ID Card',
                              style: TextStyle(fontSize: 11),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  CustomButton(
                    btntype: "Normal",
                    selecter: 0,
                    isloadingnormal: isLoadingnormal,
                    btnText: "SIGN UP",
                    onTap: () async {
                      Validation validationObj = Validation();
                      setState(() {
                        isLoadingnormal = true;
                      });
                      if (loop) {
                        fullnameErrorText = validationObj.checkvalidation(
                          FieldValue: fullnameFieldController.text.toString(),
                          Fieldnumber: 1,
                        );
                        intialnameErrorText = validationObj.checkvalidation(
                          FieldValue: initialnameFieldController.text
                              .toString(),
                          Fieldnumber: 2,
                        );
                        emailErrorText = validationObj.checkvalidation(
                          FieldValue: emailFieldController.text.toString(),
                          Fieldnumber: 3,
                        );
                        passwordErrorText = validationObj.checkvalidation(
                          FieldValue: passwordFieldController.text.toString(),
                          Fieldnumber: 4,
                        );
                        degreenameErrorText = validationObj.checkvalidation(
                          FieldValue: degreenameFieldController.text.toString(),
                          Fieldnumber: 5,
                        );
                        mobilenumberErrorText = validationObj.checkvalidation(
                          FieldValue: mobilenumberFieldController.text
                              .toString(),
                          Fieldnumber: 6,
                        );
                        registrationnumberErrorText = validationObj
                            .checkvalidation(
                              FieldValue: registrationnumberFieldController.text
                                  .toString(),
                              Fieldnumber: 7,
                            );
                        if (imageFile == null) {
                          setState(() {
                            isLoadingnormal = false;
                          });
                          Flushbar(
                            message: "Please upload a profile picture.",
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
                        } else {
                          if (fullnameErrorText == null &&
                              intialnameErrorText == null &&
                              emailErrorText == null &&
                              passwordErrorText == null &&
                              degreenameErrorText == null &&
                              mobilenumberErrorText == null
                          //&&registrationnumberErrorText == null (because this will work with barcode Scanner when app launch this uncomment)
                          ) {
                            FirebaseAuthentications AuthObject =
                                new FirebaseAuthentications();
                            FirebaseServices FirebaseServicesobj =
                                new FirebaseServices();
                            FirebaseServicesobj.uploadsignUpuserimage(
                              imageFile: imageFile!,
                            ).then((result) {
                              if (result ==
                                      'Failed to retrieve secure_url for one of the image' ||
                                  result == 'Upload failed with status: 200' ||
                                  result ==
                                      'No internet connection. Please try again' ||
                                  result ==
                                      'Request timed out. Please try again' ||
                                  result ==
                                      'An unexpected error occurred. Please try again') {
                                setState(() {
                                  isLoadingnormal = false;
                                });
                                Flushbar(
                                  message:
                                      result ==
                                          'Failed to retrieve secure_url for one of the image'
                                      ? 'Failed to retrieve secure_url for one of the image'
                                      : result ==
                                            'Upload failed with status: 200'
                                      ? 'Upload failed with status: 200'
                                      : result ==
                                            'No internet connection. Please try again'
                                      ? 'No internet connection. Please try again'
                                      : result ==
                                            'Request timed out. Please try again'
                                      ? 'Request timed out. Please try again'
                                      : 'An unexpected error occurred. Please try again',
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
                              } else {
                                AuthObject.signup(
                                  userimageUrl: result.toString(),
                                  fullname: fullnameFieldController.text.trim(),
                                  namewithinitial: initialnameFieldController
                                      .text
                                      .trim(),
                                  email: emailFieldController.text.trim(),
                                  password: passwordFieldController.text.trim(),
                                  degreename: degreenameFieldController.text
                                      .trim(),
                                  faculty: selectedfaculty,
                                  department: selectedDepartment,
                                  Year: selectedyear,
                                  Semester: selectedsemester,
                                  mobilenumber: mobilenumberFieldController.text
                                      .trim(),
                                  birthday: DateFormat(
                                    'dd/MM/yyyy',
                                  ).format(selectedDate!),
                                  registrationnumber:
                                      registrationnumberFieldController.text
                                          .trim(),
                                  attendance_history: [],
                                  reports: [],
                                  notifications: [],
                                ).then((value) {
                                  if (value == "User Added") {
                                    Flushbar(
                                      message: "Login successfully!",
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
                                    FirebaseServicesobj.saveStudentToken();
                                  } else if (value == "email-already-in-use") {
                                    setState(() {
                                      isLoadingnormal = false;
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text("Email Already used"),
                                        behavior: SnackBarBehavior.floating,
                                        elevation: 12,
                                      ),
                                    );
                                  }
                                });
                              }
                            });
                          } else {
                            isLoadingnormal = false;
                          }
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// New widget for barcode scanning using MobileScanner
class _BarcodeScannerPage extends StatefulWidget {
  final Function(BarcodeCapture) onDetect;

  const _BarcodeScannerPage({required this.onDetect});

  @override
  _BarcodeScannerPageState createState() => _BarcodeScannerPageState();
}

class _BarcodeScannerPageState extends State<_BarcodeScannerPage> {
  final MobileScannerController _controller = MobileScannerController(
    formats: [BarcodeFormat.all], // Support all barcode formats
  );

  bool _popped = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Barcode'),
        backgroundColor: const Color.fromRGBO(2, 109, 148, 1),
        foregroundColor: Colors.white,
      ),
      body: MobileScanner(
        controller: _controller,
        onDetect: (BarcodeCapture capture) async {
          if (_popped) return;

          final String? result = await widget.onDetect(capture);
          if (result != null && mounted) {
            _popped = true;

            // Optional: stop camera before popping (reduces black screen issues)
            await _controller.stop();

            if (mounted) Navigator.pop(context, result);
          }
        },
      ),
    );
  }
}
