import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zippyhealth/models/imageDataP.dart';
import 'package:zippyhealth/models/imageDataR.dart';
import 'package:zippyhealth/models/prescription_model.dart';
import 'package:zippyhealth/screens/home/prescription_list.dart';
import 'package:zippyhealth/screens/home/scan_prescription_list.dart';
import 'package:zippyhealth/screens/viewDocs/selection_page.dart';
import 'package:zippyhealth/services/auth.dart';
import 'package:zippyhealth/services/database.dart';
import 'package:provider/provider.dart';
import 'package:zippyhealth/shared/loading.dart';
import 'package:zippyhealth/screens/scanDocs/image_handler.dart';
import 'package:barcode_scan/barcode_scan.dart';

class Home extends StatefulWidget {
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  int _currentIndex = 0;
  String barcode = "";

  Widget callPage(int currrentIndex) {
    switch (currrentIndex) {
      case 0:
        return PrescriptionList();
      case 1:
        return ImageCapture();
      case 2:
        return SelectionPage();

        break;
      default:
        return PrescriptionList();
    }
  }

  @override
  Widget build(BuildContext context) {
    final AuthService _auth = AuthService();
    String uid = '';
    String mobile = '';
    _auth.getUid().then((onValue) {
      List<String> temp = onValue.split(",");
      uid = temp[0];
      print('split uid: ' + temp[0]);
      mobile = temp[1].substring(0, 10);
      print('split Mobile: ' + mobile);
      print("uid: " + onValue);
    });
    return FutureBuilder<String>(
        future: _auth.getUid(),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          Widget children;
          if (snapshot.hasData) {
            children = StreamProvider<List<Prescriptions>>.value(
              value:
                  DatabaseService(mobileNumber: mobile, uid: uid).prescriptions,
              child: StreamProvider<List<ImageDataP>>.value(
                value: DatabaseService(mobileNumber: mobile, uid: uid)
                    .prescriptionImages,
                child: StreamProvider<List<ImageDataR>>.value(
                  value: DatabaseService(mobileNumber: mobile, uid: uid)
                      .reportImages,
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
                    floatingActionButton: FloatingActionButton(
                      onPressed: () async {
                        String x = null;
                        print('In barcode mathod');
                        if ((x = await scan()) != null) {
                          print(x);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => QRscanned(
                                        mobNumber: x,
                                        uid: uid,
                                      )));
                        }
                      },
                      child: Icon(Icons.crop_free),
                    ),
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

  Future<String> scan() async {
    try {
      var barcodeResult = await BarcodeScanner.scan();
      String barcode = barcodeResult.rawContent;
      print('Barcode: ' + barcode);
      setState(() => this.barcode = barcode);
      return barcode;
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.cameraAccessDenied) {
        setState(() {
          this.barcode = 'The user did not grant the camera permission!';
        });
      } else {
        setState(() => this.barcode = 'Unknown error: $e');
      }
    } on FormatException {
      setState(() => this.barcode =
          'null (User returned using the "back"-button before scanning anything. Result)');
    } catch (e) {
      setState(() => this.barcode = 'Unknown error: $e');
    }
  }
}
