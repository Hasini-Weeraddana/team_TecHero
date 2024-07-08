import 'package:flutter/material.dart';
import 'package:flutter_application_1/view/checked_patient_details.dart';
import 'package:flutter_application_1/view/doctor_profile_screen.dart';
import 'package:flutter_application_1/view/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PatientListScreenCheck extends StatefulWidget {
  @override
  _PatientListScreenCheckState createState() => _PatientListScreenCheckState();
}

class _PatientListScreenCheckState extends State<PatientListScreenCheck> {
  int? doctorId;
  String? mediRegNum;
  List<dynamic> patients = [];
  List<dynamic> filteredPatients = [];
  bool isLoading = true;
  TextEditingController searchController = TextEditingController();

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
        _fetchMediRegNum(doctorId!);
      }
    });
  }

  _fetchMediRegNum(int id) async {
    final url = Uri.parse(
        'http://10.0.2.2/techero_app/get_doctor_details.php?doctor_id=$id');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        mediRegNum = data['mediRegNum'];
        _fetchPatientsCheck(mediRegNum!);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${response.body}")),
      );
    }
  }

  Future<List<dynamic>> _fetchPatients(String mediRegNum) async {
    final url = Uri.parse(
        'http://10.0.2.2/techero_app/get_patients.php?mediRegNum=$mediRegNum');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${response.body}")),
      );
      return [];
    }
  }

  _fetchPatientsCheck(String mediRegNum) async {
    final patientsData = await _fetchPatients(mediRegNum);

    setState(() {
      patients =
          patientsData.where((patient) => patient['is_check'] == 1).toList();
      filteredPatients = patients;
      isLoading = false;
    });
  }

  void _filterPatients(String query) {
    List<dynamic> tempList = [];
    if (query.isNotEmpty) {
      tempList = patients.where((patient) {
        return patient['patient_nic']
            .toLowerCase()
            .contains(query.toLowerCase());
      }).toList();
    } else {
      tempList = patients;
    }

    setState(() {
      filteredPatients = tempList;
    });
  }

  String getInitials(String firstName) {
    return firstName.isNotEmpty ? firstName[0].toUpperCase() : '';
  }

  int _selectedIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Container(
              color: Colors.white,
              child: SingleChildScrollView(
                child: Stack(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height / 4.5,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color.fromARGB(255, 26, 35, 126),
                            Color.fromARGB(255, 26, 35, 126),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 40),
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(height: 10),
                            const Text(
                              'Checked Cases',
                              style: TextStyle(
                                color: Color.fromARGB(255, 172, 183, 244),
                                fontSize: 30,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 5),
                            const Text(
                              'Patient List',
                              style: TextStyle(
                                color: Color.fromARGB(255, 172, 183, 244),
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 20, bottom: 20),
                              width: MediaQuery.of(context).size.width * 0.9,
                              height: 50,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 214, 220, 252),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color.fromARGB(255, 214, 220, 252),
                                    spreadRadius: 3,
                                  ),
                                ],
                              ),
                              child: TextFormField(
                                controller: searchController,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Search by patient NIC....",
                                  hintStyle: TextStyle(
                                    color: Colors.black.withOpacity(0.5),
                                  ),
                                  prefixIcon: const Icon(
                                    Icons.search,
                                    size: 25,
                                  ),
                                ),
                                onChanged: _filterPatients,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 250.0),
                      child: filteredPatients.isEmpty
                          ? const Center(child: Text('No patients found'))
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: filteredPatients.length,
                              itemBuilder: (context, index) {
                                final patient = filteredPatients[index];
                                return Card(
                                  elevation: 3,
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      backgroundColor:
                                          Theme.of(context).primaryColor,
                                      child: Text(
                                        getInitials(patient['first_name']),
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    title: Text(
                                      patient['first_name'],
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                    subtitle: Text(
                                      'NIC: ${patient['patient_nic']}',
                                      style: TextStyle(fontSize: 15),
                                    ),
                                    trailing: Icon(Icons.arrow_forward_ios),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              CkekedPatientDetailsScreen(
                                            patientId: patient['patient_id'],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ),
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
