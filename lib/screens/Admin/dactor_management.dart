import 'package:flutter/material.dart';
import 'package:hospital/screens/Admin/doctor_registration.dart';

var DoctorManagementlist = ['DOCTOR REGISTRATION','scheduling','SALARY PAYMENT','STATEMENT'];
class DoctorManagementScreen extends StatelessWidget {
  const DoctorManagementScreen({super.key});

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
                        itemCount: DoctorManagementlist.length,
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
                                          MaterialPageRoute(builder: (context) => const DoctorRegistrationScreen()),
                                        );
                                      }else if(index==1){
                                        // Navigator.push(
                                        //   context,
                                        //   MaterialPageRoute(builder: (context) => const DoctorManagementScreen()),
                                        // );
                                      }

                                    }, icon: Icon(Icons.local_hospital_rounded, size: 100,color: Colors.white,)),
                                    Text(DoctorManagementlist[index],
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
