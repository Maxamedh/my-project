
import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:hospital/lab/lab_result_register.dart';
import 'package:hospital/lab/lab_result_update.dart';

import 'package:hospital/lab/retrive_labtests.dart';

import 'package:http/http.dart' as http;
class LabResulttestScreen extends StatefulWidget {
  const LabResulttestScreen({super.key});

  @override
  State<LabResulttestScreen> createState() => _LabResulttestScreenState();
}
class _LabResulttestScreenState extends State<LabResulttestScreen> {
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
          'table':'lab_results',
          'id':id,
          'deleted_id':'result_id',
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
        title: const Center(child:  Text('Result Information'),),
      ),
      body: ListView(
        children: [
          TextButton.icon(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>Insert_Result_record_screen()));
          }, icon: const Icon(Icons.add), label: const Text('Add Result',style:
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
                future: operationsLab.instance.fetch_Data('SELECT result_id, ds_name, test_name, result, date_result_received FROM deseases,lab_samples,lab_tests,lab_results where deseases.ds_no=lab_results.ds_no '
                    'and lab_tests.test_id=lab_samples.test_no and lab_samples.sample_id=lab_results.sample_id'),
                builder: (context, snapshot){
                  if(snapshot.hasData){
                    List<dynamic> data =snapshot.data!;

                    return SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Card(

                        child:  DataTable(
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
                                'Disease Name',
                                style: TextStyle(fontStyle: FontStyle.italic),
                              ),

                            ),
                            DataColumn(
                              label: Text(
                                'Test',
                                style: TextStyle(fontStyle: FontStyle.italic),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Result',
                                style: TextStyle(fontStyle: FontStyle.italic),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Date Received',
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
                              .map((result) => DataRow(
                            cells: <DataCell>[
                              DataCell(Text(result['result_id'].toString())),
                              DataCell(Text(result['ds_name'].toString())),
                              DataCell(Text(result['test_name'].toString())),
                              DataCell(Text(result['result'].toString())),
                              DataCell(Text(result['date_result_received'].toString())),
                              DataCell(Row(children: [
                                IconButton(onPressed: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>
                                      Update_Result_record_screen(
                                          result_id: result['result_id'].toString(), ds_no: result['ds_name'].toString(),
                                          sample_no: result['test_name'].toString(), result: result['result'].toString(),
                                          datereceived: result['date_result_received'].toString()

                                      )
                                  )
                                  );
                                },icon:
                                Icon(Icons.edit),color: Colors.blue,

                                ),
                                SizedBox(width: 5,),
                                IconButton(onPressed: (){
                                  delete_record(result['result_id']);
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
