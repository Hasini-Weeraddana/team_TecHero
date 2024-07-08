import 'package:flutter/material.dart';
import 'package:flutter_application_1/view/home_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class DashboardScreenqq extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreenqq> {
  int? doctorId;
  Map<String, dynamic>? doctorDetails;
  bool isEditing = false;
  TextEditingController workPlaceController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  File? _profileImage;

  @override
  void initState() {
    super.initState();
    _loadDoctorId();
  }

  _loadDoctorId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      doctorId = prefs.getInt('doctor_id');
      if (doctorId != null) {
        _fetchDoctorDetails(doctorId!);
      }
    });
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      switch (index) {
        case 0:
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => DashboardScreen()));
          break;
        case 1:
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => DashboardScreenqq()));
          break;
      }
    });
  }

  _fetchDoctorDetails(int id) async {
    final url = Uri.parse(
        'http://10.0.2.2/techero_app/get_doctor_details.php?doctor_id=$id');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      setState(() {
        doctorDetails = json.decode(response.body);
        workPlaceController.text = doctorDetails!['workPlace'];
        phoneController.text = doctorDetails!['phone'];
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.indigo,
          content: Text(
            "Error: ${response.body}",
            style: TextStyle(color: Colors.black),
          ),
        ),
      );
    }
  }

  Future<void> _saveChanges() async {
    final url = Uri.parse(
        'http://10.0.2.2/techero_app/update_doctor_details.php');
    var request = http.MultipartRequest('POST', url);
    request.fields['doctor_id'] = doctorId.toString();
    request.fields['workPlace'] = workPlaceController.text;
    request.fields['phone'] = phoneController.text;

    if (_profileImage != null) {
      request.files.add(await http.MultipartFile.fromPath(
          'profilePicture', _profileImage!.path));
    }

    final response = await request.send();

    if (response.statusCode == 200) {
      setState(() {
        isEditing = false;
      });
      _fetchDoctorDetails(doctorId!);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.white,
          content: Text(
            "Changes saved successfully",
            style: TextStyle(color: Colors.black),
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.white,
          content: Text(
            "Error: ${response.reasonPhrase}",
            style: TextStyle(color: Colors.black),
          ),
        ),
      );
    }
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _profileImage = File(pickedFile.path);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.indigo[900],
        title: Text('Profile',
            style: TextStyle(
              fontSize: 25,
              color: Color.fromARGB(255, 172, 183, 244),
              fontWeight: FontWeight.w600,
            )),
        actions: [
          IconButton(
            icon: Icon(
              isEditing ? Icons.save : Icons.edit,
              color: Color.fromARGB(255, 159, 168, 218),
            ),
            onPressed: () {
              if (isEditing) {
                _saveChanges();
              } else {
                setState(() {
                  isEditing = true;
                });
              }
            },
          ),
        ],
        centerTitle: true,
        automaticallyImplyLeading: false, 
      ),
      body: doctorDetails != null
          ? Container(
              margin: EdgeInsets.only(
                  top: 20.0, left: 20.0, right: 20.0, bottom: 20.0),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                  color: Colors.indigo[900],
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  )),
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Stack(
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 15.0),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Color.fromARGB(255, 172, 183, 244),
                                width: 4.0,
                              ),
                            ),
                            child: CircleAvatar(
                              radius: 50,
                              backgroundImage: _profileImage != null
                                  ? FileImage(_profileImage!)
                                  : doctorDetails!['profilePicture'] != null
                                      ? NetworkImage(
                                          'http://10.0.2.2/techero_app/uploads/${doctorDetails!['profilePicture']}')
                                      : AssetImage("assets/default_profile.png")
                                          as ImageProvider,
                            ),
                          ),
                          if (isEditing)
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: _pickImage,
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(
                                      Icons.camera_alt,
                                      color: Color.fromARGB(255, 0, 0, 0),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    SizedBox(height: 30),
                    Text('Doctor ID: ${doctorDetails!['id']}',
                        style: TextStyle(
                            fontSize: 18,
                            color: Color.fromARGB(255, 172, 183, 244))),
                    SizedBox(height: 20),
                    Text('Full Name: ${doctorDetails!['fullName']}',
                        style: TextStyle(
                            fontSize: 18,
                            color: Color.fromARGB(255, 172, 183, 244))),
                    SizedBox(height: 20),
                    Text(
                        'Medical Registration Number: ${doctorDetails!['mediRegNum']}',
                        style: TextStyle(
                            fontSize: 18,
                            color: Color.fromARGB(255, 172, 183, 244))),
                    SizedBox(height: 20),
                    Text('Email: ${doctorDetails!['email']}',
                        style: TextStyle(
                            fontSize: 18,
                            color: Color.fromARGB(255, 172, 183, 244))),
                    SizedBox(height: 20),
                    Text('Birth Date: ${doctorDetails!['birthOfDate']}',
                        style: TextStyle(
                            fontSize: 18,
                            color: Color.fromARGB(255, 172, 183, 244))),
                    SizedBox(height: 20),
                    Text('Gender: ${doctorDetails!['gender']}',
                        style: TextStyle(
                            fontSize: 18,
                            color: Color.fromARGB(255, 172, 183, 244))),
                    SizedBox(height: 20),
                    if (isEditing)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            controller: workPlaceController,
                            decoration: InputDecoration(
                              labelText: 'Work Place',
                              labelStyle: TextStyle(color: Colors.indigo[300]),
                              border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.indigo[300]!),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.indigo[300]!),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 12.0, horizontal: 16.0),
                            ),
                            style: TextStyle(
                                fontSize: 18,
                                color: Color.fromARGB(255, 172, 183, 244)),
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            controller: phoneController,
                            decoration: InputDecoration(
                              labelText: 'Phone',
                              labelStyle: TextStyle(color: Colors.indigo[300]),
                              border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.indigo[300]!),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.indigo[300]!),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 12.0, horizontal: 16.0),
                            ),
                            style: TextStyle(
                                fontSize: 18,
                                color: Color.fromARGB(255, 172, 183, 244)),
                          ),
                          SizedBox(height: 20),
                        ],
                      )
                    else
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Work Place: ${doctorDetails!['workPlace']}',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Color.fromARGB(255, 172, 183, 244))),
                          SizedBox(height: 20),
                          Text('Phone: ${doctorDetails!['phone']}',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Color.fromARGB(255, 172, 183, 244))),
                          SizedBox(height: 20),
                        ],
                      ),
                    SizedBox(height: 220),
                  ],
                ),
              ),
            )
          : Center(child: CircularProgressIndicator()),
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
        child: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: const Color.fromARGB(255, 172, 183, 244),
          backgroundColor: Colors.indigo[900],
          onTap: _onItemTapped,
          unselectedItemColor: const Color.fromARGB(255, 172, 183, 244),
        ),
      ),
    );
  }
}
