import 'package:flutter/material.dart';
import 'package:flutter_application_1/view/Generate_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProcessDetailsScreen extends StatefulWidget {
  final int patientId;

  ProcessDetailsScreen({required this.patientId});

  @override
  _ProcessDetailsScreenState createState() => _ProcessDetailsScreenState();
}

class _ProcessDetailsScreenState extends State<ProcessDetailsScreen> {
  List<dynamic>? processDetails;
  List<dynamic>? diagnosisDetails;
  Map<String, dynamic>? patientDetails;
  bool isLoading = true;
  TextEditingController commentController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    fetchProcessDetails();
    fetchDiagnosisDetails();
  }

  fetchProcessDetails() async {
    var url = Uri.parse(
        'http://10.0.2.2/techero_app/get_process_details.php?patient_id=${widget.patientId}');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      setState(() {
        processDetails = data;
        if (data.isNotEmpty) {
          patientDetails = {
            'first_name': data[0]['first_name'],
            'middle_name': data[0]['middle_name'],
            'last_name': data[0]['last_name'],
            'patient_nic': data[0]['patient_nic'],
          };
        }
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  fetchDiagnosisDetails() async {
    var url = Uri.parse(
        'http://10.0.2.2/techero_app/get_diagnosis_details.php?patient_id=${widget.patientId}');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      setState(() {
        diagnosisDetails = data;
      });
    } else {

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: RichText(
            text: const TextSpan(
              text: "Processed Details",
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
        backgroundColor: const Color.fromARGB(255, 26, 35, 126),
        centerTitle: true,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : processDetails != null && processDetails!.isNotEmpty
              ? Form(
                  key: _formKey,
                  child: ListView.builder(
                    itemCount: processDetails!.length,
                    itemBuilder: (context, index) {
                      var process = processDetails![index];
                      return Card(
                        margin: EdgeInsets.all(10.0),
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Process ID: ${process['process_id']}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              SizedBox(height: 10),
                              RichText(
                                text: TextSpan(
                                  style: DefaultTextStyle.of(context).style,
                                  children: <TextSpan>[
                                    const TextSpan(
                                      text: 'Patient NIC    : ',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextSpan(
                                      text: '${process['patient_nic']}',
                                    ),
                                  ],
                                ),
                              ),
                              RichText(
                                text: TextSpan(
                                  style: DefaultTextStyle.of(context).style,
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: 'Patient Name: ',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextSpan(
                                      text:
                                          '${patientDetails!['first_name']} ${patientDetails!['middle_name'] ?? ''} ${patientDetails!['last_name']}',
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 20),
                              RichText(
                                text: TextSpan(
                                  style: DefaultTextStyle.of(context).style,
                                  children: const <TextSpan>[
                                    TextSpan(
                                      text: 'Original Image :',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Image.network(
                                'http://10.0.2.2/admin/${process['image_path']}',
                                height: 200,
                              ),
                              SizedBox(height: 10),
                              RichText(
                                text: TextSpan(
                                  style: DefaultTextStyle.of(context).style,
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: 'Enhanced Image :',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Image.network(
                                'http://10.0.2.2/admin/${process['enhanced_image_path']}',
                                height: 200,
                              ),
                              SizedBox(height: 10),
                              RichText(
                                text: TextSpan(
                                  style: DefaultTextStyle.of(context).style,
                                  children: const <TextSpan>[
                                    TextSpan(
                                      text: 'Segmented Image :',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Image.network(
                                'http://10.0.2.2/admin/${process['segmented_image_path']}',
                                height: 200,
                              ),
                              SizedBox(height: 20),
                              RichText(
                                text: TextSpan(
                                  style: DefaultTextStyle.of(context).style,
                                  children: <TextSpan>[
                                    const TextSpan(
                                      text: 'Asymmetry: ',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextSpan(
                                      text: '${process['asymmetry']}',
                                    ),
                                  ],
                                ),
                              ),
                              RichText(
                                text: TextSpan(
                                  style: DefaultTextStyle.of(context).style,
                                  children: <TextSpan>[
                                    const TextSpan(
                                      text: 'Border: ',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextSpan(
                                      text: '${process['border']}',
                                    ),
                                  ],
                                ),
                              ),
                              RichText(
                                text: TextSpan(
                                  style: DefaultTextStyle.of(context).style,
                                  children: <TextSpan>[
                                    const TextSpan(
                                      text: 'Colour: ',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextSpan(
                                      text: '${process['colour']}',
                                    ),
                                  ],
                                ),
                              ),
                              RichText(
                                text: TextSpan(
                                  style: DefaultTextStyle.of(context).style,
                                  children: <TextSpan>[
                                    const TextSpan(
                                      text: 'Diameter: ',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextSpan(
                                      text: '${process['diameter']}',
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 30),
                              SizedBox(height: 15),
                              if (diagnosisDetails != null &&
                                  diagnosisDetails!.isNotEmpty)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: diagnosisDetails!.map((diagnosis) {
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        RichText(
                                          text: TextSpan(
                                            style: DefaultTextStyle.of(context)
                                                .style,
                                            children: <TextSpan>[
                                              const TextSpan(
                                                text: 'Cancer Type  :  \n',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20,
                                                ),
                                              ),
                                              const TextSpan(
                                                text: '\n',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 10,
                                                ),
                                              ),
                                              const TextSpan(
                                                text: 'Cancer Type   : ',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              TextSpan(
                                                text:
                                                    '${diagnosis['cancer_type']}',
                                              ),
                                            ],
                                          ),
                                        ),
                                        RichText(
                                          text: TextSpan(
                                            style: DefaultTextStyle.of(context)
                                                .style,
                                            children: <TextSpan>[
                                              TextSpan(
                                                text: 'Risk factor    : ',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              TextSpan(
                                                text:
                                                    '${diagnosis['risk_text']}',
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    );
                                  }).toList(),
                                ),

                              SizedBox(height: 30),
                              RichText(
                                text: TextSpan(
                                  style: DefaultTextStyle.of(context).style,
                                  children: const <TextSpan>[
                                    TextSpan(
                                      text: ' Add Comment',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 20),
                              TextFormField(
                                controller: commentController,
                                decoration: InputDecoration(
                                  labelText: 'Add Comment',
                                  border: OutlineInputBorder(),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter a comment';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 20),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                )
              : Center(child: Text('No process details found')),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              saveComment(context);
            }
          },
          child: Text(
            'Save Comment & Generate PDF',
            style: TextStyle(
                color: Colors.indigo[900],
                fontSize: 15,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Future<void> saveComment(BuildContext context) async {
    final comment = commentController.text;
    final url = Uri.parse('http://10.0.2.2/techero_app/save_comment.php');
    final response = await http.post(
      url,
      body: {
        'patient_id': widget.patientId.toString(),
        'comment': comment,
      },
    );

    if (response.statusCode == 200) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GeneratePdfPage(patientId: widget.patientId),
        ),
      );
    } else {
      // Handle error
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to save comment'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }
}
