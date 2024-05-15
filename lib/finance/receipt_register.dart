import 'dart:convert';
import 'dart:io';
import 'package:hospital/finance/Expense_payment.dart';
import 'package:hospital/finance/Payments.dart';
import 'package:hospital/finance/receipts.dart';
import 'package:hospital/lab/retrive_labtests.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

TextEditingController rec_date =new TextEditingController();
TextEditingController amount =new TextEditingController();
TextEditingController discount =new TextEditingController();
TextEditingController description =new TextEditingController();


class Insert_Receipt_record_screen extends StatefulWidget {
  const Insert_Receipt_record_screen({super.key});

  @override
  State<Insert_Receipt_record_screen> createState() => _Insert_Receipt_record_screenState();
}

class _Insert_Receipt_record_screenState extends State<Insert_Receipt_record_screen> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  final _form = GlobalKey<FormState>();
  //final List<Map<String, dynamic>> data  =[];
  final List<Map<String, dynamic>> doctor_data  =[];
  var dropDownaccValue;
  var dropDownpatValue;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        rec_date.text = picked.toString().substring(0,
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
          'table': 'receipts',
          'data': {
            'p_no': dropDownpatValue,
            'amount': amount.text,
            'rec_date':  rec_date.text,
            'discount':discount.text,
            'description': description.text,
            'ac_no': dropDownaccValue,
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
            Navigator.push(context, MaterialPageRoute(builder: (context)=>ReceiptsScreen()));
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
        title: const Center(child: Text('Add Receipts'),),
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
                        future: operationsLab.instance.fetch_Data('select * from patient_table'),
                        builder: (context, snapshot){
                          if(snapshot.hasData){
                            List<dynamic> patient =snapshot.data!;

                            return SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: DropdownButtonFormField(
                                value: null,
                                icon: const Icon(Icons.keyboard_arrow_down),
                                items: patient.map((pat) {
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
                                    dropDownpatValue=value;
                                    print(dropDownpatValue);
                                  });
                                },
                                decoration: InputDecoration(
                                  hintText: dropDownpatValue ?? 'Select patient',
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

                    TextFormField(
                      controller: rec_date,
                      decoration: InputDecoration(
                        label: Text('Received  Date'),
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
                    TextFormField(
                      controller: discount,
                      decoration: InputDecoration(
                        label: Text('Discount'),
                      ),
                      keyboardType: TextInputType.text,

                      autocorrect: false,
                      validator: (value){
                        if(value==null || value.trim().isEmpty
                        ){
                          return 'Please Enter Discount';
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
                    FutureBuilder(
                        future: operationsLab.instance.fetch_Data('SELECT * FROM accounts'),
                        builder: (context, snapshot){
                          if(snapshot.hasData){
                            List<dynamic> account =snapshot.data!;

                            return SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: DropdownButtonFormField(
                                value: null,
                                icon: const Icon(Icons.keyboard_arrow_down),
                                items: account.map((acc) {
                                  return DropdownMenuItem(
                                    value: acc['ac_no'].toString(),
                                    child: Row(
                                      children: [
                                        Icon(Icons.people),
                                        SizedBox(width: 10,),
                                       Text('${acc['ac_name'].toString()}  ${acc['institution'].toString()} ')
                                      ],
                                    ),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    dropDownaccValue=value;
                                    print(dropDownaccValue);
                                  });
                                },
                                decoration: InputDecoration(
                                  hintText: dropDownaccValue ?? 'Select account',
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
          ElevatedButton(onPressed: insertData, child: Text('Save'))

        ],
      ),
    );
  }
}
