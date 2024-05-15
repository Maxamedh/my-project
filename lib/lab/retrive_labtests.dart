import 'package:http/http.dart' as http;

import 'dart:convert';

class operationsLab{
  operationsLab._privateConstructor();

  static final operationsLab instance = operationsLab._privateConstructor();


Future<List> fetch_Data(String query) async {

  final Map<String,dynamic>data = {'query':query};
  final response = await http.post(Uri.parse('http://192.168.43.239/hospital_api/All/retrieve.php'),
    body: data
  );
  if (response.statusCode == 200) {
    print(jsonDecode(response.body));
    return jsonDecode(response.body);
  } else {
    throw Exception('Failed to fetch  Data');
  }
}



}


