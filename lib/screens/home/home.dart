import 'package:flutter/material.dart';
import 'package:zippyhealth/models/prescription_model.dart';
import 'package:zippyhealth/screens/home/prescription_list.dart';
import 'package:zippyhealth/services/auth.dart';
import 'package:zippyhealth/services/database.dart';
import 'package:provider/provider.dart';
import 'package:zippyhealth/shared/loading.dart';

class Home extends StatelessWidget {
  final AuthService _auth = AuthService();
  String uid = '';

  @override
  Widget build(BuildContext context) {
    _auth.getUid().then((onValue) {
      uid = onValue;
      print("uid: " + onValue);
    });
    return FutureBuilder<String>(
        future: _auth.getUid(),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          Widget children;
          if (snapshot.hasData) {
            children = StreamProvider<List<Prescriptions>>.value(
              value: DatabaseService(uid: uid).prescriptions,
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
          } else if (snapshot.hasError) {
            children = Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            children = Loading();
          }
          return children;
        });
  }
}
