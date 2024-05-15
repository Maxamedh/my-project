import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hospital/lab/retrive_labtests.dart';
import 'package:hospital/screens/patients/widgets/Idcard.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';


import 'Appointment_make.dart';

class DoctorScheduleView extends StatefulWidget {
  const DoctorScheduleView({super.key,
    required this.doctor_id,
    required this.patient_id
  });

  final doctor_id;
  final patient_id;
  @override
  _DoctorScheduleViewState createState() => _DoctorScheduleViewState();
}

class _DoctorScheduleViewState extends State<DoctorScheduleView> {

  DateTime now = DateTime.now();


  late List<dynamic> doctorList;
  List<dynamic>? selectedDoctorSchedule;
  String? selectedDoctorId;
  final _form = GlobalKey<FormState>();
  var dropDownTimeValue;
  String startTime='';
  String endTime='';
  String room_name='';


  String day_name='';
  String formattedDate='';
  @override
  void initState() {
    super.initState();
    doctorList = [];
    selectedDoctorId = null;
    fetchDoctorSchedule();
    formattedDate = DateFormat('yyyy-MM-dd').format(now);
  }

  Future<void> insertData() async {
    final isValid =_form.currentState!.validate();
    if(isValid){
      final data={
        'table': 'appointment',
        'data': {
          'patient_no': widget.patient_id,
          'doctor_no': widget.doctor_id,
          'app_date': formattedDate,
          'app_time_with_duration': dropDownTimeValue,
        }
      };
      try {
        var response = await http.post(Uri.parse('http://192.168.43.239/hospital_api/All/insertion.php'),
            body: json.encode(data));
        print(response.body);
        setState(() {
          operationsLab.instance.fetch_Data('select * from appointment');
        });
        if (response.statusCode == 200) {
          operationsLab.instance.fetch_Data("UPDATE doctor_availability set status='Inactive' WHERE start_time='${startTime}'  and end_time='${endTime}'");
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Data inserted successfully')));

          print("Data inserted successfully");

        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Data failed response body  ${response.body}')));
          print("Failed to insert data");
          print("Status code: ${response.statusCode}");
          print("Response body: ${response.body}");
        }
      } catch (e) {
        print("There was an error: $e");
      }
    }else{
      print('not valid');
    }
  }

  showMyDialog(String Days) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: AlertDialog(
            title: Text('Appointment Form'),
            content:  Form(
              key: _form,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    FutureBuilder(
                        future: operationsLab.instance.fetch_Data('SELECT* from doctor_availability where doctor_id=${widget.doctor_id} and day_of_week=${Days}'),
                        builder: (context, snapshot){
                          if(snapshot.hasData){
                            List<dynamic> Time =snapshot.data!;

                            return SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: DropdownButtonFormField(
                                value: null,
                                icon: const Icon(Icons.keyboard_arrow_down),
                                items: Time.map((aptime) {
                                  return DropdownMenuItem(
                                    value: '${aptime['start_time'].toString()} -${aptime['end_time'].toString()}',
                                    child: Row(
                                      children: [
                                        Icon(Icons.people),
                                        SizedBox(width: 10,),
                                        Text('${aptime['start_time'].toString()} - ${aptime['end_time'].toString()}')
                                      ],
                                    ),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    dropDownTimeValue=value;
                                    print(dropDownTimeValue);
                                    List<String>? parts = value?.split(' -');

                                       startTime = parts![0];
                                       endTime = parts[1];
                                      print("Start Time: $startTime");
                                      print("End Time: $endTime");

                                  });
                                },
                                decoration: InputDecoration(
                                  hintText: dropDownTimeValue ?? 'Select a Time',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            );
                          }else if (snapshot.hasError) {
                            return Center(
                              child: Text("${snapshot.error}"),
                            );
                          }
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                    ),


                  ],
                ),
              ),
            ),

