import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../screens/visits_insertion.dart';
class Staff {
  final String staffNo;
  final String staffName;
  final String job;
  final String tell;
  final String gmail;
  final String address;
  final String sex;

  Staff({required this.staffNo, required this.staffName, required this.job,
    required this.tell,required this.gmail,required this.address, required this.sex});

  factory Staff.fromJson(Map<String, dynamic> json) {
    return Staff(
      staffNo: json['staff_no'],
      staffName: json['st_name'],
      job: json['st_job '],
      tell: json['st_tell'],
      gmail: json['gmail'],
      address: json['st_address'],
      sex: json['st_sex'],
    );
  }

  Map<String, dynamic>toMap(){
    return {
      'staff_no':staffNo,
      'st_name':staffName,
      'st_job':job,
      'st_tell':tell,
      'st_address':address,
      'st_sex':sex
    };
  }

}

class operationsStaff {
  operationsStaff._privateConstructor();

  static final operationsStaff instance = operationsStaff._privateConstructor();


  Future<String> add_Staff(Staff staff) async{

    final response = await http.post(Uri.parse(
        'http://192.168.43.239/hospital_api/staff_oper/staff_register.php'
    ),
      body: staff.toMap(),
    );
    return response.body;
  }

  Future<String> update_Staff(Staff staff) async{
    final body = staff.toMap();

    final response = await http.post(Uri.parse(
        'http://192.168.43.239/hospital_api/staff_oper/update_staff.php'
    ),
      body: body,
    );
    return response.body;
  }

  Future<List> fetch_jobs() async {
    final response = await http.get(Uri.parse('http://192.168.43.239/hospital_api/staff_oper/jobs_info.php'));
    if (response.statusCode == 200) {
      jsonDecode(response.body);
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch works Jobs');
    }
  }

  // Future<List> fetch_work_schedule() async {
  //   final response = await http.post(Uri.parse('http://192.168.43.239/hospital_api/All/retrieve.php'),
  //     body: {
  //     'query':'SELECT work_sche_no, staff_name, work_days, start_time, end_time FROM work_schedule, staff WHERE staff.staff_no=work_schedule.staff_id',
  //     }
  //   );
  //   if (response.statusCode == 200) {
  //     jsonDecode(response.body);
  //     return jsonDecode(response.body);
  //   } else {
  //     throw Exception('Failed to fetch works schedules');
  //   }
  // }



}


