import 'package:flutter/material.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({
    Key? key,
    required this.pname,
    required this.email,
    required this.password,
    required this.tell,
  }) : super(key: key);

  final String pname;
  final String email;
  final String password;
  final String tell;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.all(30),
            color: Colors.blue,
            child: DrawerHeader(
              padding: const EdgeInsets.all(20),


              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(

                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hospital App!',
                      style: Theme.of(context).textTheme.headline6!.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Name: $pname',
                      style: TextStyle(color: Colors.white),
                    ),
                    Text(
                      'Email: $email',
                      style: TextStyle(color: Colors.white),
                    ),
                    Text(
                      'Tell: $tell',
                      style: TextStyle(color: Colors.white),
                    ),
                    Text(
                      'Password: $password',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            child: ListTile(
              leading: Icon(
                Icons.edit,
                size: 26,
                color: Theme.of(context).colorScheme.onBackground,
              ),
              title: Text(
                'Edit Profile',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onBackground,
                  fontSize: 24,
                ),
              ),
              onTap: () {},
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.logout,
              size: 26,
              color: Theme.of(context).colorScheme.onBackground,
            ),
            title: Text(
              'Logout',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onBackground,
                fontSize: 24,
              ),
            ),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
