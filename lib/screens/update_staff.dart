import 'dart:convert';
import 'dart:io';
import 'package:hospital/models/staff_model.dart';
import 'package:hospital/screens/Admin/patient_registration.dart';
import 'package:hospital/screens/staffs.dart';
import 'package:http/http.dart' as http;
import 'package:date_time_picker_widget/date_time_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:hospital/models/patient_model.dart';

var jinsiga;
var jinsi = ['Male','Female'];
TextEditingController name =new TextEditingController();
TextEditingController tell =new TextEditingController();
TextEditingController gmail =new TextEditingController();

class Update_Staff_screen extends StatefulWidget {
  const Update_Staff_screen({super.key,required this.staffNo,required this.staffName,required this.job
  ,required this.tell,required this.gmail,required this.address, required this.sex});

  final String staffNo;
  final String staffName;
  final String job;
  final String tell;
  final String gmail;
  final String address;
  final String sex;

  @override
  State<Update_Staff_screen> createState() => _Update_Staff_screenState();
}

class _Update_Staff_screenState extends State<Update_Staff_screen> {
  @override
  void initState() {
    // TODO: implement initState
name.text=widget.staffName;
dropDownJobValue=widget.job;
tell.text=widget.tell;
gmail.text=widget.gmail;
dropDownValue=widget.address;
jinsiga=widget.sex;

    super.initState();
  }

  final _form = GlobalKey<FormState>();
  final List<Map<String, dynamic>> data  =[];
  var dropDownJobValue;
  var dropDownValue;



  @override
  Widget build(BuildContext context) {
    Future<void> _update() async {
      final isValid = _form.currentState!.validate();
      var a=0;
      if (isValid) {
        String result = await operationsStaff.instance.update_Staff(
          Staff(
            staffNo: widget.staffNo.toString(),
            staffName: name.text,
            job: dropDownJobValue,
            tell: tell.text,
            gmail: gmail.text,
            address: dropDownValue,
            sex: jinsiga,
          ),
        );
        print(result);

        Map<String, dynamic> resultMap = jsonDecode(result);

        setState(() {
          if (resultMap['success'] == true) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(resultMap['message'])));
            operations.instance.fetchStaff();
            Navigator.push(context, MaterialPageRoute(builder: (context) => StaffScreen()));
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
          title: Center(child: Text('Insert Staff'))
      ),
      body: ListView(
        children: [
          Text(widget.staffNo.toString()),
          Container(
            child: Form(
              key: _form,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    TextFormField(
                      controller: name,
                      decoration: InputDecoration(
                          label: Text('Name'),
                          hintText: 'Enter Name'
                      ),
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.none,
                      autocorrect: false,
                      validator: (value){
                        if(value==null || value.trim().isEmpty
                        ){
                          return 'Please inter A Name';
                        }
                        return null;
                      },
                    ),
                    FutureBuilder(
                        future: operations.instance.address_info(),
                        builder: (context, snapshot){
                          if(snapshot.hasData){
                            List<dynamic> address =snapshot.data!;

                            return SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: DropdownButtonFormField(
                                value: null,
                                icon: const Icon(Icons.keyboard_arrow_down),
                                items: address.map((add) {
                                  return DropdownMenuItem(
                                    value: add['add_no'].toString(),
                                    child: Row(
                                      children: [
                                        Icon(Icons.people),
                                        SizedBox(width: 10,),
                                        Text('${add['district'].toString()} ${add['village'].toString()}')
                                      ],
                                    ),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    dropDownValue=value;
                                    print(dropDownValue);
                                  });
                                },
                                decoration: InputDecoration(
                                  hintText: dropDownValue != null ? dropDownValue: 'Select Job', // Hint text based on selected value
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
                      controller: tell,
                      decoration: InputDecoration(
                          label: Text('Tell'),
                          hintText: 'Enter tell'
                      ),
                      keyboardType: TextInputType.number,
                      autocorrect: false,
                      validator: (value){
                        if(value==null || value.trim().length<10
                        ){
                          return 'Please Enter a valid number';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: gmail,
                      decoration: InputDecoration(
                        labelText: 'Email Address',
                      ),
                      keyboardType: TextInputType.emailAddress,
                      autocorrect: false,
                      textCapitalization: TextCapitalization.none,
                      validator: (value){
                        if(value==null || value.trim().isEmpty || !value.contains('@')
                        ){
                          return 'Please inter a valid email address';
                        }
                        return null;
                      },
                      onSaved: (newValue) {

                      },
                    ),
                    FutureBuilder(
                        future: operationsStaff.instance.fetch_jobs(),
                        builder: (context, snapshot){
                          if(snapshot.hasData){
                            List<dynamic> jobs =snapshot.data!;

                            return SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: DropdownButtonFormField(
                                value: null,
                                icon: const Icon(Icons.keyboard_arrow_down),
                                items: jobs.map((job) {
                                  return DropdownMenuItem(
                                    value: job['j_no'].toString(),
                                    child: Row(
                                      children: [
                                        Icon(Icons.people),
                                        SizedBox(width: 10,),
                                        Text(job['job_name'])
                                      ],
                                    ),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    dropDownJobValue=value!;
                                    print(dropDownJobValue);
                                  });
                                },
                                decoration: InputDecoration(
                                  hintText: dropDownJobValue != null ? dropDownJobValue: 'Select a Address', // Hint text based on selected value
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
                    DropdownButtonFormField<String>(
                      value: null,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      items: jinsi.map((String jinsi){
                        return DropdownMenuItem(

                          value: jinsi,
                          child: Row(
                            children: [
                              Icon(Icons.people),
                              SizedBox(width: 10,),
                              Text(jinsi)
                            ],
                          ),
                        );

                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          jinsiga = value!;

                        });
                      },
                      decoration: InputDecoration(
                        hintText: jinsiga != null ? jinsiga: 'Select a sex', // Hint text based on selected value
                        border: OutlineInputBorder(),
                      ),
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
