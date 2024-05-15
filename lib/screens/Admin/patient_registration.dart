import 'dart:convert';
import 'dart:io';
import 'package:hospital/screens/Admin/update_patient.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:hospital/models/patient_model.dart';
import 'package:date_time_picker_widget/date_time_picker_widget.dart';

var jinsiga = 'Male';
var jinsi = ['Male','Female'];
TextEditingController name =new TextEditingController();
TextEditingController tell =new TextEditingController();
TextEditingController email =new TextEditingController();
TextEditingController password =new TextEditingController();
TextEditingController birth_date =new TextEditingController();

class PatientRegistrationScreen extends StatefulWidget {
  const PatientRegistrationScreen({super.key});

  @override
  State<PatientRegistrationScreen> createState() => _PatientRegistrationScreenState();
}
class _PatientRegistrationScreenState extends State<PatientRegistrationScreen> {
  final _form = GlobalKey<FormState>();
  final  address = operations.instance.address_info();

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
  void initState() {
    // TODO: implement initState
    operations.instance.Patient_info();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {


    Future<void> delete_record(var id) async{

      final response = await http.post(Uri.parse('http://192.168.43.239/hospital_api/patient_oper/delete_patient.php'),
        body: {
          'id':id,
        },
      );
      if(response.statusCode==200){
        Map<String,dynamic> data =json.decode(response.body);
        print(data);
        setState(() {
          if(data['success']){
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('data deleted successfully')));

            operations.instance.Patient_info();
          }else{
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Data Not Deleted Successfully  ${data}')));
          }
        });

      }

    }
    Future<void> _submit() async{
      final isValid =_form.currentState!.validate();
      if(isValid){
        Map<String,dynamic> body={
          'name':name.text,
          'tell':tell.text,
          'sex':jinsiga,
          'email':email.text,
          'password':password.text,
          'add_no':dropDownValue,
          'birth_date':birth_date.text,
        };
        final response = await http.post(Uri.parse('http://192.168.43.239/hospital_api/patient_oper/patien_registration.php'),
          body: body,
        );

        if (response.statusCode == 200) {
          // If the server returns an OK response, parse the JSON
          Map<String, dynamic> data = json.decode(response.body);
          if (data['success']) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:
            Text('data inserted succeed')));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:
            Text('data insertion failed')));
          }
        } else {
          // If the server returns an error response, throw an exception.
          throw Exception('Failed to load data');
        }

      }else{
        print('not valid');
      }
    }

    final List<Map<String, dynamic>> data  =[];

    showMyDialog() {
    setState(() {
     address.then((value) {
       value.map((e){
         data.add(e);
       }).toList();
     });

    });
var i;



      // final List<Map<String, dynamic>> data =List<Map<String, dynamic>>.from(addressfield.map((x) => json.decode(x)));
      return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Container(
            child: AlertDialog(
              title: Text('Alert'),
              content:  Form(
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
                        DropdownButtonFormField(
                          value: jinsiga,
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


                       DropdownButtonFormField(
                        value: dropDownValue,
                                icon: Icon(Icons.keyboard_arrow_down),
                                items: data.map((addf){
                                  return DropdownMenuItem(

                                    value: addf['add_no'],
                                      child: Row(
                                        children: [
                                          Icon(Icons.location_city_outlined),
                                          SizedBox(width: 10,),
                                          Text('${addf['district']}'),
                                        ],
                                      ),

                                  );

                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                   dropDownValue= value;

                                  });
                                },

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
                      ],
                    ),
                  ),
                ),

              actions: [
                TextButton(
                  onPressed: () async{
                    _submit();
                    setState(() {



                    });

                  },
                  child: Text('Send'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: Text('Close'),
                ),
              ],
            ),
          );
        },
      );

    }
     //List<dynamic> patients =[];
    final patients=  operations.instance.Patient_info();



    return Scaffold(
      appBar: AppBar(
        title: const Center(child:  Text('Patient registration'),),
      ),
      body: ListView(
        children: [
          TextButton.icon(onPressed: (){
            showMyDialog();
          }, icon: const Icon(Icons.add), label: const Text('Add Patient',style:
           TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
             color: Colors.blue
          ),
          )
          ),
          SizedBox(height: 20,),
           SingleChildScrollView(
             scrollDirection: Axis.horizontal,
              child: FutureBuilder(
                  future: operations.instance.Patient_info(),
                  builder: (context, snapshot){
                    if(snapshot.hasData){
                      List<dynamic> data =snapshot.data!;

                      return SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Card(

                          child: DataTable(
                            columnSpacing: (MediaQuery.of(context).size.width / 10) * 0.5,
                            dataRowHeight: 80,
                            columns:  const <DataColumn>[

                              DataColumn(
                                label: Text(
                                  'ID',
                                  style: TextStyle(fontStyle: FontStyle.italic),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Name',
                                  style: TextStyle(fontStyle: FontStyle.italic),
                                ),

                              ),
                              DataColumn(
                                label: Text(
                                  'Tell',
                                  style: TextStyle(fontStyle: FontStyle.italic),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'sex',
                                  style: TextStyle(fontStyle: FontStyle.italic),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Email',
                                  style: TextStyle(fontStyle: FontStyle.italic),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'password',
                                  style: TextStyle(fontStyle: FontStyle.italic),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'address',
                                  style: TextStyle(fontStyle: FontStyle.italic),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Birth_date',
                                  style: TextStyle(fontStyle: FontStyle.italic),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'reg_date',
                                  style: TextStyle(fontStyle: FontStyle.italic),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Action',
                                  style: TextStyle(fontStyle: FontStyle.italic),
                                ),
                              ),
                            ],
                            rows: data
                                .map((patient) => DataRow(
                              cells: <DataCell>[
                                DataCell(Text(patient['p_no'].toString())),
                                DataCell(Text(patient['name'].toString())),
                                DataCell(Text(patient['tell'].toString())),
                                DataCell(Text(patient['sex'].toString())),
                                DataCell(Text(patient['email'].toString())),
                                DataCell(Text(patient['password'].toString())),
                                DataCell(Text(patient['add_no'].toString())),
                                DataCell(Text(patient['birth_date'].toString())),
                                DataCell(Text(patient['reg_date'].toString())),
                                DataCell(Row(children: [
                                  IconButton(onPressed: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context)=> Update_record_screen(
                                      id: patient['p_no'].toString(),
                                      name: patient['name'].toString(),
                                      tell: patient['tell'].toString(),
                                      sex: patient['sex'].toString(),
                                      gmail: patient['email'].toString(),
                                      password: patient['password'].toString(),
                                      address: patient['add_no'].toString(),
                                      birth_date: patient['birth_date'],
                                    )));
                                  },icon:
                                  Icon(Icons.edit),color: Colors.blue,

                                  ),
                          SizedBox(width: 5,),
                          IconButton(onPressed: (){
                            delete_record(patient['p_no']);
                          },icon: Icon(Icons.delete),color: Colors.red,

                          ),

                                ],)),

                              ],
                            ))
                                .toList(),



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

          )
        ],
      ),
    );
  }
}
