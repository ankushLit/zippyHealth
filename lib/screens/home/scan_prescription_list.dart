import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zippyhealth/models/prescription_model.dart';
import 'package:zippyhealth/screens/home/prescription_list.dart';
import 'package:zippyhealth/services/database.dart';

class QRscanned extends StatefulWidget {
  const QRscanned({Key key, this.mobNumber, this.uid}) : super(key: key);

  @override
  _QRscannedState createState() => _QRscannedState();
  final mobNumber;
  final uid;
}

class _QRscannedState extends State<QRscanned> {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Prescriptions>>.value(
        value: DatabaseService(mobileNumber: widget.mobNumber, uid: widget.uid)
            .prescriptions,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Prescriptions of ' + widget.mobNumber),
          ),
          body: PrescriptionList(),
        ));
  }
}
