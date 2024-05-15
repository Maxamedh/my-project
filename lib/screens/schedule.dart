import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hospital/screens/doctor_schedule_info.dart';
import 'package:http/http.dart' as http;
import 'package:hospital/models/patient_model.dart';
import 'package:hospital/lab/retrive_labtests.dart';

class Doctor_schedule_screen extends StatefulWidget {
  @override
  _Doctor_schedule_screen createState() => _Doctor_schedule_screen();
}

class _Doctor_schedule_screen extends State<Doctor_schedule_screen> {
  // late TextEditingController _startTimeController;
  // late TextEditingController _endTimeController;
  List<Map<String, dynamic>> slotRows = [];
  List<dynamic> doctorList = [];
  List<dynamic> roomList = [];
  List<dynamic> dayList = [];
  String? selectedDoctor;
  String? selectedRoom;

  Future<List> reference = operations.instance.fetchDoctor();
  Future<List> rooms = operationsLab.instance.fetch_Data('select *from rooms');
  Future<List> days = operationsLab.instance.fetch_Data('select *from days');

  @override
  void initState() {
    super.initState();
    // _startTimeController = TextEditingController();
    // _endTimeController = TextEditingController();
    // Fetch doctor list
    reference.then((value) {
      setState(() {
        doctorList.addAll(value);
      });
    });
    rooms.then((value) {
      setState(() {
        roomList.addAll(value);
      });
    });
    days.then((value) {
      setState(() {
        dayList.addAll(value);
      });
    });
  }

  Future<void> _selectTime(BuildContext context, int dayIndex, int slotIndex, bool isStartTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        if (isStartTime) {
          slotRows[dayIndex]['slots'][slotIndex]['startTime'] = '${picked.hour}:${picked.minute}';
          '${picked.hour}:${picked.minute}';
        } else {
          slotRows[dayIndex]['slots'][slotIndex]['endTime'] = '${picked.hour}:${picked.minute}';
         '${picked.hour}:${picked.minute}';
        }
      });
    }
  }

  void addSlotRow() {
    setState(() {
      slotRows.add({
        'selectedDay': null,
        'slots': [
          {'startTime': '', 'endTime': ''}
        ]
      });
    });
  }

  void removeSlotRow(int index) {
    setState(() {
      slotRows.removeAt(index);
    });
  }

  void addSlotForDay(int index) {
    setState(() {
      slotRows[index]['slots'].add({'startTime': '', 'endTime': ''});
    });
  }

  void removeSlotForDay(int dayIndex, int slotIndex) {
    setState(() {
      if (slotRows[dayIndex]['slots'].length > 1) {
        slotRows[dayIndex]['slots'].removeAt(slotIndex);
      }
    });
  }

  Future<void> submitForm() async {
    List<Map<String, dynamic>> slotsData = [];
    for (var slot in slotRows) {
      for (var daySlot in slot['slots']) {
        slotsData.add({
          'doctor_id': selectedDoctor,
          'room_no': selectedRoom,
          'day_of_week': slot['selectedDay'],
          'start_time': daySlot['startTime'],
          'end_time': daySlot['endTime'],
        });
      }
    }

    final response = await http.post(Uri.parse('http://192.168.43.239/hospital_api/doctor_schedle.php'), body: {
      'slots': jsonEncode(slotsData),
    });
    print(slotsData);
    print(response.body);

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Data inserted Successfully')));
      print('Data inserted successfully');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to insert data: ${response.body}')));
      print('Failed to insert data: ${response.body}');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Doctor Scheduling'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ElevatedButton(onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>DoctorSchedulePage()));
              }, child: Text('View Schedule')),
              Text(
                'Doctor Name',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10.0),
              DropdownButton<String>(
                isExpanded: true,
                value: selectedDoctor,
                onChanged: (value) {
                  setState(() {
                    selectedDoctor = value;
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
              DropdownButton<String>(
                isExpanded: true,
                value: selectedRoom,
                onChanged: (value) {
                  setState(() {
                    selectedRoom = value;
                  });
                },
                items: roomList.map<DropdownMenuItem<String>>((dynamic value) {
                  return DropdownMenuItem<String>(
                    value: value['R_no'],
                    child: Text(value['Room_name']),
                  );
                }).toList(),
                hint: Text('Select a Room'),
              ),
              SizedBox(height: 20.0),
              Text(
                'Days',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              SizedBox(height: 20.0),
              for (var i = 0; i < slotRows.length; i++)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DropdownButton<String>(
                      isExpanded: true,
                      value: slotRows[i]['selectedDay'],
                      onChanged: (value) {
                        setState(() {
                          slotRows[i]['selectedDay'] = value;
                        });
                      },
                      items: dayList.map<DropdownMenuItem<String>>((dynamic value) {
                        return DropdownMenuItem<String>(
                          value: value['day_id'],
                          child: Text(value['day_name']),
                        );
                      }).toList(),
                      hint: Text('Select a Day'), // Placeholder
                    ),
                    SizedBox(height: 20.0),
                    for (var j = 0; j < slotRows[i]['slots'].length; j++)
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: TextEditingController(text: slotRows[i]['slots'][j]['startTime']),
                              decoration: InputDecoration(
                                labelText: 'Start Time',
                                suffixIcon: IconButton(
                                  icon: Icon(Icons.access_time),
                                  onPressed: () => _selectTime(context, i, j, true),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 20),
                          Expanded(
                            child: TextFormField(
                              controller: TextEditingController(text: slotRows[i]['slots'][j]['endTime']),
                              decoration: InputDecoration(
                                labelText: 'End Time',
                                suffixIcon: IconButton(
                                  icon: Icon(Icons.access_time),
                                  onPressed: () => _selectTime(context, i, j, false),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10.0),
                          IconButton(
                            onPressed: () => removeSlotForDay(i, j),
                            icon: Icon(Icons.remove),
                          ),
                        ],
                      ),
                    ElevatedButton(
                      onPressed: () => addSlotForDay(i),
                      child: Text('Add Slot Time'),
                    ),
                    SizedBox(height: 20.0),
                  ],
                ),
              ElevatedButton(
                onPressed: addSlotRow,
                child: Column(
                  children: [
                    Center(
                      child: Text('Add Day'),
                    )
                  ],
                ),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  submitForm();
                },
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
