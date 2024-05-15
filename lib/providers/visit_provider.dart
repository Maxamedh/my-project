import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hospital/models/visits_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:state_notifier/state_notifier.dart';

class CrudProvider extends StateNotifier<List<Visit>> {
  CrudProvider() : super([]);

  Future<List> fetchUsers() async {
    final response = await http.get(Uri.parse('http://192.168.43.239/hospital_api/visits.php'));
    if (response.statusCode == 200) {
      final List<dynamic> responseData = jsonDecode(response.body);
      state = responseData.map((data) => Visit.fromJson(data)).toList();
      return state;
    } else {
      throw Exception('Failed to fetch users');
    }
  }

  Future<void> createUser(Visit visit) async {
    final response = await http.post(
      Uri.parse('your_php_url/user.php'),
      body: {
        'patient_name': visit.name,
        'doctor_name': visit.staffName,
        'v_date':visit.vDate,
      },
    );
    if (response.statusCode == 200) {
      fetchUsers();
    } else {
      throw Exception('Failed to create user');
    }
  }

  Future<void> updateUser(Visit visit) async {
    final response = await http.put(
      Uri.parse('your_php_url/user.php?id=${visit.vNo}'),
      body: {
        'patient_name': visit.name,
        'doctor_name': visit.staffName,
        'v_date':visit.vNo,
      },
    );
    if (response.statusCode == 200) {
      fetchUsers();
    } else {
      throw Exception('Failed to update user');
    }
  }

  Future<void> deleteUser(int vistId) async {
    final response = await http.delete(Uri.parse('your_php_url/user.php?id=$vistId'));
    if (response.statusCode == 200) {
      fetchUsers();
    } else {
      throw Exception('Failed to delete user');
    }
  }
}

final operationNotifier =
StateNotifierProvider<CrudProvider,List<Visit>>(
        (ref) {
      return CrudProvider();
    }
);

