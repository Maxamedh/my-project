
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hospital/finance/expense_register.dart';
import 'package:hospital/finance/expense_update.dart';
import 'package:hospital/lab/lab_register.dart';
import 'package:hospital/lab/lab_test_update.dart';
import 'package:hospital/lab/retrive_labtests.dart';
import 'package:http/http.dart' as http;
import 'package:hospital/models/patient_model.dart';
class ExpenseScreen extends StatefulWidget {
  const ExpenseScreen({super.key});

  @override
  State<ExpenseScreen> createState() => _ExpenseScreenState();
}
class _ExpenseScreenState extends State<ExpenseScreen> {
  final _form = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    operationsLab.instance.fetch_Data('SELECT * FROM expenses');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    Future<void> delete_record(var id) async{
      final response = await http.post(Uri.parse('http://192.168.43.239/hospital_api/All/delete.php'),
        body: {
          'table':'expenses',
          'id':id,
          'deleted_id':'ex_no',
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
        title: const Center(child:  Text('Expenses'),),
      ),
      body: ListView(
        children: [
          TextButton.icon(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>Insert_Expense_record_screen()));
          }, icon: const Icon(Icons.add), label: const Text('Add Expense',style:
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
                future: operationsLab.instance.fetch_Data('SELECT * FROM expenses'),
                builder: (context, snapshot){
                  if(snapshot.hasData){
                    List<dynamic> data =snapshot.data!;

                    return SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Card(

                        child: DataTable(
                          columnSpacing: (MediaQuery.of(context).size.width / 10) * 1.5,
                          dataRowHeight: 80,
                          columns:  <DataColumn>[

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
                                'Action',
                                style: TextStyle(fontStyle: FontStyle.italic),
                              ),
                            ),
                          ],
                          rows: data
                              .map((exp) => DataRow(
                            cells: <DataCell>[
                              DataCell(Text(exp['ex_no'].toString())),
                              DataCell(Text(exp['exp_name'].toString())),
                              DataCell(Row(children: [
                                IconButton(onPressed: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>
                                      Update_Expense_record_screen(exp_id: exp['ex_no'].toString(),
                                          expense_name: exp['exp_name'].toString())
                                  ));
                                },icon:
                                Icon(Icons.edit),color: Colors.blue,

                                ),
                                SizedBox(width: 5,),
                                IconButton(onPressed: (){
                                  delete_record(exp['ex_no']);
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
