import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart'; // Import Firebase core package
import 'package:hive_flutter/hive_flutter.dart';
import 'package:newp/login_page.dart';
import 'package:newp/homescreen.dart';
import 'package:provider/provider.dart';
import 'package:newp/widgets/timerservice.dart';
import 'api/firebase_api.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Platform.isAndroid
      ? await Firebase.initializeApp(
          options: const FirebaseOptions(
              apiKey: 'AIzaSyCqdtLLna3SQdjD9F_jGKUNi4D6rR2MykU',
              appId: '1:959257585633:android:7736f18cfaba0eda1e54a0',
              messagingSenderId: '959257585633',
              projectId: 'pblproject-b8b41'))
      : await Firebase.initializeApp();
  await FirebaseApi().initNotifications();
  await Hive.initFlutter(); // Initialize Firebase app
  runApp(ChangeNotifierProvider(
    create: (context) => timerservice(),
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: AuthChecker(), // Use AuthChecker to decide which screen to show
    );
  }
}

class AuthChecker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          final user = snapshot.data;
          return user != null ? Home() : loginScreen();
        }
      },
    );
  }
}
