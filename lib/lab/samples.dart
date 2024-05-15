
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hospital/lab/lab_register.dart';
import 'package:hospital/lab/lab_test_update.dart';
import 'package:hospital/lab/retrive_labtests.dart';
import 'package:hospital/lab/sample_register.dart';
import 'package:hospital/lab/sample_update.dart';
import 'package:http/http.dart' as http;
import 'package:hospital/models/patient_model.dart';
class LabSampletestScreen extends StatefulWidget {
  const LabSampletestScreen({super.key});

  @override
  State<LabSampletestScreen> createState() => _LabSampletestScreenState();
}
class _LabSampletestScreenState extends State<LabSampletestScreen> {
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
          'table':'lab_samples',
          'id':id,
          'deleted_id':'sample_id',
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

    int i=0;
    return Scaffold(
      appBar: AppBar(
        title: const Center(child:  Text('Sample Information'),),
      ),
      body: ListView(
        children: [
          TextButton.icon(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>Insert_sample_record_screen()));
          }, icon: const Icon(Icons.add), label: const Text('Add sample',style:
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
                future: operationsLab.instance.fetch_Data('SELECT sample_id, name, staff_name, date_taken, test_name FROM patient_table,staff,doctor,lab_samples,lab_tests WHERE staff.staff_no=doctor.staff_no and doctor.doctor_no=lab_samples.doctor_id and '
                    'patient_table.p_no=lab_samples.patient_id and lab_tests.test_id=lab_samples.test_no '),
                builder: (context, snapshot){
                  if(snapshot.hasData){
                    List<dynamic> data =snapshot.data!;

                    return SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Card(

                        child: DataTable(
                          columnSpacing: (MediaQuery.of(context).size.width / 10) * 0.5,
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
                                'Patient',
                                style: TextStyle(fontStyle: FontStyle.italic),
                              ),

                            ),
                            DataColumn(
                              label: Text(
                                'Doctor',
                                style: TextStyle(fontStyle: FontStyle.italic),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Date',
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
                                'Action',
                                style: TextStyle(fontStyle: FontStyle.italic),
                              ),
                            ),
                          ],
                          rows: data
                              .map((sample) => DataRow(
                            cells: <DataCell>[
                              DataCell(Text(sample['sample_id'].toString())),
                              DataCell(Text(sample['name'].toString())),
                              DataCell(Text(sample['staff_name'].toString())),
                              DataCell(Text(sample['date_taken'].toString())),
                              DataCell(Text(sample['test_name'].toString())),
                              DataCell(Row(children: [
                                IconButton(onPressed: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>
                                     Update_sample_record_screen(
                                         sample_id: sample['sample_id'].toString(), patient_id: sample['name'].toString(),
                                         doctor_id: sample['staff_name'].toString(), DateTaken:
                                     sample['date_taken'].toString(), test_id: sample['test_name'].toString())));
                                },icon:
                                Icon(Icons.edit),color: Colors.blue,

                                ),
                                SizedBox(width: 5,),
                                IconButton(onPressed: (){
                                   delete_record(sample['sample_id']);
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
