import 'dart:convert';
import 'dart:io';
import 'package:hospital/lab/lab_tests.dart';
import 'package:hospital/lab/retrive_labtests.dart';
import 'package:http/http.dart' as http;
import 'package:date_time_picker_widget/date_time_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:hospital/models/patient_model.dart';

TextEditingController test_name =new TextEditingController();
TextEditingController description =new TextEditingController();
TextEditingController cost =new TextEditingController();


class Update_Lab_t_record_screen extends StatefulWidget {
  const Update_Lab_t_record_screen({super.key,
    required this.test_id, required this.test_name,required this.description, required this.cost
  });

  final String test_id;
  final String test_name;
  final String description;
  final String cost;

  @override
  State<Update_Lab_t_record_screen> createState() => _Update_Lab_t_record_screenState();
}

class _Update_Lab_t_record_screenState extends State<Update_Lab_t_record_screen> {


  @override
  void initState() {
    // TODO: implement initState
    test_name.text=widget.test_name;
    description.text=widget.description;
    cost.text=widget.cost;

    super.initState();
  }

  final _form = GlobalKey<FormState>();

  //final List<Map<String, dynamic>> data  =[];
  final List<Map<String, dynamic>> doctor_data = [];

  @override
  Widget build(BuildContext context) {
    int a=0;
    Future<void> updateData() async {
      final isValid =_form.currentState!.validate();
      if(isValid){
      final data={
        'table': 'lab_tests',
        'data': {
          'test_name': test_name.text,
          'description': description.text,
          'cost': cost.text,
        },
        'updated_id':'test_id',
        'id':widget.test_id
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
          Navigator.push(context, MaterialPageRoute(builder: (context)=>LabtestScreen()));
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
        title: const Center(child: Text('Add Labs'),),
      ),
      body: ListView(
        children: [
          Container(
            child: Form(
              key: _form,
              child: Column(
                children: [

                  TextFormField(
                    controller: test_name,
                    decoration: InputDecoration(
                      label: Text('Test Name'),

                    ),
                    keyboardType: TextInputType.text,

                    autocorrect: false,
                    validator: (value){
                      if(value==null || value.trim().isEmpty
                      ){
                        return 'Please inter Name';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: description,
                    decoration: InputDecoration(
                      label: Text('Description'),

                    ),
                    keyboardType: TextInputType.text,

                    autocorrect: false,
                    validator: (value){
                      if(value==null || value.trim().isEmpty
                      ){
                        return 'Please Enter Description';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: cost,
                    decoration: InputDecoration(
                        label: Text('Cost'),
                        hintText: 'Enter the cost'
                    ),
                    keyboardType: TextInputType.number,
                    autocorrect: false,
                    validator: (value){
                      if(value==null || value.trim().isEmpty
                      ){
                        return 'Please Enter A cost';
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
