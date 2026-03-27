class AttendanceHistoryModel {
  String? subject;
  String? year;
  String? semester;
  String? date;
  String? time;
  String? topic;
  String? topicdescription;

  AttendanceHistoryModel({
    this.topic,
    this.topicdescription,
    this.subject,
    this.year,
    this.semester,
    this.date,
    this.time,
  });

  static fromJson(e) {}
}
