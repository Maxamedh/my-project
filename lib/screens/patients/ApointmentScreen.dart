import 'package:flutter/material.dart';
import 'package:hospital/lab/retrive_labtests.dart';
import 'package:hospital/models/doctor_model.dart';
import 'package:hospital/models/patient_model.dart';
import 'package:hospital/models/staff_model.dart';
import 'package:hospital/screens/visits_insertion.dart';

import 'doctors_view_schedule.dart';

class appontmentScreen extends StatefulWidget {

  const appontmentScreen({super.key,required this.patient_id});

  final patient_id;
  @override
  _appontmentScreenState createState() => _appontmentScreenState();
}

class _appontmentScreenState extends State<appontmentScreen> {
  TextEditingController _searchController = TextEditingController();
  String _searchText = '';
  List<Map<String, dynamic>> doctors = [];
  Future<void> fetchData() async {
    List<Map<String, dynamic>> data = (await operations.instance.fetchDoctor()).cast<Map<String, dynamic>>();

    setState(() {
      doctors.addAll(data);
    });
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Center(
          child: const Text(
            'Available Doctors',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search by Specialist',
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      _searchText = '';
                    });
                  },
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchText = value;
                });
              },
            ),
          ),
          SizedBox(height: 16,),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 0.7,
              ),
              itemCount: doctors.length,
              itemBuilder: (BuildContext context, int index) {
                // Filter doctors by specialist
                if (_searchText.isNotEmpty &&
                    !(doctors[index]['sp_name'].toString().toLowerCase().contains(_searchText.toLowerCase()))) {
                  return SizedBox(); // Return an empty SizedBox if the doctor does not match the search text
                }

                return GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>DoctorScheduleView(doctor_id:doctors[index]['doctor_no'].toString() ,patient_id: widget.patient_id,)));
                  },
                  child: Card(
                    elevation: 4,
                    margin: EdgeInsets.all(8),
                    child: SingleChildScrollView(

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 90,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('assets/doctor.jpg'), // Your image path here
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  doctors[index]['staff_name'].toString(), // Displaying doctor name
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  doctors[index]['sp_name'].toString(), // Displaying doctor specialization
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
