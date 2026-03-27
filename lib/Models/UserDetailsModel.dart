class UserDeatilsModel {
  String? id;
  String? initialname;
  String? fullname;
  String? email;
  String? degreename;
  String? faculty;
  String? department;
  String? mobilenumber;
  String? registernumber;
  String? year;
  String? semester;
  List? attendance_history;
  List? reports;
  String? birthday;
  String? userimage;
  List? attendance_count;

  UserDeatilsModel({
    this.id,
    this.initialname,
    this.fullname,
    this.email,
    this.degreename,
    this.faculty,
    this.department,
    this.mobilenumber,
    this.registernumber,
    this.semester,
    this.year,
    this.attendance_history,
    this.reports,
    this.userimage,
    this.birthday,
    this.attendance_count,
  });
}
