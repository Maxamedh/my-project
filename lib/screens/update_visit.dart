import 'dart:convert';
import 'dart:io';
import 'package:hospital/models/visits_model.dart';
import 'package:hospital/screens/visits.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:hospital/models/patient_model.dart';

TextEditingController v_date =new TextEditingController();


class Update_visit_record_screen extends StatefulWidget {
  const Update_visit_record_screen({super.key,
    required this.id,required this.patient,required this.doctor,
    required this.vdate});

  final String id;
  final String patient;
  final String doctor;
  final String vdate;

  @override
  State<Update_visit_record_screen> createState() => _Update_visit__record_screenState();
}

class _Update_visit__record_screenState extends State<Update_visit_record_screen> {


  @override
  void initState() {
    // TODO: implement initState
    operations.instance.fetchDoctor();
    operations.instance.Patient_info();
    dropDownpaValue=widget.patient;
    dropDowndocValue=widget.doctor;
    v_date.text=widget.vdate;
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


    Future<void> update() async {
      final isValid = _form.currentState!.validate();

      if (isValid) {
        final result =await operationsvisits.instance.update_Visit(Visit(
            vNo: widget.id, name: dropDownpaValue, staffName: dropDowndocValue, vDate: v_date.text)
        );
        setState(() {
          print(result);
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
                        label: Text('Visit Date'),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.calendar_today),
                          onPressed: () => _selectDate(context),
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

                  ],
                ),
              ),
            ),

          ),
          TextButton(
            onPressed: update,
            child: Text('Update'),
          ),

        ],
      ),
    );
  }
}
