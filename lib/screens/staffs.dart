
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hospital/models/staff_model.dart';
import 'package:http/http.dart' as http;
import 'package:hospital/models/patient_model.dart';
import 'package:hospital/screens/staff_register.dart';
import 'package:hospital/screens/update_staff.dart';

class StaffScreen extends StatefulWidget {
  const StaffScreen({super.key});

  @override
  State<StaffScreen> createState() => _StaffScreenState();
}
class _StaffScreenState extends State<StaffScreen> {
  final _form = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    operations.instance.fetchStaff();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    Future<void> delete_record(var id) async{
      final response = await http.post(Uri.parse('http://192.168.43.239/hospital_api/staff_oper/delete_staff.php'),
        body: {
          'id':id,
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
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to delete data')));
          }
        });
      }
    }
    final List<Map<String, dynamic>> data  =[];


    return Scaffold(
      appBar: AppBar(
        title: const Center(child:  Text('Staff Information'),),
      ),
      body: ListView(
        children: [
          TextButton.icon(onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>Insert_Staff_screen()));
          }, icon: const Icon(Icons.add), label: const Text('Add Staff',style:
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
                future: operations.instance.fetchStaff(),
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
                                'Job Name',
                                style: TextStyle(fontStyle: FontStyle.italic),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'staff tell',
                                style: TextStyle(fontStyle: FontStyle.italic),
                              ),
                            ), DataColumn(
                              label: Text(
                                'Email',
                                style: TextStyle(fontStyle: FontStyle.italic),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'address',
                                style: TextStyle(fontStyle: FontStyle.italic),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'staff sex',
                                style: TextStyle(fontStyle: FontStyle.italic),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'reg date',
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
                              .map((staff) => DataRow(
                            cells: <DataCell>[
                              DataCell(Text(staff['staff_no'].toString())),
                              DataCell(Text(staff['staff_name'].toString())),
                              DataCell(Text(staff['Job_name'].toString())),
                              DataCell(Text(staff['staff_tell'].toString())),
                              DataCell(Text(staff['gmail'].toString())),
                              DataCell(Text(staff['address'].toString())),
                              DataCell(Text(staff['staff_sex'].toString())),
                              DataCell(Text(staff['reg_date'].toString())),
                              DataCell(Row(children: [
                                IconButton(onPressed: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>Update_Staff_screen(
                                      staffNo: staff['staff_no'].toString(), staffName:staff['staff_name'].toString(), job: staff['Job_name'].toString(),
                                      tell: staff['staff_tell'].toString(),gmail: staff['gmail'].toString(), address: staff['address'].toString(), sex: staff['staff_sex'].toString())
                                  ));
                                },icon:
                                Icon(Icons.edit),color: Colors.blue,

                                ),
                                SizedBox(width: 5,),
                                IconButton(onPressed: (){
                                   delete_record(staff['staff_no']);
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
