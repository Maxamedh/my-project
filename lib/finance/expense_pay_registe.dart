import 'dart:convert';
import 'dart:io';
import 'package:hospital/finance/Expense_charge.dart';
import 'package:hospital/finance/Expense_payment.dart';
import 'package:hospital/lab/lab_results.dart';
import 'package:hospital/lab/retrive_labtests.dart';
import 'package:hospital/lab/samples.dart';
import 'package:hospital/models/visits_model.dart';
import 'package:hospital/screens/visits.dart';
import 'package:http/http.dart' as http;
import 'package:date_time_picker_widget/date_time_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:hospital/models/patient_model.dart';

TextEditingController exppay_date =new TextEditingController();
TextEditingController amount =new TextEditingController();


class Insert_Exp_pay_record_screen extends StatefulWidget {
  const Insert_Exp_pay_record_screen({super.key});

  @override
  State<Insert_Exp_pay_record_screen> createState() => _Insert_Exp_pay_record_screenState();
}

class _Insert_Exp_pay_record_screenState extends State<Insert_Exp_pay_record_screen> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  final _form = GlobalKey<FormState>();
  //final List<Map<String, dynamic>> data  =[];
  final List<Map<String, dynamic>> doctor_data  =[];
  var dropDownexpValue;
  var dropDownaccpValue;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        exppay_date.text = picked.toString().substring(0,
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
          'table': 'expense_payment',
          'data': {
            'exp_charge': dropDownexpValue,
            'amount': amount.text,
            'ac_no': dropDownaccpValue,
            'pay_date': exppay_date.text,
          }
        };
        try {
          var response = await http.post(Uri.parse('http://192.168.43.239/hospital_api/All/insertion.php'),
              body: json.encode(data));
          print(response.body);
          setState(() {
          });
          if (response.statusCode == 200) {

            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Data inserted successfully')));

            print("Data inserted successfully");
            Navigator.push(context, MaterialPageRoute(builder: (context)=>Expense_payScreen()));
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
                        future: operationsLab.instance.fetch_Data('SELECT ex_ch_no, exp_name from expenses,expense_charge where expenses.ex_no=expense_charge.exp_no'),
                        builder: (context, snapshot){
                          if(snapshot.hasData){
                            List<dynamic> expense =snapshot.data!;

                            return SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: DropdownButtonFormField(
                                value: null,
                                icon: const Icon(Icons.keyboard_arrow_down),
                                items: expense.map((exp) {
                                  return DropdownMenuItem(
                                    value: exp['ex_ch_no'].toString(),
                                    child: Row(
                                      children: [
                                        Icon(Icons.people),
                                        SizedBox(width: 10,),
                                        Text(exp['exp_name'].toString())
                                      ],
                                    ),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    dropDownexpValue=value;
                                    print(dropDownexpValue);
                                  });
                                },
                                decoration: InputDecoration(
                                  hintText: dropDownexpValue != null ? dropDownexpValue: 'Select An Expense', // Hint text based on selected value
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
                      controller: amount,
                      decoration: const InputDecoration(
                        label: Text('Amount'),
                      ),
                      keyboardType: TextInputType.number,

                      autocorrect: false,
                      validator: (value){
                        if(value==null || value.trim().isEmpty
                        ){
                          return 'Please Enter Amount';
                        }
                        return null;
                      },
                    ),
                    FutureBuilder(
                        future: operationsLab.instance.fetch_Data('SELECT * FROM accounts'),
                        builder: (context, snapshot){
                          if(snapshot.hasData){
                            List<dynamic> acc =snapshot.data!;

                            return SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: DropdownButtonFormField(
                                value: null,
                                icon: const Icon(Icons.keyboard_arrow_down),
                                items: acc.map((ac) {
                                  return DropdownMenuItem(
                                    value: ac['ac_no'].toString(),
                                    child: Row(
                                      children: [
                                        Icon(Icons.people),
                                        SizedBox(width: 10,),
                                        Text('${ac['ac_name'].toString()}  ${ac['institution'].toString()} ')
                                      ],
                                    ),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    dropDownaccpValue=value;
                                    print(dropDownaccpValue);
                                  });
                                },
                                decoration: InputDecoration(
                                  hintText: dropDownaccpValue != null ? dropDownaccpValue: 'Select An Account', // Hint text based on selected value
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
                      controller: exppay_date,
                      decoration: InputDecoration(
                        label: Text('Date'),
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
                          return 'Please Enter a Date';
                        }
                        return null;
                      },
                    ),

                  ],
                ),
              ),
            ),

          ),
          ElevatedButton(onPressed: insertData, child: Text('Save'))

        ],
      ),
    );
  }
}
