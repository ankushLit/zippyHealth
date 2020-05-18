import 'package:flutter/material.dart';
import 'package:zippyhealth/models/prescription_model.dart';
import 'package:zippyhealth/screens/home/prescription_list.dart';
import 'package:zippyhealth/services/auth.dart';
import 'package:zippyhealth/services/database.dart';
import 'package:provider/provider.dart';
import 'package:zippyhealth/shared/loading.dart';
import 'package:zippyhealth/screens/scanDocs/pg1.dart';
import 'package:zippyhealth/screens/viewDocs/pg2.dart';

class Home extends StatefulWidget {
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  int _currentIndex = 0;

  Widget callPage(int currrentIndex) {
    switch (currrentIndex) {
      case 0:
        return PrescriptionList();
      case 1:
        return Page1();
      case 2:
        return Page2();

        break;
      default:
        return PrescriptionList();
    }
  }

  @override
  Widget build(BuildContext context) {
    final AuthService _auth = AuthService();
    String uid = '';
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
                  //backgroundColor: const Color(0xff17A589),
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
                body: callPage(_currentIndex),
                bottomNavigationBar: BottomNavigationBar(
                  currentIndex: _currentIndex,
                  onTap: (val) {
                    setState(() {
                      _currentIndex = val;
                    });
                  },
                  items: [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.list),
                      title: Text("Prescriptions"),
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.camera),
                      title: Text("Scan"),
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.pages),
                      title: Text("Documents"),
                    ),
                  ],
                ),
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
