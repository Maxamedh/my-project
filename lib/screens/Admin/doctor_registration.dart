import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hospital/models/patient_model.dart';
import 'package:hospital/screens/Admin/doctor_register.dart';
import 'package:hospital/screens/update_doctor.dart';

class DoctorRegistrationScreen extends StatefulWidget {
  const DoctorRegistrationScreen({super.key});
  @override
  State<DoctorRegistrationScreen> createState() => _DoctorRegistrationScreenState();
}
class _DoctorRegistrationScreenState extends State<DoctorRegistrationScreen> {
  final _form = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    operations.instance.fetchDoctor();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    Future<void> delete_record(var id) async{
      final response = await http.post(Uri.parse('http://192.168.43.239/hospital_api/doctor_oper/delete_doctor.php'),
        body: {
          'id':id,
        },
      );

      if(response.statusCode==200){
        Map<String,dynamic> data =json.decode(response.body);
        setState(() {
          if(data['success']){
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Data deleted successfully')));
            operations.instance.fetchDoctor();


          }else{
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to delete data')));
          }
        });
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Center(child:  Text('Doctor Information'),),
      ),
      body:  ListView(
        children: [
          TextButton.icon(onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>Insert_doctor_record_screen()));
          }, icon: const Icon(Icons.add), label: const Text('Add Doctor',style:
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
                future: operations.instance.fetchDoctor(),
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
                                'Name',
                                style: TextStyle(fontStyle: FontStyle.italic),
                              ),

                            ),
                            DataColumn(
                              label: Text(
                                'Specialization',
                                style: TextStyle(fontStyle: FontStyle.italic),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Decree',
                                style: TextStyle(fontStyle: FontStyle.italic),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Address',
                                style: TextStyle(fontStyle: FontStyle.italic),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Hired Date',
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
                              .map((doctor) => DataRow(
                            cells: <DataCell>[
                              DataCell(Text(doctor['doctor_no'].toString())),
                              DataCell(Text(doctor['staff_name'].toString())),
                              DataCell(Text(doctor['sp_name'].toString())),
                              DataCell(Text(doctor['dc_name'].toString())),
                              DataCell(Text(doctor['address'].toString())),
                              DataCell(Text(doctor['hired_date'].toString())),
                              DataCell(Row(children: [
                                IconButton(onPressed: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>Update_doctor_record_screen(
                                      doctorNo: doctor['doctor_no'].toString(), doctor_name: doctor['staff_name'].toString(),
                                      specialization: doctor['sp_name'].toString(), decree: doctor['dc_name'].toString()
                                  )));
                                },icon:
                                Icon(Icons.edit),color: Colors.blue,

                                ),
                                SizedBox(width: 5,),
                                IconButton(onPressed: (){
                                   delete_record(doctor['doctor_no']);
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
