
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hospital/finance/expense_pay_registe.dart';
import 'package:hospital/finance/receipt_update.dart';
import 'package:hospital/lab/retrive_labtests.dart';
import 'package:http/http.dart' as http;
import 'package:hospital/models/patient_model.dart';
class ReceiptsScreen extends StatefulWidget {
  const ReceiptsScreen({super.key});

  @override
  State<ReceiptsScreen> createState() => _ReceiptsScreenState();
}
class _ReceiptsScreenState extends State<ReceiptsScreen> {
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
          'table':'receipts',
          'id':id,
          'deleted_id':'rc_no',
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
        title: const Center(child:  Text('Receipts'),),
      ),
      body: ListView(
        children: [
          TextButton.icon(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>Insert_Exp_pay_record_screen()));
          }, icon: const Icon(Icons.add), label: const Text('Add Receipt',style:
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
                future: operationsLab.instance.fetch_Data('SELECT * FROM receipts rec join patient_table pt'
                    ' on rec.p_no=pt.p_no join accounts ac on rec.ac_no=ac.ac_no'),
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
                                'Patient',
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
                                'Received Date',
                                style: TextStyle(fontStyle: FontStyle.italic),
                              ),

                            ),
                            DataColumn(
                              label: Text(
                                'Discount',
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
                                'Account',
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
                              .map((receipt) => DataRow(
                            cells: <DataCell>[
                              DataCell(Text(receipt['rc_no'].toString())),
                              DataCell(Text(receipt['name'].toString())),
                              DataCell(Text(receipt['amount'].toString())),
                              DataCell(Text(receipt['rec_date'].toString())),
                              DataCell(Text(receipt['discount'].toString())),
                              DataCell(Text(receipt['description'].toString())),
                              DataCell(Text('${receipt['ac_name'].toString()} ${receipt['institution'].toString()} ')),
                              DataCell(Row(children: [
                                IconButton(onPressed: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>
                                     Update_Receipt_record_screen(
                                         rc_no: receipt['rc_no'].toString(), p_no: receipt['p_no'].toString(),
                                         amount: receipt['amount'].toString(), rec_date: receipt['rec_date'].toString(),
                                         discount: receipt['discount'].toString(), description:
                                     receipt['description'].toString(), account: receipt['ac_no'].toString())
                                  ));
                                },icon:
                                Icon(Icons.edit),color: Colors.blue,

                                ),
                                SizedBox(width: 5,),
                                IconButton(onPressed: (){
                                  delete_record(receipt['rc_no']);
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
