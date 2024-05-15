import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hospital/lab/retrive_labtests.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:open_file/open_file.dart';
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class AppointmentIdCard extends StatefulWidget {
  final String logoPath;
  final String room;
  final String patient_id;

  AppointmentIdCard({
    required this.logoPath,
    required this.room,
    required this.patient_id,
  });

  @override
  State<AppointmentIdCard> createState() => _AppointmentIdCardState();
}

class _AppointmentIdCardState extends State<AppointmentIdCard> {
  String paitent_name = '';
  String doctor_name = '';
  String app_date = '';
  String duration = '';
  String appotnment_id = '';
  String gmail = '';
  String Staff_tel = '';
  late Future<List> adData;

  Future<void> _saveCardAsPDF(BuildContext context) async {
    // Check if the permission to write to external storage is granted
    if (!(await Permission.storage.isGranted)) {
      // If the permission is not granted, request it
      await Permission.storage.request();
    }

    // Check again if the permission is granted
    if (await Permission.storage.isGranted) {
      // Generate a PDF with the actual card content
      final pdfContent = '''
        Appointment ID Card
        Date: $app_date
        Appointment ID: $appotnment_id
        Doctor Name: $doctor_name
        Doctor Room: ${widget.room}
        Patient name: $paitent_name
        Time Duration: $duration
        Gmail: $gmail
        Staff Tel: $Staff_tel
      ''';

      // Generate a file name for the PDF
      final fileName = 'appointment_id_card.pdf';

      // Save the PDF to the device's documents directory
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/$fileName';
      final file = File(filePath);
      await file.writeAsString(pdfContent);

      // Open the PDF file with a specific application
      await OpenFile.open(filePath);
    } else {
      // Permission not granted, show a message or handle accordingly
      print('Permission not granted to save or open the PDF file');
    }
  }

  @override
  void initState() {
    adData = operationsLab.instance.fetch_Data(
        'SELECT app_no, p_no,name,staff_name,gmail,staff_tell,app_date,app_time_with_duration from staff, doctor,appointment,patient_table where staff.staff_no=doctor.staff_no and doctor.doctor_no=appointment.doctor_no and patient_table.p_no=appointment.patient_no and p_no=${widget.patient_id}');
    setState(() {
      adData.then((value) {
        paitent_name = value.isNotEmpty ? value[0]['name'] : '';
        doctor_name = value.isNotEmpty ? value[0]['staff_name'] : '';
        app_date = value.isNotEmpty ? value[0]['app_date'] : '';
        duration = value.isNotEmpty ? value[0]['app_time_with_duration'] : '';
        appotnment_id = value.isNotEmpty ? value[0]['app_no'] : '';
        gmail = value.isNotEmpty ? value[0]['gmail'] : '';
        Staff_tel = value.isNotEmpty ? value[0]['staff_tell'] : '';
        print(adData);
        print(paitent_name);
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: adData,
      builder: (context, snapshot) {
        return Card(
          elevation: 4.0,
          margin: EdgeInsets.all(16.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Column(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15.0),
                    topRight: Radius.circular(15.0),
                  ),
                ),
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  children: <Widget>[
                    SizedBox(width: 8.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Appointment ID Card',
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30.0),
              Row(
                children: <Widget>[
                  Image.asset(
                    widget.logoPath,
                    height: 60.0,
                    width: 150,
                  ),
                  SizedBox(width: 40.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Date: $app_date',
                              style: TextStyle(color: Colors.green, fontSize: 18),
                            ),
                            SizedBox(height: 10,),
                            Text(
                              'Appointment ID: $appotnment_id',
                              style: TextStyle(color: Colors.green),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20,),
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Divider(color: Colors.green),
                    Row(
                      children: [
                        Text(
                          'Doctor Name:    $doctor_name',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Divider(color: Colors.green),
                    SizedBox(height: 10.0),
                    Text(
                      'Doctor Room:   ${widget.room}',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Divider(color: Colors.green),
                    SizedBox(height: 10.0),
                    Text(
                      'Patient name:   $paitent_name',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Divider(color: Colors.green,),
                    SizedBox(height: 10.0),
                    Text(
                      'Time Duration:   $duration',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Divider(color: Colors.green),
              SizedBox(height: 20,),
              Container(
                color: Colors.grey[200],
                padding: EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Icon(Icons.email),
                        SizedBox(height: 4.0),
                        Text(gmail),
                      ],
                    ),
                    Column(
                      children: <Widget>[
                        Icon(Icons.phone),
                        SizedBox(height: 4.0),
                        Text(Staff_tel as String),
                      ],
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () => _saveCardAsPDF(context),
                child: Text('Save ID Card as PDF'),
              ),
            ],
          ),
        );
      },
    );
  }
}
