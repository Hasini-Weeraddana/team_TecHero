import 'package:flutter/material.dart';
import 'package:flutter_application_1/view/doctor_registration_screen.dart';
import 'package:flutter_application_1/view/login_screen.dart';
import 'package:flutter_application_1/widgets/on_board_button.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Flexible(
              flex: 1,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 0,
                  horizontal: 40.0,
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                          height: 50), 
                      Image.asset('assets/logo2.png'), 
                    ],
                  ),
                ),
              ),
            ),
            Flexible(
              flex: 1,
              child: Align(
                alignment: Alignment.bottomRight,
                child: Row(
                  children: [
                    Expanded(
                      child: OnboardButton(
                        buttonText: 'Sign In',
                        onTap: LoginPage(),
                        color: Colors.transparent,
                        textColor: Colors.indigo[900],
                      ),
                    ),
                    Expanded(
                      child: OnboardButton(
                        buttonText: 'Sign Up',
                        onTap: FormValidation(),
                        color: Colors.indigo[900],
                        textColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
