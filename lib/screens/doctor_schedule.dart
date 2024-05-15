
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hospital/models/patient_model.dart';
import 'package:hospital/screens/doctor_availability.dart';
import 'package:http/http.dart' as http;
import 'package:hospital/models/staff_model.dart';
import 'package:hospital/screens/update_doc_chedule.dart';

class DoctorScheduleScreen extends StatefulWidget {
  const DoctorScheduleScreen({super.key});

  @override
  State<DoctorScheduleScreen> createState() => _DoctorScheduleScreenState();
}
class _DoctorScheduleScreenState extends State<DoctorScheduleScreen> {
  final _form = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    operations.instance.fetchdoctor_schedule();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Future<void> delete_record(var id) async{
      final response = await http.post(Uri.parse('http://192.168.43.239/hospital_api/All/delete.php'),
        body: {
        'table':'doctor_availability',
          'id':id,
          'deleted_id':'do_av_no',
        },
      );

      if(response.statusCode==200){

        Map<String,dynamic> data =json.decode(response.body);
        setState(() {
          if(data['success']){
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Data deleted successfully')));
            operations.instance.fetchStaff()
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
        title: const Center(child:  Text('Doctor schedule Information'),),
      ),
      body: ListView(
        children: [
          TextButton.icon(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>Insert_Doctor_av_record_screen()));

          }, icon: const Icon(Icons.add), label: const Text('Add Schedule',style:
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
                future: operations.instance.fetchdoctor_schedule(),
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
                                'Doctor Name',
                                style: TextStyle(fontStyle: FontStyle.italic),
                              ),

                            ),
                            DataColumn(
                              label: Text(
                                'Room',
                                style: TextStyle(fontStyle: FontStyle.italic),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Day of Week',
                                style: TextStyle(fontStyle: FontStyle.italic),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                ' Start Time',
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
                                'Status',
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
                              .map((doctor_av) => DataRow(
                            cells: <DataCell>[
                              DataCell(Text(doctor_av['do_av_no'].toString())),
                              DataCell(Text(doctor_av['staff_name'].toString())),
                              DataCell(Text(doctor_av['Room_name'].toString())),
                              DataCell(Text(doctor_av['day_of_week'].toString())),
                              DataCell(Text(doctor_av['start_time'].toString())),
                              DataCell(Text(doctor_av['end_time'].toString())),
                              DataCell(Text(doctor_av['status'].toString())),
                              DataCell(Row(children: [
                                IconButton(onPressed: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>Update_Doctor_av_record_screen(
                                      doc_av_no: doctor_av['do_av_no'].toString(), Doctor_id: doctor_av['staff_name'].toString(), room_no: doctor_av['Room_name'].toString(),
                                      day_of_week: doctor_av['day_of_week'].toString(), startTime:
                                  doctor_av['start_time'].toString(), endTime: doctor_av['end_time'].toString()
                                  )));
                                },icon:
                                Icon(Icons.edit),color: Colors.blue,

                                ),
                                SizedBox(width: 5,),
                                IconButton(onPressed: (){
                                   delete_record(doctor_av['do_av_no']);
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
