import 'package:flutter/material.dart';

class SettingsProvider extends ChangeNotifier {
  bool _isVisible = false;
  bool get isVisible => _isVisible;

  //strong password requirement
  RegExp strongPassword =
      RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#$&*~]).{8,}$');
  RegExp emailRequirement = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  //fullName validator
  String? validator(String value, String message) {
    if (value.isEmpty) {
      return message;
    } else {
      return null;
    }
  }

  //id validator
  String? idValidator(String value) {
    if (value.isEmpty) {
      return "ID is required";
    } else if (value.length != 10) {
      return "Invalid ID Number";
    } else {
      return null;
    }
  }

  //Email validator
  String? emailValidator(String value) {
    if (value.isEmpty) {
      return "Email is required";
    } else if (!emailRequirement.hasMatch(value)) {
      return "Email is not valid";
    } else {
      return null;
    }
  }

  //birthOfDate validator
  String? dateOfBirthvalidator(String value, String message) {
    if (value.isEmpty) {
      return message;
    } else {
      return null;
    }
  }

  //gender validator
  String? gendervalidator(String value, String message) {
    if (value.isEmpty) {
      return message;
    } else {
      return null;
    }
  }

  //phone number validator
  String? phoneValidator(String value) {
    if (value.isEmpty) {
      return "WhatsApp Number is required";
    } else if (value.length != 10) {
      return "Invalid WhatsApp Number";
    } else {
      return null;
    }
  }

  //strong password validator  
  String? passwordValidator(String value) {
    if (value.isEmpty) {
      return "Password is required";
    } else if (!strongPassword.hasMatch(value)) {
      return "Password is not strong enough";
    } else {
      return null;
    }
  }

  //confirm password
  String? confirmPassword(String value1, String value2) {
    if (value1.isEmpty) {
      return "Re-enter your password";
    } else if (value1 != value2) {
      return "Password does not match";
    } else {
      return null;
    }
  }

  //password show & hide
  void showHidePassword() {
    _isVisible = !_isVisible;
    notifyListeners();
  }

  //snackbar message
  void showSnackBar(String message, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        content: Text(
          message,
          style: TextStyle(color: Colors.black87),
        ),
      ),
    );
  }
}
