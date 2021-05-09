import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_dustbin/services/auth_service.dart';

class DefaultScreen extends StatelessWidget {
  const DefaultScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              AuthService(FirebaseAuth.instance).signOut();
            },
          )
        ],
      ),
      body: Container(
        color: Colors.redAccent,
        child: Center(child: Text('Home')),
      ),
    );
  }
}
