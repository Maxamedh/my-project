import 'package:flutter/material.dart';
import 'package:hospital/screens/Admin/doctor_registration.dart';
import 'package:hospital/screens/doctor_schedule.dart';
import 'package:hospital/screens/payments.dart';
import 'package:hospital/screens/schedule.dart';
import 'package:hospital/screens/staffs.dart';
import 'package:hospital/screens/work_schedule.dart';
var StaffManagementlist = ['STAFF REGISTRATION','DOCTOR REGISTRATION','SCHEDULING','SALARY PAYMENT','STATEMENT','DOCTOR AVAILABILITY'
    ''];
class StaffManagementScreen extends StatelessWidget {
  const StaffManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child:  Text('Patient Management'),),

      ),
      body: Center(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 200,
              color: Colors.blue,
              child:Center(
                child: Text('HOSPITAL SYSTEM',
                  style: TextStyle(color: Colors.white,fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(height: 10,),
            Text('SECTIONS OF MANAGEMENT',
                style: TextStyle(color: Colors.blue,fontSize: 20,
                    fontWeight: FontWeight.bold)
            ),
            SizedBox(height: 10,),
            Container(
              width: double.infinity,
              height: 400,
              child:   Card(
                margin: EdgeInsets.all(10),
                color: Colors.white,
                elevation: CircularProgressIndicator.strokeAlignCenter,

                child: Padding(

                    padding: EdgeInsets.all(10),
                    child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount:2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 0.7
                        ),
                        itemCount: StaffManagementlist.length,
                        itemBuilder: (BuildContext context, int index,){
                          return Card(
                            color: Colors.blue,
                            child: SizedBox(
                              height: 50,
                              width: 200,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(onPressed: (){
                                      if(index==0){
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => const StaffScreen()),
                                        );
                                      }else if(index==1){
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => const DoctorRegistrationScreen()),
                                        );
                                      }else if(index==2){
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => const WorkScreen()),
                                        );
                                      }else if(index==3){
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => const PaymentScreen()),
                                        );
                                      }else if(index==5){
                                        const SizedBox(height: 16,
                                          width: 16,
                                          child: CircularProgressIndicator(),);
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) =>  Doctor_schedule_screen()),
                                        );
                                      }

                                    }, icon: Icon(Icons.local_hospital_rounded, size: 100,color: Colors.white,)),
                                    Text(StaffManagementlist[index],
                                        style: TextStyle(color: Colors.white,fontSize: 10,
                                            fontWeight: FontWeight.bold)
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );


                        }
                    )
                ),

              ),
            ),

          ],
        ),
      ),
    );
  }
}
