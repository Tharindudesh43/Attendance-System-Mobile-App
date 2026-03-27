import 'package:attendance_system_flutter_application/Pages/LogInPage.dart'
    show Loginpage;
import 'package:attendance_system_flutter_application/Pages/SignUpPage.dart';
import 'package:flutter/material.dart';

class Selectauthpage extends StatefulWidget {
  const Selectauthpage({super.key});

  @override
  State<Selectauthpage> createState() => _Selectauthpagetate();
}

class _Selectauthpagetate extends State<Selectauthpage> {
  final TextEditingController emailFieldController = TextEditingController();
  final TextEditingController passwordFieldController = TextEditingController();
  String? emailErrorText;
  bool isloadingnormal = false;
  bool isloadinggoogle = false;
  String? passwordErrorText;
  double boxY = -1;
  double boxX = -1;
  bool show = true;

  void MoveButton() {
    setState(() {
      show = !show;
      if (boxX == -1 && boxY == -1) {
        boxY = 1;
        boxX = 1;
      } else {
        boxY = -1;
        boxX = -1;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        color: Colors.transparent,
        padding: EdgeInsets.all(10),
        child: Text(
          '© 2025 Marky. All rights reserved.',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Color.fromRGBO(2, 109, 148, 1),
          ),
          textAlign: TextAlign.center,
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width > 400
                ? 400
                : double.infinity,
            child: Column(
              children: [
                const SizedBox(height: 20),
                const Text(
                  "Get Started Now",
                  style: TextStyle(fontSize: 23, fontWeight: FontWeight.w700),
                ),
                const Text(
                  "Create an account or log in to explore \n about our app",
                  style: TextStyle(height: 1.1),
                  textAlign: TextAlign.center,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: GestureDetector(
                    onTap: MoveButton,
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: const Color.fromARGB(142, 237, 236, 236),
                      ),
                      width: 240,
                      height: 50,
                      child: Stack(
                        children: [
                          AnimatedContainer(
                            alignment: Alignment(boxX, boxY),
                            duration: Duration(milliseconds: 400),
                            child: Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: InkWell(
                                hoverColor: const Color.fromARGB(
                                  255,
                                  11,
                                  154,
                                  242,
                                ).withOpacity(0.9),
                                splashColor: const Color.fromARGB(
                                  255,
                                  224,
                                  3,
                                  3,
                                ).withOpacity(0.2),
                                child: Container(
                                  width: 119,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: const Color.fromRGBO(2, 109, 148, 1),
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 45 / 3,
                            left: 240 / 6,
                            child: Text(
                              "LOG IN",
                              style: TextStyle(
                                fontSize: 15,
                                color: boxY == -1
                                    ? Colors.white
                                    : Color.fromARGB(255, 0, 0, 0),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 45 / 3,
                            right: 235 / 6,
                            child: Text(
                              "SIGN UP",
                              style: TextStyle(
                                fontSize: 15,
                                color: boxX == -1
                                    ? Color.fromARGB(255, 0, 0, 0)
                                    : Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                show ? Loginpage() : SignupPage(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
