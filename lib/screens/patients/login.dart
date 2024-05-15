import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:hospital/screens/patients/widgets/dashboard.dart';
import 'package:hospital/screens/tabs.dart';
class UserData{
  final int id;
  final String username;
  final String  email;
  final String Password;
  UserData({required this.id,required this.username,required this.email,required this.Password});

  factory UserData.fromJson(Map<String,dynamic> json){
    return UserData(
        id: int.parse(json['user_no']), username:
    json['username'], email: json['password'], Password: json['email']
    );
  }
}

TextEditingController Email = new TextEditingController();
TextEditingController Password = new TextEditingController();

class LoginPatientScreen extends StatefulWidget{
  const LoginPatientScreen({super.key});
  @override
  State<LoginPatientScreen> createState() {
    return _authScreenState();
  }
}

class _authScreenState extends State<LoginPatientScreen> {

  List<UserData> users = [];
  final _form = GlobalKey<FormState>();
  var enteredEmail = '';
  var enteredPassword= '';
  var _islogin =true;
  void _submit(){
    final isvalid = _form.currentState!.validate();
    if(isvalid){
      _form.currentState!.save();
      print(enteredEmail);
      print(enteredPassword);
    }
  }

  Future<void> login() async {
    if (_form.currentState!.validate()) {

      final response = await http.post(Uri.parse(
          'http://192.168.43.239/hospital_api/patient_oper/patient_login.php'), body: {
        'email': Email.text,
        'password': Password.text,
      }
      );

     print(response.body);
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        print(data);
        setState(() {
          if (data['authenticated']) {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => PatientDashbord(email:Email.text ,)));
          }
          else {
            ScaffoldMessenger.of(context).
            showSnackBar(
                SnackBar(content: Text('invalid username or password')));
          }
        });
      } else {
        ScaffoldMessenger.of(context).
        showSnackBar(SnackBar(content: Text('not loaded')));
      }
    }else{
      print('not validated');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(
                  top: 30,
                  bottom: 20,
                  left: 20,
                  right: 20,
                ),
                width: 200,
                child: Image.asset('assets/loginIcon.png'),
              ),
              Card(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Form(
                          key: _form,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextFormField(
                                controller: Email,
                                decoration: InputDecoration(
                                  labelText: 'Email Address',
                                ),
                                keyboardType: TextInputType.emailAddress,
                                autocorrect: false,
                                textCapitalization: TextCapitalization.none,
                                validator: (value){
                                  if(value==null || value.trim().isEmpty || !value.contains('@')
                                  ){
                                    return 'Please inter a valid email address';
                                  }
                                  return null;
                                },
                                onSaved: (newValue) {
                                  enteredEmail=newValue!;
                                },
                              ),
                              TextFormField(
                                controller: Password,
                                decoration: InputDecoration(
                                  labelText: 'Password',
                                ),

                                obscureText: true,
                                validator: (value) {
                                  if(value==null || value.trim().length < 2 ) {
                                    return 'Password must be at least 2 characters long';
                                  }
                                  return null;
                                },
                                onSaved: (newValue){
                                  enteredPassword =newValue!;
                                },
                              ),
                              const SizedBox(height: 12,),
                              ElevatedButton(onPressed: (){
                                setState(() {
                                  login();
                                });

                                //Navigator.push(context, MaterialPageRoute(builder: (context)=>PatientDashbord()));
                              },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Theme.of(context).colorScheme.primaryContainer
                                ),
                                child:  Text(_islogin ? 'login':'Signup'),
                              ),
                              TextButton(onPressed: (){
                                setState(() {
                                  _islogin=!_islogin;
                                });
                              }, child:  Text(_islogin ?'Create an account':'I already have an account ')
                              )
                            ],
                          )
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}