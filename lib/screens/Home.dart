import 'package:flutter/material.dart';
import 'package:hospital/screens/patients/login.dart';

import 'Admin/login.dart';
import 'Doctors/login.dart';


var list=['Patients','Doctors','Admin'];
class Home extends StatelessWidget {
  const Home({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: new Center(child: new Text('Our Home', textAlign: TextAlign.center)),
      ),
      body: Center(

        child: SingleChildScrollView(
          child: Column(

            children: [
              Container(
                width: 5000,
                height: 200,
                child: Image.asset('assets/adminpicture.jpg'),
              ),
              const SizedBox(height: 16,),
               Row(
                 mainAxisAlignment: MainAxisAlignment.center,
                 children: [
                   Container(
                    width: 130,
                    height: 130,
                    child:   Column(
                      children: [
                        IconButton(onPressed: (){
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context)=>LoginPatientScreen()
                              )
                          );
                        }, icon: Icon(
                            Icons.people,
                          size: 70,color: Colors.blue,
                        )),
                        Text(
                            'Patient'
                        ),
                      ],
                    ),
                             ),
                   const SizedBox(width: 10,),

                   Container(
                     width: 130,
                     height: 130,
                     child:  Column(
                       children: [
                          IconButton(onPressed: (){
                             Navigator.of(context).push(MaterialPageRoute(builder: (context)=>
                                 LoginDoctorScreen()
                             ));
                          },
                              icon: Icon(Icons.people,
                                size: 70,color: Colors.blue,)
                          ),
                         const SizedBox(width: 10,),
                         Text('Doctor'),
                       ],
                     ),
                   ),
                   const SizedBox(width: 10,),
                   Container(
                     width: 130,
                     height: 130,
                     child:  Column(
                       children: [
                         IconButton(onPressed: (){
                           Navigator.of(context).push(MaterialPageRoute(builder: (context)=>
                               const loginAdminScreen()
                           ));
                         },
                             icon: Icon(Icons.people,
                               size: 70,color: Colors.blue,)
                         ),
                         const SizedBox(width: 10,),
                         Text('Admin'),
                       ],
                     ),
                   ),
                 ],
               ),
              Container(
                width: 200,
                height: 250,
                child:  Column(
                  children: [
                    Image.asset('assets/moreinfo.jpg'),
                     const SizedBox(height: 10,),
                    Text('Admin'),
                  ],
                ),
              )
            ],
          ),
        ),
      )
    );
  }
}
