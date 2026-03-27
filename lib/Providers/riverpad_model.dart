import 'package:attendance_system_flutter_application/Models/Attendance_History_model.dart';
import 'package:attendance_system_flutter_application/Models/UserDetailsModel.dart';
import 'package:flutter/material.dart';

class RiverpodUserModel extends ChangeNotifier {
  List<UserDeatilsModel> UserData = [];
  List<dynamic> AttendaceHistory_passed = [];
  List<AttendanceHistoryModel> AttendaceHistory = [];
  String? name = "ALEX";
  bool isLoading = false;

  RiverpodUserMode() {}

  void AttendanceHistoryData_Add({required List<dynamic> AttendaceHistory}) {
    AttendaceHistory_passed = AttendaceHistory;
    AttendanceHistoryData_Add_withmodel();
  }

  void AttendanceHistoryData_Add_withmodel() {
    AttendaceHistory.clear();
    for (var historydata in AttendaceHistory_passed) {
      AttendaceHistory.add(
        AttendanceHistoryModel(
          topic: historydata['topic'],
          topicdescription: historydata['topicdescription'],
          date: historydata['date'],
          semester: historydata['semester'],
          subject: historydata['subject'],
          time: historydata['time'],
          year: historydata['year'],
        ),
      );
    }
    notifyListeners();
  }

  void setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  void UserData_Add({
    //required List<UserDeatilsModel>? ListData
    required String id,
    required String initialname,
    required String fullname,
    required String email,
    required String degreename,
    required String faculty,
    required String department,
    required String mobilenumber,
    required String year,
    required String semester,
    required String registernumber,
    required String userImage,
    required String? birthday,
  }) {
    UserData?.add(
      UserDeatilsModel(
        id: id,
        degreename: degreename,
        email: email,
        faculty: faculty,
        fullname: fullname,
        initialname: initialname,
        mobilenumber: mobilenumber,
        department: department,
        semester: semester,
        year: year,
        registernumber: registernumber,
        userimage: userImage,
        birthday: birthday
      ),
    );
    // UserData = ListData;
    notifyListeners();
  }

  void clearUserData() {
    UserData = [];
  }
}
