import 'dart:convert';
import 'package:hospital/lab/retrive_labtests.dart';
import 'package:hospital/lab/samples.dart';
import 'package:http/http.dart' as http;
import 'package:date_time_picker_widget/date_time_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:hospital/models/patient_model.dart';

TextEditingController taken_date =new TextEditingController();

class Insert_sample_record_screen extends StatefulWidget {
  const Insert_sample_record_screen({super.key});

  @override
  State<Insert_sample_record_screen> createState() => _Insert_sample__record_screenState();
}

class _Insert_sample__record_screenState extends State<Insert_sample_record_screen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  final _form = GlobalKey<FormState>();
  //final List<Map<String, dynamic>> data  =[];
  final List<Map<String, dynamic>> doctor_data  =[];
  var dropDowndocValue;
  var dropDownpaValue;
  var dropDowntestValue;
  var amount;
  var descrip;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        taken_date.text = picked.toString().substring(0,
            10);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    int a=0;
    Future<void> insertData() async {
      final isValid =_form.currentState!.validate();
      if(isValid){
        final data={
          'table': 'lab_samples',
          'data': {
            'patient_id': dropDownpaValue,
            'doctor_id': dropDowndocValue,
            'date_taken': taken_date.text,
            'test_no': dropDowntestValue,
          }
        };
        try {
          var response = await http.post(Uri.parse('http://192.168.43.239/hospital_api/All/insertion.php'),
              body: json.encode(data));
          print(response.body);
           setState(() {
          final data =  operationsLab.instance.fetch_Data(
                'SELECT * FROM lab_samples ls join lab_tests lt on ls.test_no=lt.test_id where test_no= ${dropDowntestValue}');
            data.then((value) async{
              value.map((e) {
                amount= e['cost'];
                print(amount);
                descrip=e['description'];

              } ).toList();
              final data_charge={
                'table': 'patient_charge',
                'data': {
                  'ch_datetime': taken_date.text,
                  'amount': amount,
                  'discription': descrip,
                  'p_no': dropDownpaValue,
                }
              };
              var result = await http.post(Uri.parse('http://192.168.43.239/hospital_api/All/insertion.php'),
                  body: json.encode(data_charge));
              print(result.body);
            } );
          });
          if (response.statusCode == 200) {

            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Data inserted successfully')));

            print("Data inserted successfully");
            Navigator.push(context, MaterialPageRoute(builder: (context)=>LabSampletestScreen()));
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

    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Add sample'),),
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
                      controller: taken_date,
                      decoration: InputDecoration(
                        label: Text('Date Taken'),
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
                    FutureBuilder(
                        future: operationsLab.instance.fetch_Data('SELECT * FROM lab_tests'),
                        builder: (context, snapshot){
                          if(snapshot.hasData){
                            List<dynamic> data =snapshot.data!;

                            return SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: DropdownButtonFormField(
                                value: null,
                                icon: const Icon(Icons.keyboard_arrow_down),
                                items: data.map((lab) {
                                  return DropdownMenuItem(
                                    value: lab['test_id'].toString(),
                                    child: Row(
                                      children: [
                                        Icon(Icons.people),
                                        SizedBox(width: 10,),
                                        Text(lab['test_name'].toString())
                                      ],
                                    ),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {

                                    dropDowntestValue=value;
                                    print(value);
                                  });
                                },
                                decoration: InputDecoration(
                                  hintText: dropDowntestValue != null ? dropDowntestValue: 'Select a test', // Hint text based on selected value
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
            onPressed: insertData,
            child: Text('Save'),
          ),

        ],
      ),
    );
  }
}
