import 'package:flutter/material.dart';

class ReportTextfield extends StatefulWidget {
  final TextEditingController? controller;
  String? errorText;
  String? textfieldvalue;
  double? width = 200;
  double? height = 50;
  bool enabled;
  String? registrationNumber = "";
  int remainingCharacters_title = 100;
  int maxLengthCharacters_title = 100;

  ReportTextfield({
    super.key,
    this.controller,
    this.enabled = true,
    required this.textfieldvalue,
    this.registrationNumber,
    this.height,
    this.width,
    this.errorText,
  });

  @override
  State<ReportTextfield> createState() => _ReportTextfieldState();
}

class _ReportTextfieldState extends State<ReportTextfield> {
  int remaining = 100;

  @override
  void initState() {
    super.initState();
    if (widget.textfieldvalue == "Report Title") {
      widget.controller?.addListener(() {
        setState(() {
          remaining =
              widget.maxLengthCharacters_title -
              (widget.controller?.text.length ?? 0);
        });
      });
    }
  }

  @override
  void dispose() {
    if (widget.textfieldvalue == "Report Title") {
      widget.controller?.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.textfieldvalue == "Report Title"
        ? Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              width: widget.width,
              height: widget.height,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    enabled: widget.enabled,
                    style: const TextStyle(fontSize: 14),
                    controller: widget.controller,
                    maxLength: widget.maxLengthCharacters_title, // limit chars
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
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
                      icon: const Icon(
                        Icons.title_rounded,
                        size: 18,
                        color: Color.fromARGB(255, 103, 96, 45),
                        weight: 120,
                      ),
                      errorText: widget.errorText,
                      errorStyle: const TextStyle(
                        color: Colors.red,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      label: Text(
                        widget.textfieldvalue!,
                        style: const TextStyle(fontSize: 13),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Colors.black,
                          width: 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(100),
                        borderSide: const BorderSide(
                          color: Colors.black,
                          width: 2,
                        ),
                      ),
                      counterText: "", // hide default counter
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ValueListenableBuilder<TextEditingValue>(
                        valueListenable: widget.controller!,
                        builder: (context, value, child) {
                          final remaining =
                              widget.maxLengthCharacters_title -
                              value.text.length;
                          return Text(
                            "$remaining characters left ",
                            style: TextStyle(
                              fontSize: 12,
                              color: remaining < 10 ? Colors.red : Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        : (widget.textfieldvalue == "Report Description"
              ? Padding(
                  padding: const EdgeInsets.all(10),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    width: widget.width,
                    height: widget
                        .height, // You can also give a fixed height like 200
                    child: TextField(
                      enabled: widget.enabled,
                      controller: widget.controller,
                      style: const TextStyle(fontSize: 14),
                      maxLines: 6, // Allows multiline input
                      minLines: 4,
                      maxLength:
                          700, // Roughly 100 words assuming ~7 characters per word
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 13,
                          horizontal: 15,
                        ),
                        filled: true,
                        fillColor: const Color.fromRGBO(
                          2,
                          109,
                          148,
                          1,
                        ).withOpacity(0.1),
                        alignLabelWithHint: true, // Align label for multiline
                        icon: const Icon(
                          Icons.description_outlined,
                          size: 20,
                          color: Color.fromARGB(255, 103, 96, 45),
                        ),
                        errorText: widget.errorText,
                        errorStyle: const TextStyle(
                          color: Colors.red,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        labelText: widget.textfieldvalue ?? "Description",
                        labelStyle: const TextStyle(fontSize: 13),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Colors.black,
                            width: 1,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(0),
                          borderSide: const BorderSide(
                            color: Colors.black,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              : (widget.textfieldvalue ==
                        "Registration Number will add automatically"
                    ? Padding(
                        padding: const EdgeInsets.all(10),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          width: widget.width,
                          height: widget.height,
                          child: TextField(
                            enabled: widget.enabled,
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
                                Icons.supervised_user_circle_outlined,
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
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: Colors.black,
                                  width: 1,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(100),
                                borderSide: const BorderSide(
                                  color: Colors.black,
                                  width: 2,
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    : (Padding(
                        padding: const EdgeInsets.all(10),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          width: widget.width,
                          height: widget.height,
                          child: TextField(
                            enabled: widget.enabled,
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
                                Icons.title_rounded,
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
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(
                                  color: Colors.black,
                                  width: 1,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(100),
                                borderSide: const BorderSide(
                                  color: Colors.black,
                                  width: 2,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ))));
  }
}
