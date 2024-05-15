import 'dart:convert';
import 'dart:io';
import 'package:hospital/lab/lab_results.dart';
import 'package:hospital/lab/retrive_labtests.dart';
import 'package:hospital/lab/samples.dart';
import 'package:hospital/models/visits_model.dart';
import 'package:hospital/screens/visits.dart';
import 'package:http/http.dart' as http;
import 'package:date_time_picker_widget/date_time_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:hospital/models/patient_model.dart';

TextEditingController result_date =new TextEditingController();
TextEditingController result =new TextEditingController();


class Update_Result_record_screen extends StatefulWidget {
  const Update_Result_record_screen({super.key,
    required this.result_id,required this.ds_no,
    required this.sample_no, required this.result,
    required this.datereceived
  });
  final String result_id;
  final String ds_no;
  final String sample_no;
  final String result;
  final String datereceived;
  @override
  State<Update_Result_record_screen> createState() => _Update_result__record_screenState();
}

class _Update_result__record_screenState extends State<Update_Result_record_screen> {


  @override
  void initState() {
    // TODO: implement initState
    dropDowndsValue =widget.ds_no;
    dropDownsampleValue =widget.sample_no;
    result.text =widget.result;
    result_date.text =widget.datereceived;
    super.initState();
  }
  final _form = GlobalKey<FormState>();
  //final List<Map<String, dynamic>> data  =[];
  final List<Map<String, dynamic>> doctor_data  =[];
  var dropDownsampleValue;
  var dropDowndsValue;
  var dropDowntestValue;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        result_date.text = picked.toString().substring(0,
            10);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    int a=0;
    Future<void> updateData() async {
      final isValid =_form.currentState!.validate();
      if(isValid){
        final data={
          'table': 'lab_results',
          'data': {
            'ds_no': dropDowndsValue,
            'sample_id': dropDownsampleValue,
            'result': result.text,
            'date_result_received': result_date.text,
          },
          'updated_id':'result_id',
          'id':widget.result_id
        };
        try {
          var response = await http.post(Uri.parse('http://192.168.43.239/hospital_api/All/update.php'),
              body: json.encode(data));
          print(response.body);
          setState(() {
            operationsLab.instance.fetch_Data('select * from lab_tests');
          });
          if (response.statusCode == 200) {

            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Data Updated successfully')));

            print("Data Updated successfully");
            Navigator.push(context, MaterialPageRoute(builder: (context)=>LabResulttestScreen()));
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
        title: Center(child: Text('Add Results'),),
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
                        future: operationsLab.instance.fetch_Data('select * from deseases'),
                        builder: (context, snapshot){
                          if(snapshot.hasData){
                            List<dynamic> ds =snapshot.data!;

                            return SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: DropdownButtonFormField(
                                value: null,
                                icon: const Icon(Icons.keyboard_arrow_down),
                                items: ds.map((dise) {
                                  return DropdownMenuItem(
                                    value: dise['ds_no'].toString(),
                                    child: Row(
                                      children: [
                                        Icon(Icons.people),
                                        SizedBox(width: 10,),
                                        Text(dise['ds_name'].toString())
                                      ],
                                    ),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    dropDowndsValue=value;
                                    print(dropDowndsValue);
                                  });
                                },
                                decoration: InputDecoration(
                                  hintText: dropDowndsValue != null ? dropDowndsValue: 'Select a disease', // Hint text based on selected value
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
                        future: operationsLab.instance.fetch_Data('SELECT sample_id, '
                            'test_name from lab_tests,lab_samples where lab_tests.test_id=lab_samples.test_id'),
                        builder: (context, snapshot){
                          if(snapshot.hasData){
                            List<dynamic> data =snapshot.data!;

                            return SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: DropdownButtonFormField(
                                value: null,
                                icon: const Icon(Icons.keyboard_arrow_down),
                                items: data.map((sam) {
                                  return DropdownMenuItem(
                                    value: sam['sample_id'].toString(),
                                    child: Row(
                                      children: [
                                        Icon(Icons.people),
                                        SizedBox(width: 10,),
                                        Text(sam['test_name'].toString())
                                      ],
                                    ),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {

                                    dropDownsampleValue=value;
                                    print(dropDownsampleValue);
                                  });
                                },
                                decoration:  InputDecoration(
                                  hintText:  dropDownsampleValue != null ? dropDownsampleValue: 'Select a sample test', // Hint text based on selected value
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
                      controller: result,
                      decoration: const InputDecoration(
                        label: Text('Result'),
                      ),
                      keyboardType: TextInputType.text,

                      autocorrect: false,
                      validator: (value){
                        if(value==null || value.trim().isEmpty
                        ){
                          return 'Please inter a Result';
                        }
                        return null;
                      },
                    ),

                    TextFormField(
                      controller: result_date,
                      decoration: InputDecoration(
                        label: Text('Date Received'),
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
          ElevatedButton(onPressed: updateData, child: Text('Update'))

        ],
      ),
    );
  }
}
