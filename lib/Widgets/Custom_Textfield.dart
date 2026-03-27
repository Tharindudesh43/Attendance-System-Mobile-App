import 'package:flutter/material.dart';

class custom_textfield extends StatefulWidget {
  final TextEditingController? controller;
  String? errorText;
  String? textfieldvalue;
  double? width = 200;
  double? height = 50;

  custom_textfield({
    super.key,
    this.controller,
    required this.textfieldvalue,
    this.height,
    this.width,
    this.errorText,
  });

  @override
  State<custom_textfield> createState() => _custom_textfieldState();
}

class _custom_textfieldState extends State<custom_textfield> {
  bool isObscure = true;
  @override
  Widget build(BuildContext context) {
    return widget.textfieldvalue == "Password"
        ? Padding(
            padding: const EdgeInsets.all(7.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
              ),
              width: widget.width,
              height: widget.height,
              child: TextField(
                style: TextStyle(fontSize: 14),
                controller: widget.controller,
                obscureText: isObscure,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 15,
                  ),
                  errorText: widget.errorText,
                  errorStyle: TextStyle(
                    color: Colors.red,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                  filled: true,
                  fillColor: const Color.fromRGBO(
                    2,
                    109,
                    148,
                    1,
                  ).withOpacity(0.1),
                  icon: const Icon(
                    color: Color.fromARGB(255, 103, 96, 45),
                    weight: 120,
                    Icons.password,
                    size: 18,
                  ),
                  labelText: 'Password',
                  labelStyle: const TextStyle(fontSize: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      color: Colors.black,
                      isObscure ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        isObscure = !isObscure;
                      });
                    },
                  ),
                ),
              ),
            ),
          )
        : Padding(
            padding: const EdgeInsets.all(7),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
              ),
              width: widget.width,
              height: widget.height,
              child: TextField(
                style: TextStyle(fontSize: 14),
                controller: widget.controller,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 15,
                  ),
                  filled: true,
                  fillColor: const Color.fromRGBO(
                    2,
                    109,
                    148,
                    1,
                  ).withOpacity(0.1),
                  icon: Icon(
                    color: const Color.fromARGB(255, 103, 96, 45),
                    weight: 120,
                    widget.textfieldvalue == "Full Name"
                        ? Icons.title
                        : widget.textfieldvalue == "Email"
                        ? Icons.email
                        : widget.textfieldvalue == "Mobile Number"
                        ? Icons.mobile_friendly
                        : widget.textfieldvalue == "Initial With Name"
                        ? Icons.tag
                        : widget.textfieldvalue == "Registration Number"
                        ? Icons.app_registration
                        : widget.textfieldvalue == "Degree Name"
                        ? Icons.cast_for_education_rounded
                        : Icons.password,
                    size: 18,
                  ),
                  errorText: widget.errorText,
                  errorStyle: TextStyle(
                    color: Colors.red,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                  label: Text(
                    widget.textfieldvalue!,
                    style: const TextStyle(fontSize: 13),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(100),
                    borderSide: const BorderSide(color: Colors.black, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(100),
                    borderSide: const BorderSide(color: Colors.black, width: 2),
                  ),
                ),
              ),
            ),
          );
  }
}
