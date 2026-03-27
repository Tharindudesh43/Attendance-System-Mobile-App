import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:attendance_system_flutter_application/Pages/DiscoverPage.dart';
import 'package:attendance_system_flutter_application/Pages/Personal_Info.dart';
import 'package:attendance_system_flutter_application/Providers/riverpod.dart';
import 'package:attendance_system_flutter_application/Services/Firebase_Services.dart';
import 'package:attendance_system_flutter_application/Widgets/Logout_Box.dart';
import 'package:attendance_system_flutter_application/Widgets/contact_us_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  String? selectedacademicyear;
  String? selectedsemester;
  bool isloadingchnage = false;

  final academicyear = ['1st Year', '2nd Year', '3rd Year', '4th Year'];

  final semesterList = {
    '1st Year': ['1st Semester', '2nd Semester'],
    '2nd Year': ['1st Semester', '2nd Semester'],
    '3rd Year': ['1st Semester', '2nd Semester'],
    '4th Year': ['1st Semester', '2nd Semester'],
  };

  @override
  void initState() {
    super.initState();
    FirebaseServices.getCurrent_User_Details().then((value) {
      ref
          .read(riverpodUserData)
          .UserData_Add(
            birthday: value[0].birthday.toString(),
            id: value[0].id.toString(),
            initialname: value[0].initialname.toString(),
            fullname: value[0].fullname.toString(),
            email: value[0].email.toString(),
            degreename: value[0].degreename.toString(),
            faculty: value[0].faculty.toString(),
            department: value[0].department.toString(),
            mobilenumber: value[0].mobilenumber.toString(),
            year: value[0].year.toString(),
            semester: value[0].semester.toString(),
            registernumber: value[0].registernumber.toString(),
            userImage: value[0].userimage.toString(),
          );
    });
  }

  Future<void> showInitDialog() async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              scrollable: true,
              title: const Text(
                "IMPORTANT:",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "You need to match profile settings with your current academic year and semester.",
                    ),
                    const SizedBox(height: 20),

                    // Category dropdown
                    DropdownButtonFormField<String>(
                      value: selectedacademicyear,
                      decoration: _decoration(
                        label: 'Academic Year',
                        icon: Icons.category_rounded,
                      ),
                      isExpanded: true,
                      icon: const Icon(Icons.keyboard_arrow_down_rounded),
                      borderRadius: BorderRadius.circular(14),
                      items: academicyear
                          .map(
                            (e) => DropdownMenuItem<String>(
                              value: e,
                              child: Text(
                                e,
                                style: const TextStyle(fontSize: 15),
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (val) {
                        setState(() {
                          selectedacademicyear = val;
                          selectedsemester =
                              null; // reset sub if category changes
                        });
                      },
                      validator: (val) =>
                          val == null ? 'Select a category' : null,
                    ),

                    const SizedBox(height: 20),

                    // Sub-category dropdown (depends on category)
                    DropdownButtonFormField<String>(
                      value: selectedsemester,
                      decoration: _decoration(
                        label: 'Semester',
                        icon: Icons.list_alt_rounded,
                      ),
                      isExpanded: true,
                      icon: const Icon(Icons.keyboard_arrow_down_rounded),
                      borderRadius: BorderRadius.circular(14),

                      // 👇 Only show items if category is selected
                      items: (selectedacademicyear == null)
                          ? []
                          : semesterList[selectedacademicyear]!
                                .map(
                                  (e) => DropdownMenuItem<String>(
                                    value: e,
                                    child: Text(
                                      e,
                                      style: const TextStyle(fontSize: 15),
                                    ),
                                  ),
                                )
                                .toList(),

                      onChanged: (val) =>
                          setState(() => selectedsemester = val),

                      validator: (val) =>
                          val == null ? 'Select a sub-category' : null,
                      disabledHint: const Text('Select semester first'),
                    ),
                  ],
                ),
              ),
              actions: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 28, 123, 131),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: const Text(
                    "Close",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  onPressed: () {
                    if (selectedacademicyear == null ||
                        selectedsemester == null) {
                      Flushbar(
                        message: "Select Both Fields",
                        icon: Icon(
                          Icons.info_rounded,
                          size: 28.0,
                          color: Color.fromRGBO(197, 21, 21, 1),
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
                        leftBarIndicatorColor: Color.fromRGBO(197, 118, 7, 1),
                        messageColor: Colors.black,
                      ).show(context);
                    } else {
                      setState(() {
                        isloadingchnage = true;
                      });
                      FirebaseServices firebaseServices =
                          new FirebaseServices();
                      firebaseServices.ChangeYearandSemester(
                        year: selectedacademicyear!,
                        semester: selectedsemester!,
                      ).then((value) {
                        if (value ==
                            'User year and semester changed successfully') {
                          Navigator.of(context).pop(true);
                          Flushbar(
                            message:
                                "User year and semester changed successfully",
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
                            isloadingchnage = false;
                          });
                        } else {
                          Navigator.of(context).pop(true);
                          Flushbar(
                            message: "Error Occured While Changing !",
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
                            isloadingchnage = false;
                          });
                        }
                      });
                    }
                  },
                  child: Text(
                    isloadingchnage ? "Loading..." : "Change",
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Common decoration to keep styles consistent
  InputDecoration _decoration({required String label, required IconData icon}) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      filled: true,
      fillColor: Colors.grey.shade100,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.blue, width: 1.4),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.red, width: 1.4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        color: Colors.transparent,
        child: Stack(
          children: [
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 250,
                      decoration: const BoxDecoration(
                        color: Colors.transparent,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                border: Border.all(
                                  width: 3,
                                  color: Colors.white,
                                ),
                              ),
                              child: CircleAvatar(
                                radius: 30,
                                backgroundImage: NetworkImage(
                                  (ref.watch(riverpodUserData).UserData ==
                                              null ||
                                          ref
                                              .watch(riverpodUserData)
                                              .UserData
                                              .isEmpty
                                      ? "https://www.pngall.com/wp-content/uploads/5/Profile-PNG-High-Quality-Image.png"
                                      : ref
                                                .watch(riverpodUserData)
                                                .UserData[0]
                                                .userimage ??
                                            "https://www.pngall.com/wp-content/uploads/5/Profile-PNG-High-Quality-Image.png"),
                                ),
                                backgroundColor: Colors.transparent,
                              ),
                            ),
                          ),
                          (ref.watch(riverpodUserData).UserData == null ||
                                  ref.watch(riverpodUserData).UserData.isEmpty)
                              ? Text(
                                  "Loading..",
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    fontWeight: FontWeight.w700,
                                    fontSize: 17,
                                  ),
                                )
                              : Text(
                                  ref
                                          .watch(riverpodUserData)
                                          .UserData[0]
                                          .degreename ??
                                      "No Data",
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 253, 253, 253),
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                  ),
                                ),
                          (ref.watch(riverpodUserData).UserData == null ||
                                  ref.watch(riverpodUserData).UserData.isEmpty)
                              ? Text(
                                  "Loading..",
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    fontWeight: FontWeight.w700,
                                    fontSize: 17,
                                  ),
                                )
                              : Text(
                                  ref
                                          .watch(riverpodUserData)
                                          .UserData[0]
                                          .initialname ??
                                      "No Name",
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 253, 253, 253),
                                    fontWeight: FontWeight.w700,
                                    fontSize: 17,
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25, right: 25, top: 70),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: [
                        // Personal Informations
                        _buildTile(
                          icon: Icons.person_2_outlined,
                          text: "Personal Informations",
                          iconColor: const Color.fromRGBO(2, 109, 148, 1),
                        ),

                        // Edit Details
                        _buildTile(
                          icon: Icons.edit_document,
                          text: "Edit Details",
                          iconColor: const Color.fromRGBO(2, 109, 148, 1),
                        ),

                        // Contact Us
                        _buildTile(
                          icon: Icons.perm_contact_cal_outlined,
                          text: "Contact Us",
                          iconColor: const Color.fromRGBO(2, 109, 148, 1),
                        ),

                        // Logout
                        _buildTile(
                          icon: Icons.logout_sharp,
                          text: "Logout",
                          iconColor: Colors.red,
                          textColor: Colors.red,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              top: 215,
              left: 13,
              right: 13,
              child: Padding(
                padding: const EdgeInsets.all(0.0),
                child: Container(
                  width: MediaQuery.of(context).size.width - 20,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  // Optional: Add child widgets (like a Text or Icon) here
                  child: Center(
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 20, 128, 77),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () => {showInitDialog()},
                      child: const Text(
                        "Important Setting Change",
                        style: TextStyle(
                          color: Color.fromARGB(255, 255, 255, 255),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
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

  // ✅ Reusable tile builder
  Widget _buildTile({
    required IconData icon,
    required String text,
    Color iconColor = Colors.black,
    Color textColor = Colors.black,
  }) {
    return InkWell(
      hoverColor: Colors.grey,
      onTap: () {
        if (text == "Logout") {
          showDialog(
            context: context,
            builder: (context) => LogoutDialog(
              userImageUrl: ref.watch(riverpodUserData).UserData[0].userimage,
            ),
          );
        } else if (text == "Personal Informations") {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (contextpassed, animation, persnalAnimation) =>
                  PersonalInfo(),
              transitionsBuilder:
                  (contextpassed, animation, persnalAnimation, child) {
                    return FadeTransition(opacity: animation, child: child);
                  },
            ),
          ).then((value) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Discoverpage(pagenumber: 3),
              ),
            );
          });
        } else if (text == "Contact Us") {
          showDialog(context: context, builder: (context) => ContactUsBox());
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 5, right: 5),
        child: Container(
          padding: const EdgeInsets.all(10.0),
          width: MediaQuery.of(context).size.width,
          height: 60,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(icon, size: 25, color: iconColor),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Text(
                          text,
                          style: TextStyle(fontSize: 16, color: textColor),
                        ),
                      ),
                    ],
                  ),
                  const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 25,
                    color: Color.fromRGBO(179, 179, 179, 1),
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
