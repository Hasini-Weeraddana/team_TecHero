import 'package:flutter/material.dart';
import 'package:flutter_application_1/view/Last_Uploaded_Images_Screen.dart';
import 'package:flutter_application_1/view/doctor_profile_screen.dart';
import 'package:flutter_application_1/view/home_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:open_file/open_file.dart';

class CkekedPatientDetailsScreen extends StatefulWidget {
  final int patientId;

  CkekedPatientDetailsScreen({required this.patientId});

  @override
  _PatientDetailsScreenState createState() => _PatientDetailsScreenState();
}

class _PatientDetailsScreenState extends State<CkekedPatientDetailsScreen> {
  Map<String, dynamic>? patientData;
  List<dynamic>? images;
  bool isLoading = true;
  String? reportPath; 

  @override
  void initState() {
    super.initState();
    fetchPatientDetails();
    fetchReportPath(); 
  }

  fetchPatientDetails() async {
    var urlPatient = Uri.parse(
        'http://10.0.2.2/techero_app/get_patient_details.php?patient_id=${widget.patientId}');
    var responsePatient = await http.get(urlPatient);

    if (responsePatient.statusCode == 200) {
      var patient = json.decode(responsePatient.body);
      setState(() {
        patientData = patient;
      });

      var urlImages = Uri.parse(
          'http://10.0.2.2/techero_app/get_patient_images.php?patient_id=${widget.patientId}');
      var responseImages = await http.get(urlImages);

      if (responseImages.statusCode == 200) {
        var imagesList = json.decode(responseImages.body);
        setState(() {
          images = imagesList;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  fetchReportPath() async {
    var url = Uri.parse(
        'http://10.0.2.2/techero_app/get_report_path.php?patient_id=${widget.patientId}');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      setState(() {
        reportPath = data['report_path'];
      });
    } else {
      // Handle error fetching report path
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Center(
          child: RichText(
            text: const TextSpan(
              text: "Patient Details ",
              style: TextStyle(
                  color: Color.fromARGB(255, 172, 183, 244),
                  fontSize: 25,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ),
        leading: IconButton(
          color: const Color.fromARGB(255, 159, 168, 218),
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ],
        backgroundColor: const Color.fromARGB(255, 26, 35, 126),
        centerTitle: true,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : patientData != null
              ? ListView(
                  padding: EdgeInsets.all(8.0),
                  children: [
                    Card(
                      margin: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 15.0),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${patientData!['first_name']} ${patientData!['last_name']}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Patient NIC: ${patientData!['patient_nic']}',
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              'Gender: ${patientData!['gender']}',
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              'Address: ${patientData!['address']}',
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Card(
                      margin: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 15.0),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(
                          'Past Medical Information: ${patientData!['past_medical_information'] ?? 'None'}',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                    if (images != null && images!.isNotEmpty) ...[
                      Divider(),
                      const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          'Recently Uploaded Image',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Card(
                        margin: EdgeInsets.symmetric(vertical: 10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 300,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(
                                      'http://10.0.2.2/admin/${images![0]['image_path']}'),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                  'Uploaded At: ${images![0]['uploaded_at']}'),
                            ),
                          ],
                        ),
                      ),
                      if (reportPath != null) ...[
                        Divider(),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                            onPressed: () {
                              OpenFile.open(reportPath!);
                            },
                            child: Text('Open Report'),
                          ),
                        ),
                      ],

                      if (images!.length > 1) ...[
                        Divider(),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      LastUploadedImagesScreen(
                                          images: images!.sublist(1)),
                                ),
                              );
                            },
                            child: const Text(
                              'Previously Upload Images >>',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ],
                )
              : Center(child: Text('Patient not found or error fetching data')),
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
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
