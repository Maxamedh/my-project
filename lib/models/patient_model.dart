import 'dart:convert';

import 'package:hospital/models/visits_model.dart';
import 'package:http/http.dart' as http;
class Patient  {
  final String id;
  final String name;
  final String tell;
  final String sex;
  final String gmail;
  final String password;
  final String address;
  final String birth_date;

  Patient({
    required this.id, required this.name,required
  this.tell,required this.sex,required this.gmail,
    required this.password,required this.address,required this.birth_date});

  factory Patient.fromMap(Map<String, dynamic>json)=>
      new Patient(id: json['p_no'], name: json['name'], tell: json['tell'], sex: json['sex'],
          gmail: json['email'], password: json['password'],address: json['add_no'],
          birth_date: json['birth_date']);

  Map<String, dynamic>toMap(){
    return {
      'p_no':id,
      'name':name,
      'tell':tell,
      'sex':sex,
      'email':gmail,
      'password':password,
      'add_no':address,
      'birth_date':birth_date,
    };
  }

}

class operations{
  operations._privateConstructor();
  static final operations instance=operations._privateConstructor();
  Future<List<dynamic>> Patient_info() async{
    final response = await http.get(Uri.parse('http://192.168.43.239/hospital_api/patient_oper/patient_info.php'));
    if(response.statusCode==200){
      return jsonDecode(response.body);
    }else{
      throw Exception('failed to load data');
    }

  }

  Future<List<dynamic>> address_info() async{
    final response = await http.get(Uri.parse('http://192.168.43.239/hospital_api/address.php'));
    if(response.statusCode==200){
      List<dynamic> data = jsonDecode(response.body);
      return data;
    }else{
      throw Exception('failed to load data');
    }

  }
  Future<List> fetchVisits() async {
    final response = await http.get(Uri.parse('http://192.168.43.239/hospital_api/operations/visits.php'));
    if (response.statusCode == 200) {
      jsonDecode(response.body);
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch Visits');
    }
  }
  Future<List> fetchStaff() async {
    final response = await http.get(Uri.parse('http://192.168.43.239/hospital_api/staff_oper/staff_info.php'));
    if (response.statusCode == 200) {
      jsonDecode(response.body);
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch staff');
    }
  }
  Future<List> fetchDoctor() async {
    final response = await http.get(Uri.parse('http://192.168.43.239/hospital_api/doctor_oper/doctor_info.php'));
    if (response.statusCode == 200) {
      jsonDecode(response.body);
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch Doctors');
    }
  }

  Future<List> fetchScedule() async {
    final response = await http.get(Uri.parse('http://192.168.43.239/hospital_api/staff_oper/work_schedule.php'));
    if (response.statusCode == 200) {
      jsonDecode(response.body);
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch works schedules');
    }
  }

  Future<List> fetchPayment() async {
    final response = await http.get(Uri.parse('http://192.168.43.239/hospital_api/payments.php'));
    if (response.statusCode == 200) {
      jsonDecode(response.body);
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch works schedules');
    }
  }
  Future<List> fetchdoctor_schedule() async {
    final response = await http.get(Uri.parse('http://192.168.43.239/hospital_api/doctor_oper/doctor_schedule.php'));
    if (response.statusCode == 200) {
      jsonDecode(response.body);
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch works schedules');
    }
  }


  Future<String> update_patient(Patient patient) async{

    final response = await http.post(Uri.parse(
        'http://192.168.43.239/hospital_api/patient_oper/update_patient.php'
    ),
      body: patient.toMap(),
    );
    print(patient.toMap());
    return response.body;
  }

}