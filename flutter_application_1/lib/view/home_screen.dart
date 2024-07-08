import 'package:flutter/material.dart';
import 'package:flutter_application_1/view/doctor_profile_screen.dart';
import 'package:flutter_application_1/view/login_screen.dart';
import 'package:flutter_application_1/view/patient_list_check.dart';
import 'package:flutter_application_1/view/patient_list_notcheck.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:carousel_slider/carousel_slider.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Map<String, dynamic>? doctorDetails;

  final List<String> imgList = [
    'assets/7.jpg',
    'assets/8.jpg',
    'assets/3.jpg',
    'assets/6.jpg',
    'assets/3.jpg'
  ];

  @override
  void initState() {
    super.initState();
    _loadDoctorDetails();
  }

  _loadDoctorDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? doctorId = prefs.getInt('doctor_id');
    print('Stored Doctor ID: $doctorId'); 
    if (doctorId != null) {
      final url = Uri.parse(
          'http://10.0.2.2/techero_app/get_doctor_details_home_screnn.php?doctor_id=$doctorId');
      final response = await http.get(url);
      print('Response status: ${response.statusCode}'); 
      print('Response body: ${response.body}'); 

      if (response.statusCode == 200) {
        setState(() {
          doctorDetails = json.decode(response.body);
        });
        print('Doctor Details: $doctorDetails'); 
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${response.body}")),
        );
      }
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      switch (index) {
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
        automaticallyImplyLeading: false,
        backgroundColor: Colors.indigo[900],
        actions: [
          IconButton(
            icon: Icon(Icons.menu, color: Color.fromARGB(255, 172, 183, 244)),
            onPressed: () {
              _scaffoldKey.currentState?.openEndDrawer();
            },
          ),
        ],
      ),
      body: Container(
        color: Color.fromARGB(255, 255, 255, 255),
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 5.8,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 5.8,
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
                    bottomLeft: Radius.circular(0),
                    bottomRight: Radius.circular(80),
                  ),
                ),
              ),
              doctorDetails != null
                  ? Padding(
                      padding: const EdgeInsets.only(top: 10, left: 16.0),
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Color.fromARGB(255, 172, 183, 244),
                                      width: 4.0,
                                    ),
                                  ),
                                  child: CircleAvatar(
                                    radius: 50,
                                    backgroundImage: doctorDetails![
                                                'profilePicture'] !=
                                            null
                                        ? NetworkImage(
                                            'http://10.0.2.2/techero_app/uploads/${doctorDetails!['profilePicture']}')
                                        : AssetImage(
                                                "assets/default_profile.png")
                                            as ImageProvider,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      doctorDetails!['fullName'] ??
                                          'Loading...',
                                      style: const TextStyle(
                                        color:
                                            Color.fromARGB(255, 172, 183, 244),
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      doctorDetails!['email'] ?? 'Loading...',
                                      style: const TextStyle(
                                        color:
                                            Color.fromARGB(255, 172, 183, 244),
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 16.0),
                            CarouselSlider(
                              options: CarouselOptions(
                                height: 270.0,
                                autoPlay: true,
                                enlargeCenterPage: true,
                                aspectRatio: 2.0,
                              ),
                              items: imgList
                                  .map((item) => Container(
                                        child: Center(
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            child: Image.asset(
                                              item,
                                              fit: BoxFit.cover,
                                              width: 1000,
                                            ),
                                          ),
                                        ),
                                      ))
                                  .toList(),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(right: 200.0, top: 0.0),
                              child: Text(
                                "Categories",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Center(child: CircularProgressIndicator()),
              Padding(
                padding: const EdgeInsets.only(top: 440.0),
                child: Column(
                  children: [
                    FeatureCard(
                      backgroundColor: Colors.indigo,
                      title: "New Patient Cases",
                      icon: Icons.featured_play_list,
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    PatientListScreennotCheck()));
                      },
                    ),
                    FeatureCard(
                      backgroundColor: Colors.indigo,
                      title: "Checked Patient Cases",
                      icon: Icons.checklist,
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    PatientListScreenCheck()));
                      },
                    ),
                    SizedBox(height: 250),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.indigo[900],
              ),
              child: const Text(
                'Menu',
                style: TextStyle(
                  color: Color.fromARGB(255, 172, 183, 244),
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () async {
                bool confirmLogout = await showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Confirm Logout'),
                      content: Text('Are you sure you want to log out?'),
                      actions: <Widget>[
                        TextButton(
                          child: Text('No'),
                          onPressed: () {
                            Navigator.of(context).pop(false);
                          },
                        ),
                        TextButton(
                          child: Text('Yes'),
                          onPressed: () async {
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            prefs.remove('isLoggedIn');
                            Navigator.of(context).pop(true);
                          },
                        ),
                      ],
                    );
                  },
                );

                if (confirmLogout == true) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                    (Route<dynamic> route) => false,
                  );
                }
              },
            ),
          ],
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

class FeatureCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final Color backgroundColor;

  FeatureCard({
    required this.title,
    required this.icon,
    required this.onTap,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: backgroundColor,
        margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Container(
          height: 90, 
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, size: 50, color: Color.fromARGB(255, 172, 183, 244)),
              SizedBox(width: 20), 
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                ),
              ),
              Icon(Icons.arrow_forward_ios,
                  color: Color.fromARGB(255, 172, 183, 244)),
            ],
          ),
        ),
      ),
    );
  }
}
