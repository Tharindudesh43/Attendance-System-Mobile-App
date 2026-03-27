class ReportHistoryModel {
  String? title;
  String? description;
  String? status;
  String? date;
  String? time;
  String? report_type;
  String? student_email;
  List<String>? images;

  ReportHistoryModel({
    this.title,
    this.description,
    this.status,
    this.date,
    this.time,
    this.report_type,
    this.student_email,
    this.images,
  });

  static fromJson(e) {}
}
