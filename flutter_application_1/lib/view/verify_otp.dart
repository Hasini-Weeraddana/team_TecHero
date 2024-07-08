import 'package:flutter/material.dart';
import 'package:flutter_application_1/view/reset_password.dart';
import 'package:http/http.dart' as http;

class VerifyOtpScreen extends StatefulWidget {
  final String email;

  VerifyOtpScreen({required this.email});

  @override
  _VerifyOtpScreenState createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  final otpController = TextEditingController();

  Future<void> verifyOtp() async {
    if (otpController.text.isEmpty) {
      _showMessageDialog('Validation Error', 'OTP field cannot be empty.');
      return;
    }

    final response = await http.post(
      Uri.parse('http://10.0.2.2/techero_app/verify_otp.php'),
      body: {'email': widget.email, 'otp': otpController.text},
    );

    if (response.statusCode == 200) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResetPasswordScreen(email: widget.email),
        ),
      );
    } else {
      _showMessageDialog('Error', 'Invalid or expired OTP.');
    }
  }

  void _showMessageDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            const Color.fromARGB(255, 255, 255, 255), 
        title: Text(
          'Verify OTP',
          style: TextStyle(
            fontSize: 25,
            color: Color.fromARGB(255, 26, 35, 126),
            fontWeight: FontWeight.w600, 
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color:
                Color.fromARGB(255, 159, 168, 218), 
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        centerTitle: true,
      ),
      backgroundColor: const Color.fromARGB(
          255, 255, 255, 255), 
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors
                  .indigo[900], 
              borderRadius: BorderRadius.all(Radius.circular(30)),
            ),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: otpController,
                  decoration: InputDecoration(
                    labelText: 'OTP',
                    labelStyle: TextStyle(
                      color: Color.fromARGB(
                          255, 255, 255, 255), 
                    ),
                  ),
                  style: TextStyle(
                      color: Color.fromARGB(255, 166, 175, 231)), 
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: verifyOtp,
                  child: Text('Verify OTP'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
