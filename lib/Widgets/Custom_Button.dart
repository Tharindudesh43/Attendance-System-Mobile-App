import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  late String btntype;
  late String btnText;
  late int selecter;
  final GestureTapCallback? onTap;
  bool? isloadinggoogle = false;
  bool? isloadingnormal = false;
  CustomButton({
    super.key,
    required this.btntype,
    required this.btnText,
    required this.selecter,
    this.onTap,
    this.isloadingnormal,
    this.isloadinggoogle,
  });

  @override
  Widget build(BuildContext context) {
    return btntype == "Google"
        ? InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 80),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(color: Colors.black),
                  color: const Color.fromARGB(98, 255, 255, 255),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 0,
                    right: 0,
                    top: 14,
                    bottom: 14,
                  ),
                  child: isloadinggoogle!
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: Center(
                            child: SizedBox(child: CircularProgressIndicator()),
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(width: 10),
                            Text(
                              selecter == 1
                                  ? "LOG IN with Google"
                                  : "SIGN UP with Google",
                            ),
                          ],
                        ),
                ),
              ),
            ),
          )
        : InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: const Color.fromRGBO(2, 109, 148, 1),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 90,
                    right: 90,
                    top: 15,
                    bottom: 15,
                  ),
                  child: isloadingnormal!
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: Center(
                            child: SizedBox(child: CircularProgressIndicator()),
                          ),
                        )
                      : Text(
                          btnText,
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
            ),
          );
  }
}
