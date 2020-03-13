import 'package:flutter/material.dart';
import 'package:zippyhealth/screens/home/prescription_list.dart';
import 'package:zippyhealth/services/auth.dart';
import 'package:zippyhealth/services/database.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Home extends StatelessWidget {
  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    return StreamProvider<QuerySnapshot>.value(
      value: DatabaseService().prescriptions,
      child: Scaffold(
        backgroundColor: const Color(0xffD1F2EB),
        appBar: AppBar(
          title: Text('ZippyHealth'),
          backgroundColor: const Color(0xff17A589),
          elevation: 0.0,
          actions: <Widget>[
            FlatButton.icon(
                onPressed: () async {
                  await _auth.signOut();
                },
                icon: Icon(Icons.person),
                label: Text('logout'))
          ],
        ),
        body: PrescriptionList(),
      ),
    );
  }
}
