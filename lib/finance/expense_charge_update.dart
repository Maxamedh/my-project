import 'dart:convert';
import 'package:hospital/finance/Expense_charge.dart';
import 'package:hospital/lab/retrive_labtests.dart';
import 'package:http/http.dart' as http;
import 'package:date_time_picker_widget/date_time_picker_widget.dart';
import 'package:flutter/material.dart';

TextEditingController exp_date =new TextEditingController();
TextEditingController amount =new TextEditingController();
TextEditingController description =new TextEditingController();


class Update_Exp_ch_record_screen extends StatefulWidget {
  const Update_Exp_ch_record_screen({super.key,
    required this.exp_ch_no, required this.exp_no,
    required this.amount, required this.exp_date,
    required this.description
  });

  final String exp_ch_no;
  final String exp_no;
  final String amount;
  final String exp_date;
  final String description;

  @override
  State<Update_Exp_ch_record_screen> createState() => _Update_Exp_ch_record_screenState();
}

class _Update_Exp_ch_record_screenState extends State<Update_Exp_ch_record_screen> {


  @override
  void initState() {
    // TODO: implement initState
    dropDownexpValue=widget.exp_no;
    amount.text=widget.amount;
    exp_date.text=widget.exp_date;
    description.text=widget.description;
    super.initState();
  }
  final _form = GlobalKey<FormState>();
  //final List<Map<String, dynamic>> data  =[];
  final List<Map<String, dynamic>> doctor_data  =[];
  var dropDownexpValue;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        exp_date.text = picked.toString().substring(0,
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
          'table': 'expense_charge',
          'data': {
            'exp_no': dropDownexpValue,
            'amount': amount.text,
            'exp_date': exp_date.text,
            'description': description.text,
          },
          'updated_id':'ex_ch_no',
          'id':widget.exp_ch_no
        };
        try {
          var response = await http.post(Uri.parse('http://192.168.43.239/hospital_api/All/update.php'),
              body: json.encode(data));
          print(response.body);
          setState(() {
            if (response.statusCode == 200) {

              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Data Updated successfully')));

              print("Data Updated successfully");
              Navigator.push(context, MaterialPageRoute(builder: (context)=>Expense_chargeScreen()));
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
                        future: operationsLab.instance.fetch_Data('select * from expenses'),
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
                                    value: exp['ex_no'].toString(),
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

                    TextFormField(
                      controller: exp_date,
                      decoration: InputDecoration(
                        label: Text('Expense Date'),
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
                      controller: description,
                      decoration: const InputDecoration(
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
