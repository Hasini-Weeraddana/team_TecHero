import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:open_file/open_file.dart';

class GeneratePdfPage extends StatefulWidget {
  final int patientId;

  GeneratePdfPage({required this.patientId});

  @override
  _GeneratePdfPageState createState() => _GeneratePdfPageState();
}

class _GeneratePdfPageState extends State<GeneratePdfPage> {
  Map<String, dynamic>? patientDetails;
  List<dynamic>? processDetails;
  List<dynamic>? diagnosisDetails;

  @override
  void initState() {
    super.initState();
    fetchPatientDetails();
    fetchProcessDetails();
    fetchDiagnosisDetails();
  }

  fetchPatientDetails() async {
    var url = Uri.parse(
        'http://10.0.2.2/techero_app/get_patient_details.php?patient_id=${widget.patientId}');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      setState(() {
        patientDetails = {
          'first_name': data['first_name'],
          'middle_name': data['middle_name'],
          'last_name': data['last_name'],
          'address': data['address'],
          'gender': data['gender'],
        };
      });
    } else {

    }
  }

  fetchProcessDetails() async {
    var url = Uri.parse(
        'http://10.0.2.2/techero_app/get_process_details.php?patient_id=${widget.patientId}');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      setState(() {
        processDetails = data;
      });
    } else {

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

  Future<void> generateAndSavePdf() async {
    final pdf = pw.Document();

    for (var process in processDetails!) {
      final image = pw.MemoryImage(
        (await http.get(Uri.parse(
                'http://10.0.2.2/admin/${process['image_path']}')))
            .bodyBytes,
      );
      final enhancedImage = pw.MemoryImage(
        (await http.get(Uri.parse(
                'http://10.0.2.2/admin/${process['enhanced_image_path']}')))
            .bodyBytes,
      );
      final segmentedImage = pw.MemoryImage(
        (await http.get(Uri.parse(
                'http://10.0.2.2/admin/${process['segmented_image_path']}')))
            .bodyBytes,
      );
      pdf.addPage(
        pw.Page(
          build: (context) => pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Header(
                  level: 0, text: '          MelanoCare - Medical Report'),
              pw.Header(level: 1, text: '1.Patient Details'),
              pw.Text(
                  'First Name:${patientDetails!['first_name']} ${patientDetails!['middle_name'] ?? ''} ${patientDetails!['last_name']}'),
              pw.Text('Address: ${patientDetails!['address']}'),
              pw.Text('Gender: ${patientDetails!['gender']}'),
              pw.SizedBox(height: 20),
              pw.Header(level: 1, text: '2.Process Details'),
              pw.SizedBox(height: 10),
              pw.Header(level: 3, text: 'ABCD Features'),
              pw.Text('Asymmetry: ${process['asymmetry'] ?? 'N/A'}'),
              pw.Text('Border: ${process['border'] ?? 'N/A'}'),
              pw.Text('Colour: ${process['colour'] ?? 'N/A'}'),
              pw.Text('Diameter: ${process['diameter'] ?? 'N/A'}'),
              pw.SizedBox(height: 20),
              pw.Header(level: 1, text: 'Diagnostic Imaging'),
              pw.SizedBox(height: 15),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Expanded(
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text('Image:'),
                        pw.Image(image, width: 150, height: 150),
                        pw.SizedBox(height: 15),
                        pw.Text('Enhanced Image:'),
                        pw.Image(enhancedImage, width: 150, height: 150),
                      ],
                    ),
                  ),
                  pw.SizedBox(width: 15),
                  pw.Expanded(
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text('Segmented Image:'),
                        pw.Image(segmentedImage, width: 150, height: 150),
                      ],
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 20),
              pw.Header(level: 1, text: 'Diagnosis Details'),
            ],
          ),
        ),
      );
    }

    pdf.addPage(
      pw.Page(
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Header(level: 1, text: 'Diagnosis Details'),
            if (diagnosisDetails != null)
              for (var diagnosis in diagnosisDetails!)
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text('Cancer Type: ${diagnosis['cancer_type']}'),
                    pw.Text('Risk Factor: ${diagnosis['risk_text']}'),
                  ],
                ),
          ],
        ),
      ),
    );

    // Save the PDF 
    final pdfFile =
        File('C:/xampp/htdocs/techero_app/pdf/report_${widget.patientId}.pdf');
    await pdfFile.writeAsBytes(await pdf.save());

    final filePath = pdfFile.path;
    OpenFile.open(filePath);

    // Store PDF path in the db
    final url =
        Uri.parse('http://10.0.2.2/techero_app/save_report_path.php');
    final response = await http.post(
      url,
      body: {
        'patient_id': widget.patientId.toString(),
        'report_path':
            'C:/xampp/htdocs/techero_app/pdf/report_${widget.patientId}.pdf',
      },
    );

    if (response.statusCode == 200) {
      print('PDF path saved to database.');
    } else {
      print('Failed to save PDF path to database.');
    }
  }

  void verifyPatient() async {
    var urlVerify =
        Uri.parse('http://192.168.43.104/techero_app/verify_patient.php');
    var responseVerify = await http.post(urlVerify, body: {
      'patient_id': widget.patientId.toString(),
    });

    if (responseVerify.statusCode == 200) {
      var result = json.decode(responseVerify.body);
      if (result['success']) {
        setState(() {
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.white,
            content: Text(
              'Patient checked successfully',
              style: TextStyle(color: Colors.black),
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.white,
            content: Text(
              'Failed to check patient',
              style: TextStyle(color: Colors.black),
            ),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.white,
          content: Text(
            'Error checking patient',
            style: TextStyle(color: Colors.black),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: RichText(
            text: const TextSpan(
              text: "Generate Report",
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
            child: TextButton(
              onPressed: verifyPatient,
              child: const Text(
                'Check',
                style: TextStyle(
                  color: Color.fromARGB(255, 26, 35, 126),
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: generateAndSavePdf,
          child: const Text('Generate PDF'),
        ),
      ),
    );
  }
}
