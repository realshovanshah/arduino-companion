import 'dart:async';

import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_dustbin/services/auth_service.dart';
import 'package:smart_dustbin/services/dustbin_service.dart';
import 'package:smart_dustbin/ui/home/home_screen.dart';
import 'package:smart_dustbin/utilities/notificaiton_plugin.dart';

import 'bloc/dustbin_bloc.dart';
import 'ui/auth/auth_screen.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await AndroidAlarmManager.initialize();
  runApp(MyApp());
  await AndroidAlarmManager.oneShot(Duration(seconds: 10), 1, () {
    print('object');
  });
}

class MyApp extends StatelessWidget {
  SharedPreferences prefs;

  final _firebaseAuth = FirebaseAuth.instance;

  final uidProvider = ValueNotifier('');

  final _imageService = ImageService();
  final noti = NotificationPlugin();

  void dustbinFullCallback() {
    noti.show(11, 'title', 'dustbin');
  }

  @override
  Widget build(BuildContext context) {
    // Timer.periodic(Duration(seconds: 60), (t) => dustbinFullCallback());

    SharedPreferences.getInstance().then((value) => prefs = value);
    return MaterialApp(
      title: 'Smart Dustbin',
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
              onSignIn: (uid) {
                prefs.setString('uid', uid);
                print('lul' + prefs.getString('uid'));
              },
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
