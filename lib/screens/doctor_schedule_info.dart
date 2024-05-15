import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DoctorSchedulePage extends StatefulWidget {
  @override
  _DoctorSchedulePageState createState() => _DoctorSchedulePageState();
}

class _DoctorSchedulePageState extends State<DoctorSchedulePage> {
  late List<dynamic> doctorList;
  List<dynamic>? selectedDoctorSchedule; // Make it nullable
  String? selectedDoctorId;

  @override
  void initState() {
    super.initState();
    doctorList = [];
    selectedDoctorId = null;
    fetchDoctorList();
  }

  Future<void> fetchDoctorList() async {
    final response = await http.get(Uri.parse('http://192.168.43.239/hospital_api/doctor_list.php'));
    if (response.statusCode == 200) {
      setState(() {
        doctorList = jsonDecode(response.body);
      });
      print(doctorList);
    } else {
      throw Exception('Failed to load doctor list');
    }
  }

  Future<void> fetchDoctorSchedule(String doctorId) async {
    final response = await http.post(
      Uri.parse('http://192.168.43.239/hospital_api/doctor_schedule_info.php'),
      body: {'id': doctorId},
    );

    print(doctorId);
    print(response.body);
    if (response.statusCode == 200) {
      setState(() {
        selectedDoctorSchedule = jsonDecode(response.body);
        print(selectedDoctorSchedule);
      });
    } else {
      throw Exception('Failed to load doctor schedule');
    }
  }

  List<List<dynamic>> groupSchedulesByDay(List<dynamic> schedules) {
    Map<String, List<dynamic>> groupedSchedules = {};

    for (var schedule in schedules) {
      String dayName = schedule['day_name'];
      if (!groupedSchedules.containsKey(dayName)) {
        groupedSchedules[dayName] = [];
      }
      groupedSchedules[dayName]!.add(schedule);
    }

    return groupedSchedules.values.toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Doctor Schedule'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Select a Doctor:',
                style: TextStyle(fontSize: 18.0),
              ),
              DropdownButton<String>(
                isExpanded: true,
                value: selectedDoctorId,
                onChanged: (value) {
                  setState(() {
                    selectedDoctorId = value;
                    print(value);
                    fetchDoctorSchedule(value!);
                  });
                },
                items: doctorList.map<DropdownMenuItem<String>>((dynamic value) {
                  return DropdownMenuItem<String>(
                    value: value['doctor_no'],
                    child: Text(value['staff_name']),
                  );
                }).toList(),
                hint: Text('Select a Doctor'), // Placeholder
              ),
              SizedBox(height: 20.0),
              if (selectedDoctorSchedule != null && selectedDoctorSchedule!.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DataTable(
                      columnSpacing: 180.0,
                      headingRowColor: MaterialStateColor.resolveWith((states) => Colors.blue),
                      dataRowColor: MaterialStateColor.resolveWith((states) => Colors.white),
                      columns: const [
                        DataColumn(
                          label: Text(
                            'Doctor Name',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Room',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                      rows: [
                        DataRow(cells: [
                          DataCell(
                            Text(
                              '${selectedDoctorSchedule![0]['Doctor_name']}',
                              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                            ),
                          ),
                          DataCell(
                            Text(
                              '${selectedDoctorSchedule![0]['Room_name']}',
                              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ]),
                      ],
                    ),

                    for (var daySchedule in groupSchedulesByDay(selectedDoctorSchedule!))
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DataTable(
                            headingRowColor: MaterialStateColor.resolveWith((states) => Colors.blue),
                            dataRowColor: MaterialStateColor.resolveWith((states) => Colors.white),
                            columns: [
                              DataColumn(
                                label: Center(

                                  child: Text(' ${daySchedule[0]['day_name']}',
                                    style: TextStyle(color: Colors.white),),
                                ),
                              ),
                            ],
                            rows: [

                            ],
                          ),

                          const Text(
                            '',
                            // style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                          ),
                           DataTable(
                            columnSpacing: 180,
                            columns: const [
                              DataColumn(label: Text('Start Time')),
                              DataColumn(label: Text('End Time')),
                            ],
                            rows: daySchedule.map<DataRow>((schedule) {
                              return DataRow(cells: [
                                DataCell(Text('${schedule['start_time']}')),
                                DataCell(Text(' ${schedule['end_time']}')),
                              ]);
                            }).toList(),
                          ),
                        ],
                      ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
