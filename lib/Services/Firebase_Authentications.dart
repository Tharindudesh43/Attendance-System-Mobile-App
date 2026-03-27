import 'package:attendance_system_flutter_application/Services/Firebase_Services.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthentications {
  //User signin
  Future<dynamic> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return "success";
    } on FirebaseAuthException catch (error) {
      if (error.code == "invalid-credential") {
        return "invalid-credential";
      } else {
        print("Error While SignIn: " + error.code);
        return error.code;
      }
    }
  }

  //User Sign Up
  Future<String?> signup({
    required String userimageUrl,
    required String fullname,
    required String namewithinitial,
    required String email,
    required String password,
    required String degreename,
    required String faculty,
    required String department,
    required String mobilenumber,
    required String birthday,
    required String registrationnumber,
    required String Year,
    required String Semester,
    required List attendance_history,
    required List reports,
    required List notifications
  }) async {
    try {
      // Attempt to create a new user with email and password
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Add user details to Firestore or another service
      FirebaseServices firebaseServicesObject = new FirebaseServices();
      await firebaseServicesObject.addSignUpUser(
        userimageUrl: userimageUrl,
        attendance_history: attendance_history,
        fullname: fullname,
        initialwithname: namewithinitial,
        email: email,
        degreename: degreename,
        faculty: faculty,
        department: department,
        mobilenumber: mobilenumber,
        birthday: birthday,
        year: Year,
        semester: Semester,
        registernumber: registrationnumber,
        reports: reports,
        notifications: notifications
      );
      // }
      //  });

      return "User Added";
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        print('Email is already in use.');
        return "email-already-in-use";
      } else {
        print('FirebaseAuthException: $e');
        return e.code.toString();
      }
    } catch (e) {
      // Handle any other exceptions
      print("Error: $e");
      return e.toString();
    }
  }
}
