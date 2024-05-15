import 'package:flutter/material.dart';

var especialist = ['dactorkamandhecerada','Indhaha','caloosha','qaliin','cumuliso','ddjjd,','jfjhfh'];
class Appointment extends StatelessWidget {
  const Appointment({super.key});

  @override
  Widget build(BuildContext context) {

    return ListView(

      children:[
        Column(
          children: [
            Row(
              children: [

                    for(var speciali in especialist)
                      Expanded(
                        child: Card(
                          elevation: 50,
                          shadowColor: Colors.black,
                          color: Colors.greenAccent[100],

                          child: SizedBox(
                              width: 300,
                              height: 100,
                              child: Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Text(speciali)
                              )
                          ), //SizedBox
                        ),
                      ),

              ],
            ),
          ],
        ),

    ]
    );
  }
}
