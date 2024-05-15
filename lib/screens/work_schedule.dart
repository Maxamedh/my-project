import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:hospital/models/patient_model.dart';
import 'package:hospital/screens/insert_staff_chedule.dart';
import 'package:hospital/screens/update_staff_schedule.dart';

class WorkScreen extends StatefulWidget {
  const WorkScreen({super.key});

  @override
  State<WorkScreen> createState() => _WorkScreenState();
}
class _WorkScreenState extends State<WorkScreen> {
  final _form = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    operations.instance.fetchScedule();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Future<void> delete_record(var id) async{
      final response = await http.post(Uri.parse('http://192.168.43.239/hospital_api/All/delete.php'),
        body: {
          'table':'work_schedule',
          'id':id,
          'deleted_id':'work_sche_no',
        },
      );

      if(response.statusCode==200){

        Map<String,dynamic> data =json.decode(response.body);
        setState(() {
          if(data['success']){
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Data deleted successfully')));
            operations.instance.fetchScedule()
            ;


          }else{
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to delete data ${response.body}')));
          }
        });
      }
    }

    final List<Map<String, dynamic>> data  =[];


    return Scaffold(
      appBar: AppBar(
        title: const Center(child:  Text('Work schedule Information'),),
      ),
      body: ListView(
        children: [
          TextButton.icon(onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>Insert_staff_sch_record_screen()));
          }, icon: const Icon(Icons.add), label: const Text('Add schedule',style:
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
                future: operations.instance.fetchScedule(),
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
                                'Staff Name',
                                style: TextStyle(fontStyle: FontStyle.italic),
                              ),

                            ),
                            DataColumn(
                              label: Text(
                                'Work days',
                                style: TextStyle(fontStyle: FontStyle.italic),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Start Time',
                                style: TextStyle(fontStyle: FontStyle.italic),
                              ),
                            ),

                            DataColumn(
                              label: Text(
                                'End Time',
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
                              .map((worksch) => DataRow(
                            cells: <DataCell>[
                              DataCell(Text(worksch['work_sche_no'].toString())),
                              DataCell(Text(worksch['staff_name'].toString())),
                              DataCell(Text(worksch['work_days'].toString())),
                              DataCell(Text(worksch['start_time'].toString())),
                              DataCell(Text(worksch['end_time'].toString())),
                              DataCell(Row(children: [
                                IconButton(onPressed: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>Update_staff_sch_record_screen(
                                      workscheno: worksch['work_sche_no'].toString(), staffId: worksch['staff_name'].toString(),
                                      workDays: worksch['work_days'].toString(), startTime: worksch['start_time'].toString(),
                                      endTime: worksch['end_time'].toString()
                                  )
                                  ));
                                },icon:
                                Icon(Icons.edit),color: Colors.blue,

                                ),
                                SizedBox(width: 5,),
                                IconButton(onPressed: (){
                                   delete_record(worksch['work_sche_no']);
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
