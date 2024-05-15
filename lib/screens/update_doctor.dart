import 'dart:convert';
import 'dart:io';
import 'package:hospital/models/doctor_model.dart';
import 'package:hospital/models/visits_model.dart';
import 'package:hospital/screens/Admin/doctor_registration.dart';
import 'package:hospital/screens/visits.dart';
import 'package:http/http.dart' as http;
import 'package:date_time_picker_widget/date_time_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:hospital/models/patient_model.dart';
var jinsiga = 'Male';
var jinsi = ['Male','Female'];

TextEditingController h_date =new TextEditingController();


class Update_doctor_record_screen extends StatefulWidget {
  const Update_doctor_record_screen({super.key,
    required this.doctorNo,required this.doctor_name,
    required this.specialization,
    required this.decree
  });
  final String doctorNo;
  final String doctor_name;
  final String specialization;
  final String decree;

  @override
  State<Update_doctor_record_screen> createState() => _Update_doctor__record_screenState();
}

class _Update_doctor__record_screenState extends State<Update_doctor_record_screen> {


  @override
  void initState() {
    // TODO: implement initState
    dropDownstaffValue=widget.doctor_name;
    dropDownspValue=widget.specialization;
    dropDowndecValue = widget.decree;

    super.initState();
  }
  final _form = GlobalKey<FormState>();
  //final List<Map<String, dynamic>> data  =[];
  final List<Map<String, dynamic>> doctor_data  =[];
  var dropDownstaffValue;
  var dropDownspValue;
  var dropDowndecValue;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        h_date.text = picked.toString().substring(0,
            10);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    int a=0;
    Future<void> _update() async {
      final isValid = _form.currentState!.validate();

      if (isValid) {
        final result =await operationsDoctor.instance.update_Doctor(
            Doctor(doctorNo: widget.doctorNo, doctor_name: dropDownstaffValue,
                specialization: dropDownspValue, decree: dropDowndecValue

            ));
        print(result);
        Map<String, dynamic> resultMap = jsonDecode(result);
        print(resultMap);
        setState(() {
          if (resultMap['success'] == true) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(resultMap['message'])));
            operations.instance.fetchDoctor();
            Navigator.push(context, MaterialPageRoute(builder: (context) => DoctorRegistrationScreen()));
            a++;
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(resultMap['message'])));
          }
        });
      }else {
        print('not validate');
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('update the patient'),),
      ),
      body: Column(
        children: [
          Container(
            child: Form(
              key: _form,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    FutureBuilder(
                        future:  operations.instance.fetchStaff(),
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
                                  hintText: dropDownstaffValue != null ? dropDownstaffValue: 'Select a Doctor', // Hint text based on selected value
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
                        future: operationsDoctor.instance.fetch_Special(),
                        builder: (context, snapshot){
                          if(snapshot.hasData){
                            List<dynamic> special =snapshot.data!;

                            return SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: DropdownButtonFormField(
                                value: null,
                                icon: const Icon(Icons.keyboard_arrow_down),
                                items: special.map((sp) {
                                  return DropdownMenuItem(
                                    value: sp['sp_no'].toString(),
                                    child: Row(
                                      children: [
                                        Icon(Icons.people),
                                        SizedBox(width: 10,),
                                        Text(sp['sp_name'].toString())
                                      ],
                                    ),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {

                                    dropDownspValue=value;
                                    print(value);
                                  });
                                },
                                decoration: InputDecoration(
                                  hintText: dropDownspValue != null ? dropDownspValue: 'Select a doctor', // Hint text based on selected value
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
                        future: operationsDoctor.instance.fetch_decree(),
                        builder: (context, snapshot){
                          if(snapshot.hasData){
                            List<dynamic> decree =snapshot.data!;

                            return SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: DropdownButtonFormField(
                                value: null,
                                icon: const Icon(Icons.keyboard_arrow_down),
                                items: decree.map((dec) {
                                  return DropdownMenuItem(
                                    value: dec['dc_no'].toString(),
                                    child: Row(
                                      children: [
                                        Icon(Icons.people),
                                        SizedBox(width: 10,),
                                        Text(dec['dc_name'].toString())
                                      ],
                                    ),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {

                                    dropDowndecValue=value;
                                    print(value);
                                  });
                                },
                                decoration: InputDecoration(
                                  hintText: dropDowndecValue != null ? dropDowndecValue: 'Select a decree', // Hint text based on selected value
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

          ),
          SizedBox(height: 16,),
          ElevatedButton(onPressed: _update, child: Text('Update'))

        ],
      ),
    );
  }
}
