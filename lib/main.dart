import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_weplay/services/auth_service.dart';
import 'package:task_weplay/services/dustbin_service.dart';
import 'package:task_weplay/ui/home/home_screen.dart';

import 'bloc/dustbin_bloc.dart';
import 'ui/auth/auth_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final _firebaseAuth = FirebaseAuth.instance;

  @override
  final _imageService = ImageService();

  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weplay Task',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
          if (!snapshot.hasData)
            return LoginScreen(
              auth: AuthService(FirebaseAuth.instance),
            );
          return BlocProvider(
            create: (context) => ImageBloc(_imageService),
            child: HomeScreen(
              firebaseAuth: _firebaseAuth,
            ),
          );
        },
      ),
    );
  }
}
