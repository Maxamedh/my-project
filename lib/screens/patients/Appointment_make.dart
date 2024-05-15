import 'dart:convert';
import 'dart:io';
import 'package:hospital/models/visits_model.dart';
import 'package:hospital/screens/visits.dart';
import 'package:http/http.dart' as http;
import 'package:date_time_picker_widget/date_time_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:hospital/models/patient_model.dart';
var jinsiga = 'Male';
var jinsi = ['Male','Female'];
TextEditingController patient =new TextEditingController();
TextEditingController doctor =new TextEditingController();
TextEditingController v_date =new TextEditingController();


class Insert_Appointment_record_screen extends StatefulWidget {

  const Insert_Appointment_record_screen({
    super.key,
    required this.doctor_id,
    required this.patient_id,
    required this.day_name
  });

  final day_name;
  final doctor_id;
  final patient_id;



  @override
  State<Insert_Appointment_record_screen> createState() => _Insert_Appointment__record_screenState();
}

class _Insert_Appointment__record_screenState extends State<Insert_Appointment_record_screen> {


  @override
  void initState() {
    // TODO: implement initState
    operations.instance.fetchDoctor();
    operations.instance.Patient_info();
    super.initState();
  }
  final _form = GlobalKey<FormState>();
  //final List<Map<String, dynamic>> data  =[];
  final List<Map<String, dynamic>> doctor_data  =[];
  var dropDowndocValue;
  var dropDownpaValue;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        v_date.text = picked.toString().substring(0,
            10);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    int a=0;
    Future<void> _submit() async {
      final isValid = _form.currentState!.validate();

      if (isValid) {
        final result =await operationsvisits.instance.add_Visit(Visit(
            vNo: a.toString(), name: dropDownpaValue, staffName: dropDowndocValue, vDate: v_date.text)
        );
        setState(() {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${result}")));
          operations.instance.fetchVisits();
          Navigator.push(context, MaterialPageRoute(builder: (context)=>VisitScreen()));
          a++;
        });
      }else {
        print('not validate');
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('insert the appointment'),),
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
                        future: operations.instance.Patient_info(),
                        builder: (context, snapshot){
                          if(snapshot.hasData){
                            List<dynamic> pa =snapshot.data!;

                            return SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: DropdownButtonFormField(
                                value: null,
                                icon: const Icon(Icons.keyboard_arrow_down),
                                items: pa.map((pat) {
                                  return DropdownMenuItem(
                                    value: pat['p_no'].toString(),
                                    child: Row(
                                      children: [
                                        Icon(Icons.people),
                                        SizedBox(width: 10,),
                                        Text(pat['name'].toString())
                                      ],
                                    ),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    dropDownpaValue=value;
                                    print(dropDownpaValue);
                                  });
                                },
                                decoration: InputDecoration(
                                  hintText: dropDownpaValue != null ? dropDownpaValue: 'Select a patient', // Hint text based on selected value
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
                        future: operations.instance.fetchDoctor(),
                        builder: (context, snapshot){
                          if(snapshot.hasData){
                            List<dynamic> data =snapshot.data!;

                            return SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: DropdownButtonFormField(
                                value: null,
                                icon: const Icon(Icons.keyboard_arrow_down),
                                items: data.map((doct) {
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
                                    print(value);
                                  });
                                },
                                decoration: InputDecoration(
                                  hintText: dropDowndocValue != null ? dropDowndocValue: 'Select a doctor', // Hint text based on selected value
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
                      controller: v_date,
                      decoration: InputDecoration(
                        label: Text('Appointment Day'),

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
                    FutureBuilder(
                        future: operations.instance.fetchDoctor(),
                        builder: (context, snapshot){
                          if(snapshot.hasData){
                            List<dynamic> data =snapshot.data!;

                            return SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: DropdownButtonFormField(
                                value: null,
                                icon: const Icon(Icons.keyboard_arrow_down),
                                items: data.map((doct) {
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
                                    print(value);
                                  });
                                },
                                decoration: InputDecoration(
                                  hintText: dropDowndocValue != null ? dropDowndocValue: 'Select a doctor', // Hint text based on selected value
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
          TextButton(
            onPressed: _submit,
            child: Text('Save'),
          ),

        ],
      ),
    );
  }
}
