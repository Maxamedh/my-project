import 'package:flutter/material.dart';
import 'package:hospital/screens/Admin/finance%20Dashboard.dart';
import 'package:hospital/screens/Admin/labdhashbord.dart';
import 'package:hospital/screens/Admin/patient_management.dart';
import 'package:hospital/screens/Admin/staff_managment.dart';
var list = ['PATIENT MANAGEMENT','STAFF MANAGEMENT','LABORATORY MANAGEMENT','FINANCE','PHARMACY MNANAGEMENT','REPORTS'];
class dashbordScreen extends StatelessWidget {
  const dashbordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Center(child: Text('Admin Dashboard'),),
      ),
      body: Center(
        child: ListView(
          children: [
            Column(
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
                            itemCount: list.length,
                            itemBuilder: (BuildContext context, int index,){
                              return GestureDetector(
                                onTap: () {


                                },
                                child: Card(
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
                                                MaterialPageRoute(builder: (context) => const PatientManagementScreen()),
                                              );
                                            }else if(index==1){
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(builder: (context) => const StaffManagementScreen()),
                                              );
                                            }else if(index==2){
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(builder: (context) => const LabdashbordScreen()),
                                              );
                                            }else if(index==3){
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(builder: (context) => const FinancedashbordScreen()),
                                              );
                                            }

                                          }, icon:const  Icon(
                                            Icons.local_hospital_rounded, size:
                                          100,color: Colors.white,)),
                                          Text(list[index],
                                              style: const TextStyle(color: Colors.white,fontSize: 10,
                                                  fontWeight: FontWeight.bold)
                                          ),
                                        ],
                                      ),
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
          ],
        )
      ),
    );
  }
}
