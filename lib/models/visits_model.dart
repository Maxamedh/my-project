import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../screens/visits_insertion.dart';
class Visit {
  final String vNo;
  final String name;
  final String staffName;
  final String vDate;

  Visit({required this.vNo, required this.name, required this.staffName, required this.vDate});

  factory Visit.fromJson(Map<String, dynamic> json) {
    return Visit(
      vNo: json['v_no'],
      name: json['patient'],
      staffName: json['doctor_no '],
      vDate: json['v_date'],
    );
  }

  Map<String, dynamic>toMap(){
    return {
      'v_no':vNo,
      'patient':name,
      'doctor_no':staffName,
      'v_date':vDate,
    };
  }

}

class operationsvisits {
  operationsvisits._privateConstructor();

  static final operationsvisits instance = operationsvisits._privateConstructor();


  Future<String> add_Visit(Visit visits) async{

      final response = await http.post(Uri.parse(
          'http://192.168.43.239/hospital_api/operations/crud_visits.php'
      ),
        body: visits.toMap(),
      );
      return response.body;
  }

  Future<String> update_Visit(Visit visits) async{
    final body = visits.toMap();

    final response = await http.post(Uri.parse(
        'http://192.168.43.239/hospital_api/operations/update_visit.php'
    ),
      body: body,
    );
    return response.body;
  }


}


