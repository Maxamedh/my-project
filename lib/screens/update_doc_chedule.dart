import 'dart:convert';
import 'dart:io';
import 'package:hospital/models/doctor_model.dart';
import 'package:hospital/lab/retrive_labtests.dart';
import 'package:hospital/screens/doctor_schedule.dart';
import 'package:hospital/screens/visits.dart';
import 'package:http/http.dart' as http;
import 'package:date_time_picker_widget/date_time_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:hospital/models/patient_model.dart';

TextEditingController start_date =new TextEditingController();
TextEditingController end_date =new TextEditingController();
TextEditingController Days =new TextEditingController();


class Update_Doctor_av_record_screen extends StatefulWidget {
  const Update_Doctor_av_record_screen({super.key,
    required this.doc_av_no,required this.Doctor_id,
    required this.room_no, required this.day_of_week,
    required this.startTime, required this.endTime

  });
  final String doc_av_no;
  final String Doctor_id;
  final String room_no;
  final String day_of_week;
  final String startTime;
  final String endTime;

  @override
  State<Update_Doctor_av_record_screen> createState() => _Update_Doctor_av_record_screenState();
}

class _Update_Doctor_av_record_screenState extends State<Update_Doctor_av_record_screen> {


  @override
  void initState() {
    // TODO: implement initState
    operations.instance.fetchDoctor();
    dropDowndocValue=widget.Doctor_id;
    dropDownroomValue=widget.room_no;
    Days.text=widget.day_of_week;
    start_date.text=widget.startTime;
    end_date.text=widget.endTime;
    super.initState();
  }
  var startTime=start_date.text;
  var endTime=end_date.text;
  final _form = GlobalKey<FormState>();

  //final List<Map<String, dynamic>> data  =[];
  final List<Map<String, dynamic>> doctor_data = [];
  var dropDowndocValue;
  var dropDownroomValue;
  var dropDowndayValue;

  Future<void> _selecstartTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      final String formattedTime = '${pickedTime.hour}:${pickedTime.minute}';
      setState(() {
        start_date.text = formattedTime;
      });
    }
  }



  Future<void> _selectEndtTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      // Format the selected time
      final String formattedTime = '${pickedTime.hour}:${pickedTime.minute}';
      setState(() {
        end_date.text = formattedTime;
      });
    }
  }




  @override
  Widget build(BuildContext context) {
    int a=0;
    Future<void> updateData() async {

      final data={
        'table': 'doctor_availability',
        'data': {
          'doctor_id': dropDowndocValue,
          'room_no': dropDownroomValue,
          'day_of_week': dropDowndayValue,
          'start_time': start_date.text,
          'end_time': end_date.text,
        },
        'updated_id':'do_av_no',
        'id':widget.doc_av_no
      };
      try {
        var response = await http.post(Uri.parse('http://192.168.43.239/hospital_api/All/update.php'),
            body: json.encode(data));
        print(response.body);
        setState(() {
          operations.instance.fetchdoctor_schedule();
        });
        if (response.statusCode == 200) {

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Data Updated successfully')));

          print("Data Updated successfully");
          Navigator.push(context, MaterialPageRoute(builder: (context)=>DoctorScheduleScreen()));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Data failed response body  ${response.body}')));
          print("Failed to insert data");
          print("Status code: ${response.statusCode}");
          print("Response body: ${response.body}");
        }
      } catch (e) {
        print("There was an error: $e");
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('update the Doctor Schedule'),),
      ),
      body: ListView(
        children: [
          Container(
            child: Form(
              key: _form,
              child: Column(
                children: [
                  FutureBuilder(
                      future: operations.instance.fetchDoctor(),
                      builder: (context, snapshot){
                        if(snapshot.hasData){
                          List<dynamic> doct =snapshot.data!;

                          return SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: DropdownButtonFormField(
                              value: null,
                              icon: const Icon(Icons.keyboard_arrow_down),
                              items: doct.map((doct) {
                                return DropdownMenuItem(
                                  value: doct['doctor_no'].toString(),
                                  child: Row(
                                    children: [
                                      Icon(Icons.people),
                                      SizedBox(width: 10,),
                                      Text(doct['staff_name'].toString())
                                    ],
                                  ),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  dropDowndocValue=value;
                                  print(dropDowndocValue);
                                });
                              },
                              decoration: InputDecoration(
                                hintText: dropDowndocValue != null ? dropDowndocValue: 'Select a Doctor', // Hint text based on selected value
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
                  FutureBuilder(
                      future: operationsDoctor.instance.fetch_rooms(),
                      builder: (context, snapshot){
                        if(snapshot.hasData){
                          List<dynamic> rooms =snapshot.data!;

                          return SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: DropdownButtonFormField(
                              value: null,
                              icon: const Icon(Icons.keyboard_arrow_down),
                              items: rooms.map((room) {
                                return DropdownMenuItem(
                                  value: room['R_no'].toString(),
                                  child: Row(
                                    children: [
                                      Icon(Icons.people),
                                      SizedBox(width: 10,),
                                      Text(room['Room_name'].toString())
                                    ],
                                  ),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {

                                  dropDownroomValue =value;
                                  print(value);
                                });
                              },
                              decoration: InputDecoration(
                                hintText: dropDownroomValue != null ? dropDownroomValue: 'Select a Room', // Hint text based on selected value
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
                  FutureBuilder(
                      future: operationsLab.instance.fetch_Data('SELECT * FROM days'),
                      builder: (context, snapshot){
                        if(snapshot.hasData){
                          List<dynamic> day =snapshot.data!;

                          return SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: DropdownButtonFormField(
                              value: null,
                              icon: const Icon(Icons.keyboard_arrow_down),
                              items: day.map((da) {
                                return DropdownMenuItem(
                                  value: da['day_id'].toString(),
                                  child: Row(
                                    children: [
                                      Icon(Icons.people),
                                      SizedBox(width: 10,),
                                      Text(da['day_name'].toString())
                                    ],
                                  ),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  dropDowndayValue=value;
                                  print(dropDowndayValue);
                                });
                              },
                              decoration: InputDecoration(
                                hintText: dropDowndayValue != null ? dropDowndayValue: 'Select a Day', // Hint text based on selected value
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
                  TextFormField(
                    controller: start_date,
                    decoration: InputDecoration(
                      label: Text('Start Time'),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.calendar_today),
                        onPressed: () => _selecstartTime(context),
                      ),
                    ),
                    keyboardType: TextInputType.text,

                    autocorrect: false,
                    validator: (value){
                      if(value==null || value.trim().isEmpty
                      ){
                        return 'Please inter a Date';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: end_date,
                    decoration: InputDecoration(
                      label: Text('End Time'),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.calendar_today),
                        onPressed: () => _selectEndtTime(context),
                      ),
                    ),
                    keyboardType: TextInputType.text,

                    autocorrect: false,
                    validator: (value){
                      if(value==null || value.trim().isEmpty
                      ){
                        return 'Please inter a Date';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10,),

                  ElevatedButton(onPressed: updateData, child: Text('Update'))
                ],
              ),

            ),

          ),


        ],
      ),
    );
  }
}
