import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hospital/lab/retrive_labtests.dart';
import 'package:hospital/screens/tabs.dart';

import '../ApointmentScreen.dart';
import 'Drawer.dart';

var patient_Dashbord = ['PRESCRIPTION', 'BOOK APPOINTMENT', 'CHECKMENT RESULT', 'MY DOCTOR', 'PAYMENT', 'INVOICE'];

final List<IconData> icons = [
  Icons.medical_services,
  Icons.book,
  Icons.check,
  Icons.accessibility_new,
  Icons.payments_rounded,
  Icons.receipt,
];

class PatientDashbord extends StatefulWidget {
  const PatientDashbord({Key? key, required this.email});

  final email;

  @override
  State<PatientDashbord> createState() => _PatientDashbordState();
}

class _PatientDashbordState extends State<PatientDashbord> {
  late Future<List> patient;
  String pname = '';
  String email = '';
  String password = '';
  String tell = '';
   String patient_no='';

  @override
  void initState() {
    super.initState();
    patient = operationsLab.instance.fetch_Data("SELECT * FROM patient_table WHERE email='${widget.email}'");
    patient.then((value) {
      setState(() {
        pname = value.isNotEmpty ? value[0]['name'] : '';
        email = value.isNotEmpty ? value[0]['email'] : '';
        tell = value.isNotEmpty ? value[0]['tell'] : '';
        password = value.isNotEmpty ? value[0]['password'] : '';
        patient_no = value.isNotEmpty ? value[0]['p_no'] : '';
        print(patient_no);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: patient,
      builder: (context, AsyncSnapshot<List> snapshot) {
        return Scaffold(
          drawer: DrawerWidget(pname: pname,email: email,tell: tell,password: password,),
          appBar: AppBar(
            backgroundColor: Colors.green,
            title: Center(
              child: Text('${pname} Dashboard',style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.white
              ),),
            ),
          ),
          body: Center(
            child: Column(

              children: [
                SizedBox(height: 16,),
                Container(
                  width: double.infinity,
                  height: 200,
                  color: Colors.blue,
                  child: Center(
                    child: Text(
                      'HOSPITAL SYSTEM',
                      style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                SizedBox(height: 10,),
                Text('SECTIONS OF MANAGEMENT', style: TextStyle(color: Colors.blue, fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(height: 10,),
                Container(
                  width: double.infinity,
                  height: 450,
                  child: Card(
                    margin: EdgeInsets.all(10),
                    color: Colors.white,
                    elevation: 10,
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 0.7,
                        ),
                        itemCount: patient_Dashbord.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            color: Colors.blue,
                            child: SizedBox(
                              height: 50,
                              width: 200,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        if (index == 0) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) =>  TabsScreen(patient_id: patient_no,patient_name: pname,)),
                                          );
                                        } else if (index == 1) {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) =>  appontmentScreen(patient_id: patient_no,)),
                                          );
                                        } else if (index == 2) {
                                          // Navigator.push(
                                          //   context,
                                          //   //MaterialPageRoute(builder: (context) => const WorkScreen()),
                                          // );
                                        } else if (index == 3) {
                                          // Navigator.push(
                                          //   context,
                                          //   //MaterialPageRoute(builder: (context) => const PaymentScreen()),
                                          // );
                                        }
                                      },
                                      icon: Icon(icons[index], size: 100, color: Colors.white),
                                    ),
                                    Text(
                                      patient_Dashbord[index],
                                      style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
