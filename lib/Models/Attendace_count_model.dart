class AttendaceCountModel {
  int? lectures_count;
  String? semester;
  int? semversion_count;
  int? student_count;
  String? subject;
  String? year;
  AttendaceCountModel({
    this.subject,
    this.year,
    this.semversion_count,
    this.student_count,
    this.semester,
    this.lectures_count,
  });

  static fromJson(e) {}
}
