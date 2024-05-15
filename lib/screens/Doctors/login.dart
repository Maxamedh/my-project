import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginDoctorScreen extends StatefulWidget{
  const LoginDoctorScreen({super.key});
  @override
  State<LoginDoctorScreen> createState() {
    return _authScreenState();
  }
}

class _authScreenState extends State<LoginDoctorScreen> {
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
                                decoration: InputDecoration(
                                  labelText: 'Password',
                                ),

                                obscureText: true,
                                validator: (value) {
                                  if(value==null || value.trim().length < 6 ) {
                                    return 'Password must be at least 6 characters long';
                                  }
                                  return null;
                                },
                                onSaved: (newValue){
                                  enteredPassword =newValue!;
                                },
                              ),
                              const SizedBox(height: 12,),
                              ElevatedButton(onPressed: _submit,
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