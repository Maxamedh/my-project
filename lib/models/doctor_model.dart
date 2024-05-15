import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../screens/visits_insertion.dart';
class Doctor {
  final String doctorNo;
  final String doctor_name;
  final String specialization;
  final String decree;

  Doctor({required this.doctorNo, required this.doctor_name, required this.specialization,
    required this.decree});

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      doctorNo: json['doctor_no'],
      doctor_name: json['doctor'],
      specialization: json['special '],
      decree: json['decree'],
    );
  }

  Map<String, dynamic>toMap(){
    return {
      'doctor_no':doctorNo,
      'doctor':doctor_name,
      'special':specialization,
      'decree':decree,

    };
  }

}

class operationsDoctor {
  operationsDoctor._privateConstructor();

  static final operationsDoctor instance = operationsDoctor._privateConstructor();


  Future<String> add_Doctor(Doctor doctor) async{

    final response = await http.post(Uri.parse(
        'http://192.168.43.239/hospital_api/doctor_oper/doctor_reg.php'
    ),
      body: doctor.toMap(),
    );
    return response.body;
  }

  Future<String> update_Doctor(Doctor doctor) async{
    final body = doctor.toMap();

    final response = await http.post(Uri.parse(
        'http://192.168.43.239/hospital_api/doctor_oper/update_doctor.php'
    ),
      body: body,
    );
    return response.body;
  }

  Future<List> fetch_Special() async {
    final response = await http.get(Uri.parse('http://192.168.43.239/hospital_api/doctor_oper/specialization.php'));
    if (response.statusCode == 200) {
      jsonDecode(response.body);
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch specialization ');
    }
  }

  Future<List> fetch_decree() async {
    final response = await http.get(Uri.parse('http://192.168.43.239/hospital_api/doctor_oper/decree_info.php'));
    if (response.statusCode == 200) {
      jsonDecode(response.body);
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch decree ');
    }
  }
  Future<List> fetch_rooms() async {
    final response = await http.get(Uri.parse('http://192.168.43.239/hospital_api/doctor_oper/rooms_info.php'));
    if (response.statusCode == 200) {
      jsonDecode(response.body);
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch Rooms ');
    }
  }


}


