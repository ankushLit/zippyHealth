import 'package:flutter/material.dart';
import 'package:zippyhealth/models/user.dart';
import 'package:zippyhealth/screens/wrapper.dart';
import 'package:provider/provider.dart';
import 'package:zippyhealth/services/auth.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: AuthService().user,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          // Define the default brightness and colors.
          brightness: Brightness.light,
          primaryColor: Colors.teal[700],
          accentColor: Colors.teal,
        ),
        home: Wrapper(),
      ),
    );
  }
}
