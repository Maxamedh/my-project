
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hospital/finance/expense_pay_registe.dart';
import 'package:hospital/finance/payment_insert.dart';
import 'package:hospital/finance/payment_update.dart';
import 'package:hospital/lab/retrive_labtests.dart';
import 'package:http/http.dart' as http;
import 'package:hospital/models/patient_model.dart';
class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}
class _PaymentScreenState extends State<PaymentScreen> {
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
          'table':'payments',
          'id':id,
          'deleted_id':'pay_no',
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
        title: const Center(child:  Text('Payments'),),
      ),
      body: ListView(
        children: [
          TextButton.icon(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>Insert_Payment_record_screen()));
          }, icon: const Icon(Icons.add), label: const Text('Add payment',style:
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
                future: operationsLab.instance.fetch_Data('SELECT * FROM payments pay '
                    'join accounts acc on pay.ac_no=acc.ac_no join staff stf on pay.emp_no=stf.staff_no'),
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
                                'Account Name',
                                style: TextStyle(fontStyle: FontStyle.italic),
                              ),

                            ),
                            DataColumn(
                              label: Text(
                                'Employee',
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
                                'Pay Date',
                                style: TextStyle(fontStyle: FontStyle.italic),
                              ),

                            ),
                            DataColumn(
                              label: Text(
                                'Description',
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
                              .map((payment) => DataRow(
                            cells: <DataCell>[
                              DataCell(Text(payment['pay_no'].toString())),
                              DataCell(Text('${payment['ac_name'].toString()} ${payment['institution'].toString()} ')),
                              DataCell(Text(payment['staff_name'].toString())),
                              DataCell(Text(payment['Amount'].toString())),
                              DataCell(Text(payment['pay_datetime'].toString())),
                              DataCell(Text(payment['description'].toString())),
                              DataCell(Row(children: [
                                IconButton(onPressed: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>
                                     Update_Payment_record_screen(
                                         pay_no: payment['pay_no'].toString(), ac_no: payment['ac_name'].toString(), emp_no:
                                     payment['staff_name'].toString(), amount: payment['Amount'].toString(), paydate: payment['pay_datetime'].toString(),
                                         description: payment['description'].toString())
                                  ));
                                },icon:
                                Icon(Icons.edit),color: Colors.blue,

                                ),
                                SizedBox(width: 5,),
                                IconButton(onPressed: (){
                                  delete_record(payment['pay_no']);
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
