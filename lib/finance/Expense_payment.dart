
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hospital/finance/exp_pay_update.dart';
import 'package:hospital/finance/expense_charge_insert.dart';
import 'package:hospital/finance/expense_pay_registe.dart';
import 'package:hospital/lab/retrive_labtests.dart';
import 'package:http/http.dart' as http;
import 'package:hospital/models/patient_model.dart';
class Expense_payScreen extends StatefulWidget {
  const Expense_payScreen({super.key});

  @override
  State<Expense_payScreen> createState() => _Expense_payScreenState();
}
class _Expense_payScreenState extends State<Expense_payScreen> {
  final _form = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    Future<void> delete_record(var id) async{
      final response = await http.post(Uri.parse('http://192.168.43.239/hospital_api/All/delete.php'),
        body: {
          'table':'expense_payment',
          'id':id,
          'deleted_id':'ex_pay_no',
        },
      );

      if(response.statusCode==200){

        Map<String,dynamic> data =json.decode(response.body);
        setState(() {
          if(data['success']){
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Data deleted successfully')));
          }else{
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to delete data ${response.body}')));
          }
        });
      }
    }


    final List<Map<String, dynamic>> data  =[];

    int i=0;
    return Scaffold(
      appBar: AppBar(
        title: const Center(child:  Text('Expense Charges'),),
      ),
      body: ListView(
        children: [
          TextButton.icon(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>Insert_Exp_pay_record_screen()));
          }, icon: const Icon(Icons.add), label: const Text('Add Expense payment',style:
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
                future: operationsLab.instance.fetch_Data('SELECT ex_pay_no, exp_name, expense_payment.amount,ac_name, pay_date FROM expense_charge, expense_payment,accounts,expenses WHERE expenses.ex_no=expense_charge.exp_no and expense_charge.ex_ch_no=expense_payment.exp_charge and accounts.ac_no=expense_payment.ac_no'),
                builder: (context, snapshot){
                  if(snapshot.hasData){
                    List<dynamic> data =snapshot.data!;

                    return SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Card(

                        child: DataTable(
                          columnSpacing: (MediaQuery.of(context).size.width / 10) * 1.5,
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
                                'Expense Name',
                                style: TextStyle(fontStyle: FontStyle.italic),
                              ),

                            ),
                            DataColumn(
                              label: Text(
                                'Amount',
                                style: TextStyle(fontStyle: FontStyle.italic),
                              ),

                            ),
                            DataColumn(
                              label: Text(
                                'Account',
                                style: TextStyle(fontStyle: FontStyle.italic),
                              ),

                            ),
                            DataColumn(
                              label: Text(
                                'Pay Date',
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
                              .map((exppay) => DataRow(
                            cells: <DataCell>[
                              DataCell(Text(exppay['ex_pay_no'].toString())),
                              DataCell(Text(exppay['exp_name'].toString())),
                              DataCell(Text(exppay['amount'].toString())),
                              DataCell(Text(exppay['ac_name'].toString())),
                              DataCell(Text(exppay['pay_date'].toString())),
                              DataCell(Row(children: [
                                IconButton(onPressed: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>
                                      Update_Exp_pay_record_screen(
                                          exp_ch_pay_no: exppay['ex_pay_no'].toString(),
                                          exp_charge: exppay['exp_name'].toString(), amount: exppay['amount'].toString(),
                                          account: exppay['ac_name'].toString(), paydate: exppay['pay_date'].toString())
                                  ));
                                },icon:
                                Icon(Icons.edit),color: Colors.blue,

                                ),
                                SizedBox(width: 5,),
                                IconButton(onPressed: (){
                                  delete_record(exppay['ex_pay_no']);
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
