import 'package:attendance_system_flutter_application/Providers/riverpod.dart';
import 'package:attendance_system_flutter_application/Widgets/DataLable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PersonalInfo extends ConsumerStatefulWidget {
  const PersonalInfo({super.key});

  @override
  ConsumerState<PersonalInfo> createState() => _PersonalInfoState();
}

class _PersonalInfoState extends ConsumerState<PersonalInfo> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(2, 109, 148, 1),
        title: Text("Personal Informations", style: TextStyle(fontSize: 18)),
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                flex: 1,
                child: Container(color: Color.fromRGBO(2, 109, 148, 1)),
              ),
              Expanded(
                flex: 4,
                child: Container(color: Color.fromRGBO(245, 245, 245, 1)),
              ),
            ],
          ),
          Positioned(
            top: 0,
            left: 15,
            right: 15,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  child: Container(
                    padding: EdgeInsets.all(15),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Personal Details",
                                style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            DataLable(
                              DataLableTitle: "Initial Name",
                              DataLableDetail: ref
                                  .watch(riverpodUserData)
                                  .UserData![0]
                                  .initialname
                                  .toString(),
                            ),
                            DataLable(
                              DataLableTitle: "Full Name",
                              DataLableDetail: ref
                                  .watch(riverpodUserData)
                                  .UserData![0]
                                  .fullname
                                  .toString(),
                            ),
                            DataLable(
                              DataLableTitle: "Registration Number",
                              DataLableDetail: ref
                                  .read(riverpodUserData)
                                  .UserData![0]
                                  .registernumber
                                  .toString(),
                            ),
                            DataLable(
                              DataLableTitle: "Email",
                              DataLableDetail: ref
                                  .read(riverpodUserData)
                                  .UserData![0]
                                  .email
                                  .toString(),
                            ),
                            DataLable(
                              DataLableTitle: "Date of Birth",
                              DataLableDetail: ref
                                  .read(riverpodUserData)
                                  .UserData![0]
                                  .birthday
                                  .toString(),
                            ),
                            DataLable(
                              DataLableTitle: "Mobile Number",
                              DataLableDetail: ref
                                  .watch(riverpodUserData)
                                  .UserData![0]
                                  .mobilenumber
                                  .toString(),
                            ),
                            DataLable(
                              DataLableTitle: "Year",
                              DataLableDetail: ref
                                  .watch(riverpodUserData)
                                  .UserData![0]
                                  .year
                                  .toString(),
                            ),
                            DataLable(
                              DataLableTitle: "Semester",
                              DataLableDetail: ref
                                  .watch(riverpodUserData)
                                  .UserData![0]
                                  .semester
                                  .toString(),
                            ),
                            DataLable(
                              DataLableTitle: "Degree Name",
                              DataLableDetail: ref
                                  .watch(riverpodUserData)
                                  .UserData![0]
                                  .degreename
                                  .toString(),
                            ),
                            DataLable(
                              DataLableTitle: "Faculty",
                              DataLableDetail: ref
                                  .watch(riverpodUserData)
                                  .UserData![0]
                                  .faculty
                                  .toString(),
                            ),
                            DataLable(
                              DataLableTitle: "Department",
                              DataLableDetail: ref
                                  .watch(riverpodUserData)
                                  .UserData![0]
                                  .department
                                  .toString(),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
