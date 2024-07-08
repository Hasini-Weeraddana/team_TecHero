import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/components/input_field.dart';
import 'package:flutter_application_1/provider/setting_provider.dart';
import 'package:flutter_application_1/view/login_screen.dart';
import 'package:flutter_application_1/view/success_validation_screen.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class FormValidation extends StatefulWidget {
  const FormValidation({super.key});

  @override
  State<FormValidation> createState() => _FormValidationState();
}

class _FormValidationState extends State<FormValidation> {
  final fullName = TextEditingController();
  final mediRegNum = TextEditingController();
  final birthOfDate = TextEditingController();
  final gender = TextEditingController();
  final workPlace = TextEditingController();
  final phone = TextEditingController();
  final userName = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();
  final email = TextEditingController();

  final provider = SettingsProvider();
  final formKey = GlobalKey<FormState>();

  Future<void> submitData() async {
    final url = Uri.parse(
        'http://10.0.2.2/techero_app/submit_form.php'); 
    final response = await http.post(
      url,
      body: {
        'fullName': fullName.text,
        'mediRegNum': mediRegNum.text,
        'birthOfDate': birthOfDate.text,
        'gender': gender.text,
        'workPlace': workPlace.text,
        'phone': phone.text,
        'userName': userName.text,
        'password': password.text,
        'email': email.text,
      },
    );

    if (response.statusCode == 200) {
      if (response.body.contains("Email already exists")) {
        provider.showSnackBar("Error: Email already exists", context);
      } else if (response.body.contains("New record created successfully")) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SuccessValidation()),
        );
      } else {
        provider.showSnackBar("Error: ${response.body}", context);
      }
    } else {
      provider.showSnackBar("Error: ${response.body}", context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo[900],
      appBar: AppBar(
        title: Text(
          "Doctor's Sign Up",
          style: TextStyle(
              fontSize: 25,
              color: Color.fromARGB(255, 172, 183, 244),
              fontWeight: FontWeight.w600),
        ),
        leading: IconButton(
          color: const Color.fromARGB(255, 159, 168, 218),
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 26, 35, 126),
      ),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 50),
              InputField(
                icon: Icons.account_circle_rounded,
                label: "Full Name",
                controller: fullName,
                validator: (value) =>
                    provider.validator(value, "Full Name Is Required"),
              ),

              InputField(
                icon: Icons.app_registration,
                label: "Medical Registration Number",
                controller: mediRegNum,
                validator: (value) => provider.validator(
                    value, "Medical Registration Number is Required"),
              ),

              InputField(
                icon: Icons.email,
                label: "E-mail",
                controller: email,
                inputType: TextInputType.emailAddress,
                validator: (value) => provider.emailValidator(value),
              ),

              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 10),
                      child: TextFormField(
                        controller: birthOfDate,
                        validator: (value) => provider.dateOfBirthvalidator(
                            value!, "Birth Of Date Is Required"),
                        readOnly: true,
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1900),
                            lastDate: DateTime(2101),
                          );

                          if (pickedDate != null) {
                            setState(() {
                              birthOfDate.text =
                                  "${pickedDate.year}-${pickedDate.month}-${pickedDate.day}";
                            });
                          }
                        },
                        decoration: InputDecoration(
                          labelText: "Date of Birth",
                          labelStyle: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          hintText: "YYYY-MM-DD",
                          filled: true,
                          fillColor: Colors.indigo[200],
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: const BorderSide(
                                color: Color.fromARGB(255, 159, 168, 218),
                                width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: const BorderSide(
                                color: Color.fromARGB(255, 159, 168, 218),
                                width: 2),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                                color: Colors.red.shade900, width: 1),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                                color: Colors.red.shade900, width: 2),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 10),
                      child: DropdownButtonFormField<String>(
                        value: gender.text.isEmpty ? null : gender.text,
                        onChanged: (newValue) {
                          setState(() {
                            gender.text = newValue!;
                          });
                        },
                        validator: (value) => provider.gendervalidator(
                            value ?? "", "Gender Is Required"),
                        decoration: InputDecoration(
                          labelText: "Gender",
                          labelStyle: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          filled: true,
                          fillColor: Colors.indigo[200],
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: const BorderSide(
                                color: Color.fromARGB(255, 159, 168, 218),
                                width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: const BorderSide(
                                color: Color.fromARGB(255, 159, 168, 218),
                                width: 2),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                                color: Colors.red.shade900, width: 1),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                                color: Colors.red.shade900, width: 2),
                          ),
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: "Male",
                            child: Text("Male"),
                          ),
                          DropdownMenuItem(
                            value: "Female",
                            child: Text("Female"),
                          ),
                          DropdownMenuItem(
                            value: "Other",
                            child: Text("Other"),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              InputField(
                icon: Icons.place_rounded,
                label: "Work Place",
                controller: workPlace,
                validator: (value) =>
                    provider.validator(value, "Work Place Is Required"),
              ),
              InputField(
                icon: Icons.phone,
                label: "WhatsApp Number",
                controller: phone,
                inputType: TextInputType.phone,
                inputFormat: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                ],
                validator: (value) => provider.phoneValidator(value),
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
              Consumer<SettingsProvider>(builder: (context, notifier, child) {
                return InputField(
                  icon: Icons.lock,
                  label: "Re-enter Password",
                  controller: confirmPassword,
                  isVisible: !notifier.isVisible,
                  trailing: IconButton(
                    onPressed: () => notifier.showHidePassword(),
                    icon: Icon(!notifier.isVisible
                        ? Icons.visibility_off
                        : Icons.visibility),
                  ),
                  validator: (value) =>
                      provider.confirmPassword(value, password.text),
                );
              }),
              SizedBox(
                height: 30,
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.05,
                width: MediaQuery.of(context).size.width * 0.9,
                child: ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      submitData();
                    } else {
                      provider.showSnackBar("Fix the error", context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo[800],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    "Create account",
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
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Already have an account? ",
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.black87,
                        fontWeight: FontWeight.w400),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => LoginPage()));
                    },
                    child: const Text(
                      "Sign In",
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
