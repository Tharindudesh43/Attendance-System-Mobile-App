import 'package:mongo_dart/mongo_dart.dart';

class MongodbServices {
  static const COLLECTION_NAME = "At_admin_lecturer_details";
  static Db? db;
  static final DbCollection user = db!.collection('At_admin_lecturer_details');

  static Future<Db> connect() async {
    var db = await Db.create(
      'mongodb+srv://tharindudeshanhimahansa43:TfA6q3iUaaI8Tdw9@atsyscluster0.zzmn1.mongodb.net/AttendanceSystem?retryWrites=true&w=majority&appName=AtSysCluster0',
    );
    await db.open();
    print("✅ Connected to MongoDB");
    return db;
  }

  static Future<void> close() async {
    try {
      await db!.close();
    } catch (e) {
      print(e.toString());
    }
  }

  static Future<String?> insertattendace({
    required String currentime,
    required String feedback,
    required int rating,
    required String registerno,
    required String Qrcode,
    required String year,
    required String initialname,
    required String id,
  }) async {
    try {
      final db = await connect();
      final collection = db.collection('At_admin_lecturer_details');
      final objId = ObjectId.parse(id);
      final user = await collection.findOne(where.eq('_id', objId));

      var checklist = [];

      final attendacedata = [
        registerno,
        initialname,
        rating,
        feedback,
        currentime,
      ];

      if (user != null) {
        final List<dynamic> attendance = user['attendance'];
        // attendance[1][0][0][9].add(attendacedata);

        if (year == '1stYear') {
          checklist = attendance[0];
          checklist.forEach((element) {
            if (element[0][0] == Qrcode) {
              print("SSSSSSS");
              element[0][11].add(attendacedata);
            }
          });
          //attendance[0][0][0][9].add(attendacedata);
        } else if (year == '2ndYear') {
          checklist = attendance[1];
          checklist.forEach((element) {
            if (element[0][0] == Qrcode) {
              print("SSSSSSS");
              element[0][11].add(attendacedata);
            }
          });
          //attendance[1][0][0][9].add(attendacedata);
        } else if (year == '3rdYear') {
          checklist = attendance[2];
          checklist.forEach((element) {
            if (element[0][0] == Qrcode) {
              print("SSSSSSS");
              element[0][11].add(attendacedata);
            }
          });
          //attendance[2][0][0][9].add(attendacedata);
        } else if (year == '4thYear') {
          checklist = attendance[3];
          checklist.forEach((element) {
            if (element[0][0] == Qrcode) {
              print("SSSSSSS");
              element[0][11].add(attendacedata);
            }
          });
          //attendance[3][0][0][9].add(attendacedata);
        }

        await collection.updateOne(
          where.eq('_id', objId),
          modify.set('attendance', attendance),
          // modify.push('attendance', newSubject),
        );

        await db.close();
        print("❎ Connection closed");
        return "Added Attendance";
        //print("✅ Lecturer found: ${user['attendance'][1][0][0][9]}");
      } else {
        print("Lecturer not found");
        await db.close();
        print("❎ Connection closed");
        return "Lecturer not found";
      }
    } catch (e) {
      print("❌ Error inserting attendance: $e");
      return "error attendace";
    }
  }

