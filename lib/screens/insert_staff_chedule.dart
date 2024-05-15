import 'dart:convert';
import 'dart:io';
import 'package:hospital/models/doctor_model.dart';
import 'package:hospital/models/visits_model.dart';
import 'package:hospital/screens/visits.dart';
import 'package:hospital/screens/work_schedule.dart';
import 'package:http/http.dart' as http;
import 'package:date_time_picker_widget/date_time_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:hospital/models/patient_model.dart';

import 'doctor_schedule.dart';

TextEditingController start_time =new TextEditingController();
TextEditingController end_time =new TextEditingController();
TextEditingController Days =new TextEditingController();


class Insert_staff_sch_record_screen extends StatefulWidget {
  const Insert_staff_sch_record_screen({super.key});


  @override
  State<Insert_staff_sch_record_screen> createState() => _Insert_staff_sch_record_screenState();
}

class _Insert_staff_sch_record_screenState extends State<Insert_staff_sch_record_screen> {


  @override
  void initState() {
    // TODO: implement initState
    operations.instance.fetchDoctor();

    super.initState();
  }

  final _form = GlobalKey<FormState>();

  //final List<Map<String, dynamic>> data  =[];
  final List<Map<String, dynamic>> doctor_data = [];
  var dropDownstaffValue;

  Future<void> _selecstartTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      final String formattedTime = '${pickedTime.hour}:${pickedTime.minute}';
      setState(() {
        start_time.text = formattedTime;
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
        end_time.text = formattedTime;
      });
    }
  }




  @override
  Widget build(BuildContext context) {
    int a=0;
    Future<void> insertData() async {

      final data={
        'table': 'work_schedule',
        'data': {
          'staff_id': dropDownstaffValue,
          'work_days': Days.text,
          'start_time': start_time.text,
          'end_time': end_time.text,
        }
      };
      try {
        var response = await http.post(Uri.parse('http://192.168.43.239/hospital_api/All/insertion.php'),
            body: json.encode(data));
        print(response.body);
        setState(() {
          operations.instance.fetchScedule();
        });
        if (response.statusCode == 200) {

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Data inserted successfully')));

          print("Data inserted successfully");
          Navigator.push(context, MaterialPageRoute(builder: (context)=>WorkScreen()));
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
        title: const Center(child: Text('Add Doctor Schedule'),),
      ),
      body: ListView(
        children: [
          Container(
            child: Form(
              key: _form,
              child: Column(
                children: [
                  FutureBuilder(
                      future: operations.instance.fetchStaff(),
                      builder: (context, snapshot){
                        if(snapshot.hasData){
                          List<dynamic> staff =snapshot.data!;

                          return SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: DropdownButtonFormField(
                              value: null,
                              icon: const Icon(Icons.keyboard_arrow_down),
                              items: staff.map((staf) {
                                return DropdownMenuItem(
                                  value: staf['staff_no'].toString(),
                                  child: Row(
                                    children: [
                                      Icon(Icons.people),
                                      SizedBox(width: 10,),
                                      Text(staf['staff_name'].toString())
                                    ],
                                  ),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  dropDownstaffValue=value;
                                  print(dropDownstaffValue);
                                });
                              },
                              decoration: InputDecoration(
                                hintText: dropDownstaffValue != null ? dropDownstaffValue: 'Select a Staff', // Hint text based on selected value
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
                    controller: Days,
                    decoration: InputDecoration(
                      label: Text('Days Of Week'),

                    ),
                    keyboardType: TextInputType.text,

                    autocorrect: false,
                    validator: (value){
                      if(value==null || value.trim().isEmpty
                      ){
                        return 'Please inter a Day';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: start_time,
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
                        return 'Please inter a Time';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: end_time,
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
                        return 'Please inter a Time';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10,),

                  ElevatedButton(onPressed: insertData, child: Text('Save'))
                ],
              ),

            ),

          ),


        ],
      ),
    );
  }
}
