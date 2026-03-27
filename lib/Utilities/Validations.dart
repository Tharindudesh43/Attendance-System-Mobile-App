class Validation {
  final RegExp passwordRegEx =
      RegExp(r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,}$');
  final RegExp emailRegEx = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  final RegExp phoneRegEx = RegExp(r'^\d{10}$');

  checkvalidation({required String FieldValue, required int Fieldnumber}) {
    //Empty Check
    if (FieldValue.isEmpty && Fieldnumber == 1) {
      return "Please fill the full name field";
    } else if (FieldValue.isEmpty && Fieldnumber == 2) {
      return "Please fill the name with initial field";
    } else if (FieldValue.isEmpty && Fieldnumber == 3) {
      return "Please fill the e-mail field";
    } else if (FieldValue.isEmpty && Fieldnumber == 4) {
      return "Please fill the password field";
    } else if (FieldValue.isEmpty && Fieldnumber == 5) {
      return "Please fill the degree name field";
    } else if (FieldValue.isEmpty && Fieldnumber == 6) {
      return "Please fill the mobile \nnumber field";
    } else if (FieldValue.isEmpty && Fieldnumber == 7) {
      return "Please fill the registration \nnumber field";
    } else {
      if (!emailRegEx.hasMatch(FieldValue) && Fieldnumber == 3) {
        return "• Contain only letters, digits or hyphens before @.\n• Contain a valid domain with letters or hyphens after @.\n• At least two characters for the domain extension.";
      }
      if (!passwordRegEx.hasMatch(FieldValue) && Fieldnumber == 4) {
        return "• At least one letter (either lowercase or uppercase).\n• At least one digit.\n• At least one special character (@\$!%*#?&).\n• Minimum length of 8 characters.";
      }
      if (!phoneRegEx.hasMatch(FieldValue) && Fieldnumber == 6) {
        return "• Ensures the phone \n  number contains \n  exactly 10 digits. \n• Contain only \n  numbers";
      } else {
        return null;
      }
    }
  }
}