  static Future<String?> duplicatecheck({
    required String QrCode,
    required String Year,
    required String LecId_By_Qr,
    required String RegisterNo,
    required String Name,
  }) async {
    try {
      print(LecId_By_Qr);
      final db = await connect();
      final collection = db.collection('At_admin_lecturer_details');

      final objId = ObjectId.parse(LecId_By_Qr);
      final user = await collection.findOne(where.eq('_id', objId));
      var dupchecklist = [];
      var checklistattendace = [];
      var dupcheck_int = 0;

      if (user != null) {
        final List<dynamic> attendance = user['attendance'];
        if (Year == '1stYear') {
          dupchecklist = attendance[0];
          if (dupchecklist.length == 0) {
            print("Zero List");
            return "Zero List";
          } else {
            dupchecklist = attendance[0];
            dupchecklist.forEach((element) {
              if (element[0][0] == QrCode) {
                checklistattendace = element[0][11];
                print(checklistattendace);
                checklistattendace.forEach((ccc) {
                  if (ccc[0] == RegisterNo && ccc[1] == Name) {
                    dupcheck_int++;
                  }
                });
              }
            });
            if (dupcheck_int == 0) {
              print("No Duplicates");
              return "No Duplicates";
            } else {
              print("Duplicates Found");
              return "Duplicates Found";
            }
          }
        } else if (Year == '2ndYear') {
          dupchecklist = attendance[1];
          if (dupchecklist.length == 0) {
            print("Zero List");
            return "Zero List";
          } else {
            dupchecklist = attendance[1];
            print("LLLLLLLLLLL");
            dupchecklist.forEach((element) {
              if (element[0][0] == QrCode) {
                checklistattendace = element[0][11];
                print(checklistattendace);
                checklistattendace.forEach((ccc) {
                  if (ccc[0] == RegisterNo && ccc[1] == Name) {
                    dupcheck_int++;
                  }
                });
              }
            });
            if (dupcheck_int == 0) {
              print("No Duplicates");
              return "No Duplicates";
            } else {
              print("Duplicates Found");
              return "Duplicates Found";
            }
          }
        } else if (Year == '3rdYear') {
          dupchecklist = attendance[2];
          if (dupchecklist.length == 0) {
            print("Zero List");
            return "Zero List";
          } else {
            dupchecklist = attendance[2];
            dupchecklist.forEach((element) {
              if (element[0][0] == QrCode) {
                checklistattendace = element[0][11];
                print(checklistattendace);
                checklistattendace.forEach((ccc) {
                  if (ccc[0] == RegisterNo && ccc[1] == Name) {
                    dupcheck_int++;
                  }
                });
              }
            });
            if (dupcheck_int == 0) {
              print("No Duplicates");
              return "No Duplicates";
            } else {
              print("Duplicates Found");
              return "Duplicates Found";
            }
          }
        } else if (Year == '4thYear') {
          dupchecklist = attendance[3];
          if (dupchecklist.length == 0) {
            print("Zero List");
            return "Zero List";
          } else {
            dupchecklist = attendance[3];
            dupchecklist.forEach((element) {
              if (element[0][0] == QrCode) {
                checklistattendace = element[0][11];
                print(checklistattendace);
                checklistattendace.forEach((ccc) {
                  if (ccc[0] == RegisterNo && ccc[1] == Name) {
                    dupcheck_int++;
                  }
                });
              }
            });
            if (dupcheck_int == 0) {
              print("No Duplicates");
              return "No Duplicates";
            } else {
              print("Duplicates Found");
              return "Duplicates Found";
            }
          }
        }
      } else {
        print("Lecturer not found");
        return "Lecturer not found";
      }
      await db.close();
      print("❎ Connection closed");
      //return "ds";
    } catch (e) {
      print("Error in duplicatecheck: $e");
      return "error";
    }
  }

  Future<String?> insertreport({
    required String reportId,
    required bool anonymity,
    required String title,
    required String description,
    required String date,
    required String time,
    required List<String> images,
    required String status,
    required String report_type,
    String? registrationnumber,
    String? student_email,
    String? userId,
  }) async {
    try {
      Map<String, dynamic> newReport;
      if (anonymity == true) {
        newReport = {
          "reportId": reportId,
          "report_title": title,
          "report_description": description,
          "images": images,
          "status": status,
          "user": "Anonymous",
          "report_type": report_type,
          "student_email": "Anonymous",
          "time_of_report": time,
          "date_of_report": date,
          "user_id": userId,
        };
      } else {
        newReport = {
          "reportId": reportId,
          "report_title": title,
          "report_description": description,
          "images": images,
          "status": status,
          "user": registrationnumber,
          "report_type": report_type,
          "student_email": student_email,
          "time_of_report": time,
          "date_of_report": date,
          "user_id": userId,
        };
      }
      print(newReport);
      ;
      final db = await connect();
      final collection = db.collection('At_Reports');

      await collection.insertOne(newReport);

      await db.close();
      return "report submitted to mongodb";
    } catch (e) {
      print("❌ Error inserting report: $e");
      return "error report submit";
    }
  }

  Future<String> deletereport({required String reportId}) async {
    try {
      final db = await connect();
      final collection = db.collection('At_Reports');

      final result = await collection.deleteOne(where.eq('reportId', reportId));

      if (result.nRemoved == 1) {
        await db.close();
        return "Report deleted successfully";
      } else {
        await db.close();
        return "Report not found";
      }
    } catch (e) {
      print("❌ Error deleting report: $e");
      return "error report delete (Admin)";
    }
  }
}
