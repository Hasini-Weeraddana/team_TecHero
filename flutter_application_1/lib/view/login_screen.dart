import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/input_field.dart';
import 'package:flutter_application_1/provider/setting_provider.dart';
import 'package:flutter_application_1/view/doctor_registration_screen.dart';
import 'package:flutter_application_1/view/forgot_password_screen.dart';
import 'package:flutter_application_1/view/home_screen.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final email = TextEditingController();
  final password = TextEditingController();

  final provider = SettingsProvider();

  final formKey = GlobalKey<FormState>();

  Future<void> login() async {
    final url = Uri.parse('http://10.0.2.2/techero_app/login.php');
    final response = await http.post(
      url,
      body: {
        'email': email.text,
        'password': password.text,
      },
    );

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      if (responseBody["message"] == "Login successful") {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setBool('isLoggedIn', true);
        prefs.setInt('doctor_id', responseBody["doctor_id"]);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => DashboardScreen()),
        );
      } else {
        provider.showSnackBar(responseBody["message"], context);
      }
    } else {
      provider.showSnackBar("Error: ${response.body}", context);
    }
  }

  Future<void> logout() async {
    final url = Uri.parse('http://10.0.2.2/techero_app/logout.php');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.remove('isLoggedIn');
      prefs.remove('doctor_id');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } else {
      provider.showSnackBar("Error: ${response.body}", context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo[900], 
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 100),
              const Text(
                'Welcome to MelanoCare',
                style: TextStyle(
                    fontSize: 35, color: Color.fromARGB(255, 172, 183, 244)),
              ),
              const Text(
                'Early Detection Saves Lives',
                style: TextStyle(
                    fontSize: 18,
                    fontStyle: FontStyle.italic,
                    color: Colors.blue),
              ),

              const SizedBox(height: 100),

              InputField(
                icon: Icons.email,
                label: "E-mail",
                controller: email,
                inputType: TextInputType.emailAddress,
                validator: (value) => provider.emailValidator(value),
              ),

              Consumer<SettingsProvider>(builder: (context, notifier, child) {
                return InputField(
                  icon: Icons.lock,
                  label: "Password",
                  controller: password,
                  isVisible: !notifier.isVisible,
                  trailing: IconButton(
                    onPressed: () => notifier.showHidePassword(),
                    icon: Icon(!notifier.isVisible
                        ? Icons.visibility_off
                        : Icons.visibility),
                  ),
                  validator: (value) => provider.passwordValidator(value),
                );
              }),

              const SizedBox(height: 10),
              Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ForgotPasswordScreen()));
                  },
                  child: const Text(
                    "Forgot your password? ",
                    style: TextStyle(
                        fontSize: 15,
                        color: Color.fromARGB(255, 172, 183, 244),
                        fontWeight: FontWeight.w500),
                  ),
                )
              ]),
              const SizedBox(height: 30),

              Container(
                height: MediaQuery.of(context).size.height * 0.05,
                width: MediaQuery.of(context).size.width * 0.9,
                child: ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      login();
                    } else {
                      provider.showSnackBar("Fix the error", context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo[800],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    "Login",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don't have an account? ",
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: 17,
                        color: Colors.black87,
                        fontWeight: FontWeight.w400),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FormValidation()));
                    },
                    child: const Text(
                      "Sign Up",
                      style: TextStyle(
                        fontSize: 15,
                        color: Color.fromARGB(255, 172, 183, 244),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
