import 'package:flutter/material.dart';
import 'package:flutter_application_1/view/verify_otp.dart';
import 'package:http/http.dart' as http;

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final emailController = TextEditingController();
  String? message;
  Color messageColor = Colors.black;

  Future<void> sendOtp() async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2/techero_app/forgot_password.php'),
      body: {'email': emailController.text},
    );

    if (response.statusCode == 200) {
      setState(() {
        message = 'OTP sent successfully';
        messageColor = Colors.green;
      });
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VerifyOtpScreen(email: emailController.text),
        ),
      );
    } else {
      setState(() {
        message = 'Error sending OTP';
        messageColor = Colors.red;
      });
    }
  }

  Widget buildMessageBox(String message, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        message,
        style: TextStyle(color: color),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            const Color.fromARGB(255, 255, 255, 255), 
        title: Text(
          'Forgot Password',
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.indigo[900],
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: TextStyle(
                          color: Color.fromARGB(255, 255, 255, 255),
                        ),
                      ),
                      style: TextStyle(
                          color:
                              Color.fromARGB(255, 166, 175, 231)), 
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: sendOtp,
                      child: Text('Send OTP'),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              if (message != null) buildMessageBox(message!, messageColor),
            ],
          ),
        ),
      ),
    );
  }
}
