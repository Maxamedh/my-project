import 'dart:convert';
import 'package:hospital/finance/Expense_payment.dart';
import 'package:hospital/lab/retrive_labtests.dart';

import 'package:http/http.dart' as http;
import 'package:date_time_picker_widget/date_time_picker_widget.dart';
import 'package:flutter/material.dart';

TextEditingController exppay_date =new TextEditingController();
TextEditingController amount =new TextEditingController();


class Update_Exp_pay_record_screen extends StatefulWidget {
  const Update_Exp_pay_record_screen({super.key,
    required this.exp_ch_pay_no,required this.exp_charge,
    required this.amount, required this.account,
    required this.paydate

  });

  final String exp_ch_pay_no;
  final String exp_charge;
  final String amount;
  final String account;
  final String paydate;

  @override
  State<Update_Exp_pay_record_screen> createState() => _Update_Exp_pay_record_screenState();
}

class _Update_Exp_pay_record_screenState extends State<Update_Exp_pay_record_screen> {


  @override
  void initState() {
    // TODO: implement initState
    dropDownexpValue=widget.exp_charge;
    amount.text=widget.amount;
    dropDownaccpValue=widget.account;
    exppay_date.text=widget.paydate;
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
    Future<void> updateData() async {
      final isValid =_form.currentState!.validate();
      if(isValid){
        final data={
          'table': 'expense_payment',
          'data': {
            'exp_charge': dropDownexpValue,
            'amount': amount.text,
            'ac_no': dropDownaccpValue,
            'pay_date': exppay_date.text,
          },
          'updated_id':'ex_pay_no',
          'id':widget.exp_ch_pay_no
        };
        try {
          var response = await http.post(Uri.parse('http://192.168.43.239/hospital_api/All/update.php'),
              body: json.encode(data));
          print(response.body);
          setState(() {
            if (response.statusCode == 200) {

              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Data Updated successfully')));

              print("Data Updated successfully");
              Navigator.push(context, MaterialPageRoute(builder: (context)=>Expense_payScreen()));
            } else {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Data failed response body  ${response.body}')));
              print("Failed to insert data");
              print("Status code: ${response.statusCode}");
              print("Response body: ${response.body}");
            }
          });

        } catch (e) {
          print("There was an error: $e");
        }
      }else{
        print('not valid');
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Add Expense pay'),),
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
          ElevatedButton(onPressed: updateData, child: Text('Update'))

        ],
      ),
    );
  }
}
