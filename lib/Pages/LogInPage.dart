import 'package:attendance_system_flutter_application/Services/Firebase_Authentications.dart'
    show FirebaseAuthentications;
import 'package:attendance_system_flutter_application/Services/Firebase_Services.dart';
import 'package:attendance_system_flutter_application/Widgets/Custom_Button.dart'
    show CustomButton;
import 'package:attendance_system_flutter_application/Widgets/Custom_Textfield.dart'
    show custom_textfield;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class Loginpage extends StatefulWidget {
  const Loginpage({super.key});

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  final TextEditingController emailFieldController = TextEditingController();
  final TextEditingController passwordFieldController = TextEditingController();
  String? emailErrorText;
  bool isloadingnormal = false;
  bool isloadinggoogle = false;
  String? passwordErrorText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
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
                        const SizedBox(height: 15),
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
                        CustomButton(
                          btntype: "Normal",
                          selecter: 0,
                          isloadingnormal: isloadingnormal,
                          btnText: " LOG IN ",
                          onTap: () {
                            setState(() {
                              isloadingnormal = true;
                            });
                            if (emailFieldController.text.trim().isEmpty ||
                                passwordFieldController.text.trim().isEmpty) {
                              passwordErrorText =
                                  "Please Fill The Password Field";
                              emailErrorText = "Please Fill The Email Field";
                              isloadingnormal = false;
                            } else {
                              FirebaseAuthentications AuthObject =
                                  new FirebaseAuthentications();
                              FirebaseServices firebaseServicesobj =
                                  new FirebaseServices();
                              AuthObject.signIn(
                                email: emailFieldController.text.trim(),
                                password: passwordFieldController.text.trim(),
                              ).then((value) {
                                print("dsdd");
                                print(value);
                                if (value == "invalid-credential") {
                                  setState(() {
                                    isloadingnormal = false;
                                    emailErrorText = "invalid-credential";
                                    passwordErrorText = "invalid-credential";
                                  });
                                } else if (value == 'success') {
                                  firebaseServicesobj.saveStudentToken();
                                } else if (value == "invalid-email") {
                                  setState(() {
                                    isloadingnormal = false;
                                    emailErrorText = "iinvalid-email";
                                  });
                                } else {
                                  setState(() {
                                    isloadingnormal = false;
                                  });
                                }
                              });
                            }
                          },
                        ),
                        const SizedBox(height: 292),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
