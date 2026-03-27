import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:attendance_system_flutter_application/Models/Attendace_count_model.dart';
import 'package:attendance_system_flutter_application/Models/UserDetailsModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class FirebaseServices {
  final String baseUrl = 'https://api.cloudinary.com/v1_1';

  //user image upload
  Future<String> uploadsignUpuserimage({required File? imageFile}) async {
    print("UPLOAD USER IMAGE1");
    if (imageFile == null) {
      return "No image selected";
    }
    final uploadUrl;
    try {
      final url = Uri.parse(
        "https://api.cloudinary.com/v1_1/dgtshju6u/image/upload",
      );
      final request = http.MultipartRequest("POST", url);
      request.fields["upload_preset"] = "user_images";
      request.files.add(
        await http.MultipartFile.fromPath("file", imageFile!.path),
      );

      final response = await request.send().timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw TimeoutException('Upload timed out for one of the image.');
        },
      );

      if (response.statusCode == 200) {
        final responseData = await response.stream.bytesToString();
        final jsonMap = jsonDecode(responseData);
        final secureUrl = jsonMap['secure_url'] as String?;
        if (secureUrl != null) {
          uploadUrl = secureUrl;
          print("UPLOAD USER IMAGE2");
          print('Uploaded URL: $secureUrl');
        } else {
          return "Failed to retrieve secure_url for one of the image";
          // throw Exception(
          //   'Failed to retrieve secure_url for one of the image',
          // );
        }
      } else {
        return "Upload failed with status: 200";
        //throw Exception('Upload failed with status: ${response.statusCode}');
      }

      return uploadUrl;
    } on SocketException catch (e) {
      print("Error uploading image: $e");
      return "No internet connection. Please try again";
    } on TimeoutException catch (e) {
      print("Error uploading image: $e");
      return "Request timed out. Please try again";
    } catch (e) {
      print("Error uploading image: $e");
      return "An unexpected error occurred. Please try again";
    }
  }

  //Add Newly registered user into firebase Firestore
  Future<dynamic> addSignUpUser({
    required String userimageUrl,
    required String fullname,
    required String initialwithname,
    required String email,
    required String degreename,
    required String faculty,
    required String department,
    required String mobilenumber,
    required String birthday,
    required String registernumber,
    required String year,
    required String semester,
    required List attendance_history,
    required List reports,
    required List notifications,
  }) async {
    try {
      CollectionReference userCollectionReference = FirebaseFirestore.instance
          .collection("users");

      DocumentReference docref = await userCollectionReference.add({
        "initialname": initialwithname,
        "fullname": fullname,
        "email": email,
        "degreename": degreename,
        "faculty": faculty,
        "department": department,
        "mobilenumber": mobilenumber,
        "registrationnumber": registernumber,
        "year": year,
        "semester": semester,
        "attendance_history": attendance_history,
        "reports": reports,
        "userImage": userimageUrl,
        "birthday": birthday,
        "notifications": notifications,
      });

      print("user added to firestore");
      return "user added to firestore";
    } catch (e) {
      print("ERRORRRRRR!");
      return e;
    }
  }

  //user token create
  Future<void> saveStudentToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    final user = FirebaseAuth.instance.currentUser;
    final uid = user?.uid; // This is the unique UID from Firebase Auth
    final userDocId = await getCurrentUser();

    final usersCollectionReference = FirebaseFirestore.instance.collection(
      "users",
    );
    var document = await usersCollectionReference.doc(userDocId).get();

    if (token != null) {
      await FirebaseFirestore.instance.collection("users").doc(uid).set({
        "year": document["year"],
        "semester": document["semester"],
        "fcmToken": token,
      }, SetOptions(merge: true));
      print("Token Create");
    }
  }

  //get Current User ID
  static getCurrentUser() async {
    var user = FirebaseAuth.instance.currentUser;
    var currentUserEmail = user!.email;

    final usersCollectionReference = FirebaseFirestore.instance.collection(
      "users",
    );

    QuerySnapshot documents = await usersCollectionReference
        .where('email', isEqualTo: currentUserEmail)
        .get();

    dynamic userDocId = documents.docs[0].id;

    return userDocId;
  }

  //get Current User Details
  static Future<List<dynamic>> getCurrent_User_Details() async {
    try {
      final userDocId = await getCurrentUser();

      final usersCollectionReference = FirebaseFirestore.instance.collection(
        "users",
      );

      List<UserDeatilsModel> Current_User_Details = [];

      var document = await usersCollectionReference.doc(userDocId).get();

      Current_User_Details.add(
        UserDeatilsModel(
          id: document.id,
          degreename: document["degreename"],
          department: document["department"],
          email: document["email"],
          faculty: document["faculty"],
          year: document["year"],
          semester: document["semester"],
          fullname: document["fullname"],
          initialname: document["initialname"],
          mobilenumber: document["mobilenumber"],
          registernumber: document["registrationnumber"],
          attendance_history: document["attendance_history"],
          reports: document["reports"],
          userimage: document["userImage"],
          birthday: document["birthday"],
          attendance_count: document["Count_Attendance"],
        ),
      );
      // print(Current_User_Details[0].attendance_history?[0]["date"]);
      print(Current_User_Details[0].attendance_count);
      print(Current_User_Details);
      return Current_User_Details;
    } catch (e) {
      print("Cant get all to do tasks: $e");
      return [];
    }
  }

  //Add to Firebase attendance History
  static Future<dynamic> addattendancehistory_and_countadd({
    required int rating,
    required String feedback,
    required String subject,
    required String year,
    required String semester,
    required String date,
    required String time,
    required String topic,
    required String topicdescription,
  }) async {
    try {
      CollectionReference userCollectionReference = FirebaseFirestore.instance
          .collection("users");

      final userDocId = await getCurrentUser();
      print("User ID: $userDocId");

      var document = await userCollectionReference.doc(userDocId).get();

      // New data as a Map
      Map<String, String> newAttendance = {
        "subject": subject,
        "year": year,
        "semester": semester,
        "date": date,
        "time": time,
        "topic": topic,
        "topicdescription": topicdescription,
        "rating": rating.toString(),
        "feedback": feedback,
      };

      print("New attendance data: $newAttendance");

      List attendanceHistory = document["attendance_history"] ?? [];
      List count_Attendance_list = document["Count_Attendance"] ?? [];

      attendanceHistory.add(newAttendance);
      print("Updated attendance history: $attendanceHistory");

      int index = count_Attendance_list.indexWhere(
        (item) =>
            item["subject"] == subject &&
            item["semester"] == semester &&
            item["year"] == year,
      );
      if (index != -1) {
        // Record exists, increment count
        count_Attendance_list[index]["student_count"] += 1;
      } else {
        // Record does not exist, add new entry
        count_Attendance_list.add({
          "subject": subject,
          "semester": semester,
          "year": year,
          "student_count": 1,
        });
      }

      await userCollectionReference.doc(userDocId).update({
        'attendance_history': attendanceHistory,
        'Count_Attendance': count_Attendance_list,
      });

      print("Attendance added successfully");
      return "Attendance added successfully";
    } catch (e) {
      print("Error while adding attendance: $e");
      return e;
    }
  }

  Future<dynamic> uploadImagestoCloudinary({
    required File? imageFile1,
    required File? imageFile2,
    required File? imageFile3,
  }) async {
    final files = [
      imageFile1,
      imageFile2,
      imageFile3,
    ].where((file) => file != null).toList();
    if (files.isEmpty) {
      return "No images selected";
    }
    final uploadUrls = <String>[];
    try {
      for (final file in files) {
        final url = Uri.parse(
          "https://api.cloudinary.com/v1_1/dgtshju6u/image/upload",
        );
        final request = http.MultipartRequest("POST", url);
        request.fields["upload_preset"] = "report_students";
        request.files.add(
          await http.MultipartFile.fromPath("file", file!.path),
        );

        final response = await request.send().timeout(
          const Duration(seconds: 30),
          onTimeout: () {
            throw TimeoutException('Upload timed out for one of the images.');
          },
        );

        if (response.statusCode == 200) {
          final responseData = await response.stream.bytesToString();
          final jsonMap = jsonDecode(responseData);
          final secureUrl = jsonMap['secure_url'] as String?;
          if (secureUrl != null) {
            uploadUrls.add(secureUrl);
            print('Uploaded URL: $secureUrl');
          } else {
            throw Exception(
              'Failed to retrieve secure_url for one of the images',
            );
          }
        } else {
          throw Exception('Upload failed with status: ${response.statusCode}');
        }
      }
      return uploadUrls;
    } on SocketException catch (e) {
      print("Error uploading images: $e");
      return "No internet connection. Please try again";
    } on TimeoutException catch (e) {
      print("Error uploading images: $e");
      return "Request timed out. Please try again";
    } catch (e) {
      print("Error uploading images: $e");
      return "An unexpected error occurred. Please try again";
    }
  }

  //delete cloudanary image
  Future<dynamic> deleteImagesFromCloudinary({
    required List<dynamic> imageUrls,
  }) async {
    if (imageUrls.isEmpty) {
      return "No images selected";
    }

    final deleteResults = <String, dynamic>{};

    try {
      final apiKey = dotenv.env['CLOUDINARY_API_KEY'] ?? "";
      final apiSecret = dotenv.env['CLOUDINARY_API_SECRET'] ?? "";
      final cloudName = dotenv.env['CLOUDINARY_CLOUD_NAME'] ?? "";

      if (apiKey.isEmpty || apiSecret.isEmpty || cloudName.isEmpty) {
        throw Exception("Cloudinary credentials missing from .env");
      }

      for (final item in imageUrls) {
        // Extract public_id from URL using regex
        final regex = RegExp(r'upload\/(?:v\d+\/)?(.+)\.[a-zA-Z0-9]+$');
        final match = regex.firstMatch(item);

        if (match == null) {
          throw Exception("Invalid Cloudinary URL: $item");
        }

        final publicId = match.group(1)!;

        // Generate timestamp
        final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
        // Create signature
        final signature = _generateSignature(publicId, timestamp);
        // Construct the API URL
        final url = '$baseUrl/$cloudName/image/destroy';

        // Make the API request
        final response = await http.post(
          Uri.parse(url),
          body: {
            'public_id': publicId,
            'api_key': apiKey,
            'timestamp': timestamp,
            'signature': signature,
          },
        );

        if (response.statusCode == 200) {
          final result = jsonDecode(response.body);
          print('Delete result: $result');
          //return result['result'] == 'ok';
        } else {
          throw Exception('Delete failed with status: ${response.statusCode}');
        }
      }
      return 'Images deleted successfully';
    } on SocketException catch (e) {
      print("Error deleting images: $e");
      return "No internet connection. Please try again";
    } on TimeoutException catch (e) {
      print("Error deleting images: $e");
      return "Request timed out. Please try again";
    } catch (e) {
      print("Error deleting images: $e");
      return "An unexpected error occurred. Please try again";
    }
  }

  String _generateSignature(String publicId, String timestamp) {
    final apiKey = dotenv.env['CLOUDINARY_API_KEY'] ?? "";
    final apiSecret = dotenv.env['CLOUDINARY_API_SECRET'] ?? "";
    final cloudName = dotenv.env['CLOUDINARY_CLOUD_NAME'] ?? "";

    // Create the string to sign
    final toSign = 'public_id=$publicId&timestamp=$timestamp$apiSecret';

    // Generate SHA-1 signature
    final bytes = utf8.encode(toSign);
    final digest = sha1.convert(bytes);
    return digest.toString();
  }

  Future<dynamic> addreport({
    required String title,
    required String description,
    required List<String> images,
    required String status,
    required String date,
    required bool anonymity,
    required String time,
    required String report_type,
  }) async {
    try {
      CollectionReference userCollectionReference = FirebaseFirestore.instance
          .collection("users");

      final reportId = FirebaseFirestore.instance.collection("users").doc().id;

      final userDocId = await getCurrentUser();

      var document = await userCollectionReference.doc(userDocId).get();

      Map<String, dynamic> newReport;

      //email
      String studentEmail = document["email"];

      if (anonymity == true) {
        newReport = {
          "report_id": reportId,
          "title": title,
          "description": description,
          "images": images,
          "status": status,
          "date": date,
          "report_type": report_type,
          "registrationnumber": "Anonymous",
          "user_id": "Anonymous",
          "time": time,
          "student_email": "Anonymous",
        };
      } else {
        newReport = {
          "user_id": userDocId,
          "report_id": reportId,
          "registrationnumber": document["registrationnumber"],
          "title": title,
          "description": description,
          "images": images,
          "status": status,
          "date": date,
          "report_type": report_type,
          "time": time,
          "student_email": studentEmail,
        };
      }

      print("New report data: $newReport");

      List reports = document["reports"] ?? [];
      reports.add(newReport);
      print("Updated reports: $newReport");

      await userCollectionReference.doc(userDocId).update({'reports': reports});

      print("user report added successfully");
      return {
        "message": "user report added successfully",
        "registrationnumber": document["registrationnumber"],
        "studentemail": document["email"],
        "userId": userDocId,
        "reportId": reportId,
      };
    } on SocketException catch (e) {
      print("Error adding report: $e");
      return "No internet connection. Please try again(report)";
    } on TimeoutException catch (e) {
      print("Error adding report: $e");
      return "Request timed out. Please try again(report)";
    } catch (e) {
      print("Error adding report: $e");
      return "report submission failed(report)";
    }
  }

  Future<String> deletereport({required String reportId}) async {
    try {
      CollectionReference userCollectionReference = FirebaseFirestore.instance
          .collection("users");

      final userDocId = await getCurrentUser();

      var document = await userCollectionReference.doc(userDocId).get();

      List reports = document["reports"] ?? [];
      reports.removeWhere((report) => report["report_id"] == reportId);

      await userCollectionReference.doc(userDocId).update({'reports': reports});

      print("User report deleted successfully (Firebase)");
      return "User report deleted successfully (Firebase)";
    } on SocketException catch (e) {
      print("Error deleting report: $e");
      return "No internet connection. Please try again(report)";
    } on TimeoutException catch (e) {
      print("Error deleting report: $e");
      return "Request timed out. Please try again(report)";
    } catch (e) {
      print("Error deleting report: $e");
      return "Report deletion failed(report)";
    }
  }

  Future<dynamic> ChangeYearandSemester({
    required String year,
    required String semester,
  }) async {
    try {
      CollectionReference userCollectionReference = FirebaseFirestore.instance
          .collection("users");

      final userDocId = await getCurrentUser();

      await userCollectionReference.doc(userDocId).update({
        'year': year,
        'semester': semester,
      });

      print("User year and semester changed successfully");
      return "User year and semester changed successfully";
    } on SocketException catch (e) {
      print("Error changing year and semester: $e");
      return "No internet connection. Please try again(change year and semester)";
    } on TimeoutException catch (e) {
      print("Error changing year and semester: $e");
      return "Request timed out. Please try again(change year and semester)";
    } catch (e) {
      print("Error changing year and semester: $e");
      return "Change year and semester failed(change year and semester)";
    }
  }

  //get attendance count
  static Future<List<dynamic>> getattendancecount() async {
    try {
      final userDocId = await getCurrentUser();

      final usersCollectionReference = FirebaseFirestore.instance.collection(
        "users",
      );

      List<AttendaceCountModel> Attendance_Count = [];

      var document = await usersCollectionReference.doc(userDocId).get();

      for (var item in document["Count_Attendance"]) {
        Attendance_Count.add(
          AttendaceCountModel(
            year: item["year"],
            semester: item["semester"],
            subject: item["subject"],
            lectures_count: item["lectures_count"],
            semversion_count: item["semversion"],
            student_count: item["student_count"],
          ),
        );
      }
      // print(Current_User_Details[0].attendance_history?[0]["date"]);
      print(Attendance_Count);
      return Attendance_Count;
    } catch (e) {
      print("Can't get all attendace counts: $e");
      return [];
    }
  }
}
