import 'package:attendance_system_flutter_application/Models/Attendance_History_model.dart';
import 'package:attendance_system_flutter_application/Providers/riverpad_model.dart';
import 'package:attendance_system_flutter_application/Services/Firebase_Services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


final riverpodUserData = ChangeNotifierProvider<RiverpodUserModel>((ref) {
  return RiverpodUserModel(
  );
});


final userHistoryProvider = FutureProvider((ref) async {
  final user = await FirebaseServices.getCurrent_User_Details();
  return user[0].attendance_history!;
});

final userAttendanceCountProvider = FutureProvider((ref) async {
  final user = await FirebaseServices.getCurrent_User_Details();
  return user[0].attendance_count!;
});

final userreportProvider = FutureProvider((ref) async {
  final user = await FirebaseServices.getCurrent_User_Details();
  return user[0].reports!;
});

final usernotificationProvider = FutureProvider((ref) async {
  final user = await FirebaseServices.getCurrent_User_Details();
  return user[0].reports!;
});

