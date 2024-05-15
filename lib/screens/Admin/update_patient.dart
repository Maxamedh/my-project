import 'dart:convert';
import 'dart:io';
import 'package:hospital/screens/Admin/patient_registration.dart';
import 'package:http/http.dart' as http;
import 'package:date_time_picker_widget/date_time_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:hospital/models/patient_model.dart';

var jinsiga;
var jinsi = ['Male','Female'];
TextEditingController name =new TextEditingController();
TextEditingController tell =new TextEditingController();
TextEditingController email =new TextEditingController();
TextEditingController password =new TextEditingController();
TextEditingController birth_date =new TextEditingController();
class Update_record_screen extends StatefulWidget {
  const Update_record_screen({super.key,
    required this.id,required this.name, required this.tell,
  required this.sex,required this.gmail, required this.password,required this.address,required this.birth_date});
  final String id;
  final String name;
  final String tell;
  final String sex;
  final String gmail;
  final String password;
  final String address;
  final String birth_date;


  @override
  State<Update_record_screen> createState() => _Update_record_screenState();
}

class _Update_record_screenState extends State<Update_record_screen> {
  @override
  void initState() {
    // TODO: implement initState
    name.text=widget.name;
    tell.text=widget.tell;
    jinsiga=widget.sex;
    email.text=widget.gmail;
    password.text=widget.password;
    dropDownValue=widget.address;
    birth_date.text=widget.birth_date;

    super.initState();
  }

  final _form = GlobalKey<FormState>();
  final List<Map<String, dynamic>> data  =[];
  var dropDownValue;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        birth_date.text = picked.toString().substring(0,
            10);
      });
    }
  }


  @override
  Widget build(BuildContext context) {



    Future<void> update() async {
      final isValid = _form.currentState!.validate();

      if (isValid) {
        final result =await operations.instance.update_patient(
            Patient(id: widget.id, name: name.text, tell: tell.text, sex: jinsiga,
                gmail: email.text, password: password.text,
                address: dropDownValue, birth_date: birth_date.text,
            ));
        setState(() {
          print(result);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${result}")));
          operations.instance.fetchVisits();
          Navigator.push(context, MaterialPageRoute(builder: (context)=>PatientRegistrationScreen()));

        });
      }else {
        print('not validate');
      }
    }
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('update the patient'),),
      ),
      body: ListView(
        children: [
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
              TextFormField(
                controller: email,
                decoration: InputDecoration(
                    label: Text('Email'),
                    hintText: 'Enter Email'
                ),
                keyboardType: TextInputType.emailAddress,
                textCapitalization: TextCapitalization.none,
                autocorrect: false,
                validator: (value){
                  if(value==null || value.trim().isEmpty || !value.contains('@')
                  ){
                    return 'Please inter a valid email address';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: password,
                decoration: InputDecoration(
                  labelText: 'Password',
                ),

                obscureText: true,
                validator: (value) {
                  if(value==null || value.trim().length < 6 ) {
                    return 'Password must be at least 6 characters long';
                  }
                  return null;
                },
                onSaved: (newValue){

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
                            hintText: dropDownValue != null ? dropDownValue: 'Select a Address', // Hint text based on selected value
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
                controller: birth_date,
                decoration: InputDecoration(
                  label: Text('Birth_date'),
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
              Text(widget.id),
            ],
          ),
        ),
      ),

          ),
          TextButton(
            onPressed: () async{
              update();

              setState(() {



              });

            },
            child: Text('Update'),
          ),

        ],
      ),
    );
  }
}
