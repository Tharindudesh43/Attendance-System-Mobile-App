import 'package:attendance_system_flutter_application/Pages/DiscoverPage.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

// ignore: must_be_immutable
class ScanResultUI extends StatefulWidget {
  int selectedIndex;
  String topic;
  String topicdescription;

  ScanResultUI({
    super.key,
    required this.selectedIndex,
    required this.topic,
    required this.topicdescription,
  });

  @override
  State<ScanResultUI> createState() => _ScanResultUIState();
}

class _ScanResultUIState extends State<ScanResultUI> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      child: Lottie.asset(
                        repeat: true,
                        height: 400,
                        width: MediaQuery.sizeOf(context).width - 50,
                        widget.selectedIndex == 5
                            ? "assets/animations/NotFound_Animations.json"
                            : widget.selectedIndex == 3
                            ? "assets/animations/TimeOut_Animation.json"
                            : widget.selectedIndex == 7
                            ? "assets/animations/DuplicateScan_Animation.json"
                            : widget.selectedIndex == 1
                            ? "assets/animations/Completed_Animation.json"
                            : "assets/animations/NotFound_Animations.json",
                      ),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      textAlign: TextAlign.center,
                      widget.selectedIndex == 5
                          ? "Not Valid QR Code"
                          : widget.selectedIndex == 3
                          ? "Opps.. Time Out !"
                          : widget.selectedIndex == 4
                          ? "Not Matching With Your Academic Year or Semster"
                          : widget.selectedIndex == 7
                          ? "Duplicate Scanning"
                          : widget.selectedIndex == 1
                          ? "Attendance Marked! \nTopic: ${widget.topic}"
                          : "Something went wrong",
                      style: TextStyle(
                        color: widget.selectedIndex == 1
                            ? widget.selectedIndex == 4
                                  ? const Color.fromARGB(255, 14, 80, 223)
                                  : Colors.green
                            : const Color.fromARGB(255, 223, 14, 14),
                        fontSize: widget.selectedIndex == 1 ? 20 : 23,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: FloatingActionButton.extended(
                        onPressed: () {
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (context) => Discoverpage(pagenumber: 1),
                            ), // Replace with your main page widget
                            (route) => false,
                          );
                        },
                        label: Padding(
                          padding: const EdgeInsets.only(left: 15, right: 15),
                          child: Text(
                            'Done',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        backgroundColor: Color.fromRGBO(2, 109, 148, 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            30,
                          ), // Makes it pill-shaped
                        ),
                      ),
                    ),
                    //)
                  ],
                ),
              ],
            ),
          ),
          IgnorePointer(
            child: Lottie.asset(
              fit: BoxFit.cover,
              repeat: false,
              height: MediaQuery.sizeOf(context).height,
              width: MediaQuery.sizeOf(context).width,
              "assets/animations/Confettie_Animation.json",
            ),
          ),
        ],
      ),
    );
  }
}
