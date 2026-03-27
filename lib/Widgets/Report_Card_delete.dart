import 'package:another_flushbar/flushbar.dart';
import 'package:attendance_system_flutter_application/Providers/riverpod.dart';
import 'package:attendance_system_flutter_application/Services/Firebase_Services.dart';
import 'package:attendance_system_flutter_application/Services/MongoDB_Services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReportCardDelete extends ConsumerStatefulWidget {
  String reportId;
  List<dynamic> imagesUrls;
  ReportCardDelete({Key? key, required this.reportId, required this.imagesUrls})
    : super(key: key);

  @override
  ConsumerState<ReportCardDelete> createState() => _ReportCardDeleteState();
}

class _ReportCardDeleteState extends ConsumerState<ReportCardDelete> {
  bool isLoading = false;

  void _handledeletereport() async {
    setState(() {
      isLoading = true;
    });

    FirebaseServices FirebaseServicesObject = new FirebaseServices();
    MongodbServices MongodbServicesObject = new MongodbServices();

    FirebaseServicesObject.deleteImagesFromCloudinary(
      imageUrls: widget.imagesUrls,
    ).then((value) {
      if (value == "Images deleted successfully") {
        FirebaseServicesObject.deletereport(
          reportId: widget.reportId.toString(),
        ).then((onValue) {
          // print((onValue as Map)["message"]);
          if (onValue == 'User report deleted successfully (Firebase)') {
            MongodbServicesObject.deletereport(
              reportId: widget.reportId.toString(),
            ).then((result) {
              if (result == 'Report deleted successfully') {
                setState(() {
                  isLoading = false;
                });
                Navigator.of(context).pop();
                Flushbar(
                  message: "Report deleted successfully!",
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
                ref.refresh(userreportProvider);
              } else if (result == 'Report not found') {
                setState(() {
                  isLoading = false;
                });
                Navigator.of(context).pop();
                Flushbar(
                  message: "Report not found!",
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
                ref.refresh(userreportProvider);
              } else if (result == 'error report delete (Admin)') {
                setState(() {
                  isLoading = false;
                });
                Navigator.of(context).pop();
                Flushbar(
                  message: "Error deleting report (Admin)!",
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
                ref.refresh(userreportProvider);
              }
            });
          } else {
            setState(() {
              isLoading = false;
            });
            Navigator.of(context).pop();
            Flushbar(
              message:
                  onValue == 'No internet connection. Please try again(report)'
                  ? "No internet connection. Please try again"
                  : onValue == 'Request timed out. Please try again(report)'
                  ? "Request timed out. Please try again"
                  : onValue == 'Report deletion failed(report)'
                  ? "Report deletion failed. Please try again"
                  : onValue.toString(),
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
          ref.refresh(userreportProvider);
        });
      } else if (value == 'No images selected') {
        setState(() {
          isLoading = false;
        });
        Navigator.of(context).pop();
        Flushbar(
          message: "No images selected to delete.",
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
        ref.refresh(userreportProvider);
      } else if (value == "Failed to delete images") {
        setState(() {
          isLoading = false;
        });
        Navigator.of(context).pop();
        Flushbar(
          message: "Failed to delete images.",
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
        ref.refresh(userreportProvider);
      } else {
        Navigator.of(context).pop();
        Flushbar(
          message:
              value.toString() == 'No internet connection. Please try again'
              ? 'No internet connection. Please try again'
              : value.toString() == 'Request timed out. Please try again'
              ? 'Request timed out. Please try again'
              : 'An unexpected error occurred. Please try again.',
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
        ref.refresh(userreportProvider);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shadowColor: Colors.white.withOpacity(0.5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Colors.white,
      child: SizedBox(
        width: 300,

        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(),
                child: Text(
                  textAlign: TextAlign.center,
                  "Do you need to Delete this Report ?",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromRGBO(2, 109, 148, 1),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(2, 109, 148, 1),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text(
                      'Close',
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ),
                  InkWell(
                    onTap: isLoading ? null : () => _handledeletereport(),
                    child: Container(
                      width: 80,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Colors.red,
                      ),
                      child: Center(
                        child: isLoading
                            ? const SizedBox(
                                width: 15,
                                height: 15,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                "Confirm",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
