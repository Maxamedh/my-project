
import 'package:flutter/material.dart';
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
    operations.instance.fetchPayment();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {


    final List<Map<String, dynamic>> data  =[];


    return Scaffold(
      appBar: AppBar(
        title: const Center(child:  Text('payment Information'),),
      ),
      body: ListView(
        children: [
          // TextButton.icon(onPressed: (){
          //
          // }, icon: const Icon(Icons.add), label: const Text('Add schedule',style:
          // TextStyle(
          //     fontWeight: FontWeight.bold,
          //     fontSize: 16,
          //     color: Colors.blue
          // ),
          // )
          // ),
          SizedBox(height: 20,),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: FutureBuilder(
                future: operations.instance.fetchPayment(),
                builder: (context, snapshot){
                  if(snapshot.hasData){
                    List<dynamic> data =snapshot.data!;

                    return SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Card(

                        child:  DataTable(
                          columnSpacing: (MediaQuery.of(context).size.width / 10) * 0.5,
                          dataRowHeight: 80,
                          columns: const <DataColumn> [

                            DataColumn(
                              label: Text(
                                'ID',
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
                                'Staff Name',
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
                                'Payment datetime',
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
                              .map((patient) => DataRow(
                            cells: <DataCell>[
                              DataCell(Text(patient['pay_no'].toString())),
                              DataCell(Text(patient['accoun'].toString())),
                              DataCell(Text(patient['staff_name'].toString())),
                              DataCell(Text(patient['amount'].toString())),
                              DataCell(Text(patient['pay_datetime'].toString())),
                              DataCell(Text(patient['description'].toString())),
                              DataCell(Row(children: [
                                IconButton(onPressed: (){
                                  //Navigator.push(context, MaterialPageRoute(builder: (context)=>Update_record_screen()));
                                },icon:
                                Icon(Icons.edit),color: Colors.blue,

                                ),
                                SizedBox(width: 5,),
                                IconButton(onPressed: (){
                                  // delete_record(patient['p_no']);
                                },icon: Icon(Icons.delete),color: Colors.red,

                                ),
                                SizedBox(width: 5,),
                                IconButton(onPressed: (){
                                  // delete_record(patient['p_no']);
                                },icon: Icon(Icons.payment),color: Colors.red,

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
