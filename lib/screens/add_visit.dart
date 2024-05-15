
import 'package:flutter/material.dart';

class AddUserScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController DoctorController = TextEditingController();
    final TextEditingController vdateController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: Text('Add User')),
      body: Column(
        children: [
          TextField(
            controller: nameController,
            decoration: InputDecoration(labelText: 'Name'),
          ),
          TextField(
            controller: DoctorController,
            decoration: InputDecoration(labelText: 'Email'),
          ),
          TextField(
            controller: vdateController,
            decoration: InputDecoration(labelText: 'Address ID'),
          ),
          ElevatedButton(
            onPressed: () {
              var i=0;
              // final userProvider = context.read<operations>();
              // userProvider.createUser(Visit(
              //   vNo: i,
              //   name: nameController.text,
              //   staffName: DoctorController.text,
              //   vDate: vdateController.text,
              // ));
              Navigator.pop(context);
            },
            child: Text('Add User'),
          ),
        ],
      ),
    );
  }
}