            actions: [
              TextButton(
                onPressed: () async{
                  //insertData();
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>AppointmentIdCard(
                    logoPath: 'assets/logohoshospital.png',
                    room: room_name,
                    patient_id: widget.patient_id,
                  )));
                  setState(() {



                  });

                },
                child: Text('Submit'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: Text('Close'),
              ),
            ],
          ),
        );
      },
    );

  }

  Future<void> fetchDoctorSchedule() async {
    final response = await http.post(
      Uri.parse('http://192.168.43.239/hospital_api/doctor_schedule_info.php'),
      body: {'id': widget.doctor_id},
    );

    print(widget.doctor_id);
    print(response.body);
    if (response.statusCode == 200) {
      setState(() {
        selectedDoctorSchedule = jsonDecode(response.body);

        print(selectedDoctorSchedule);
        room_name=selectedDoctorSchedule![0]['Room_name'];
      });
    } else {
      throw Exception('Failed to load doctor schedule');
    }
  }

  List<List<dynamic>> groupSchedulesByDay(List<dynamic> schedules) {
    Map<String, List<dynamic>> groupedSchedules = {};

    for (var schedule in schedules) {
      String dayName = schedule['day_name'];
      if (!groupedSchedules.containsKey(dayName)) {
        groupedSchedules[dayName] = [];
      }
      groupedSchedules[dayName]!.add(schedule);
    }

    return groupedSchedules.values.toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Doctor Schedule'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
             ElevatedButton(onPressed: (){}, child: const Text('Book Appointment')),

              SizedBox(height: 20.0),
              if (selectedDoctorSchedule != null && selectedDoctorSchedule!.isNotEmpty)

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DataTable(
                      columnSpacing: 180.0,
                      headingRowColor: MaterialStateColor.resolveWith((states) => Colors.blue),
                      dataRowColor: MaterialStateColor.resolveWith((states) => Colors.white),
                      columns: const [
                        DataColumn(
                          label: Text(
                            'Doctor Name',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Room',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                      rows: [
                        DataRow(cells: [
                          DataCell(
                            Text(
                              '${selectedDoctorSchedule![0]['staff_name']}',
                              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                            ),
                          ),
                          DataCell(
                            Text(
                              '${selectedDoctorSchedule![0]['Room_name']}',
                              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ]),
                      ],
                    ),

                    for (var daySchedule in groupSchedulesByDay(selectedDoctorSchedule!))
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              showMyDialog(daySchedule[0]['day_id']);
                              day_name=daySchedule[0]['day_name'];
                            },
                            child: DataTable(
                              headingRowColor: MaterialStateColor.resolveWith((states) => Colors.blue),
                              dataRowColor: MaterialStateColor.resolveWith((states) => Colors.white),
                              columns: [
                                DataColumn(
                                  label: Center(

                                      child: Text(' ${daySchedule[0]['day_name']}',
                                        style: TextStyle(color: Colors.white),),
                                    ),
                                  ),

                              ],
                              rows: [

                              ],
                            ),
                          ),

                          const Text(
                            '',
                            // style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                              columnSpacing: 180,
                              columns: const [
                                DataColumn(label: Text('Start Time')),
                                DataColumn(label: Text('End Time')),
                              ],
                              rows: daySchedule.map<DataRow>((schedule) {
                                return schedule['status']=='Inactive'?DataRow(cells: [
                                  DataCell(Text('${schedule['start_time']}',style: TextStyle(color: Colors.green),)) ,
                                  DataCell(Row(children: [Text(' ${schedule['end_time']}',style: TextStyle(color: Colors.green,)),
                                    IconButton(onPressed: (){}, icon: Icon(Icons.check),color: Colors.green,)])),
                                ]):DataRow(cells: [
                                DataCell(Text('${schedule['start_time']}',)) ,
                                DataCell(Text(' ${schedule['end_time']}')),
                                ]);;
                              }).toList(),
                            ),
                          ),
                        ],
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
