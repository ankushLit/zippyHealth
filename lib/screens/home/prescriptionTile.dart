import 'package:flutter/material.dart';
import 'package:zippyhealth/models/prescription_model.dart';

class PrescriptionListTile extends StatelessWidget {
  final Prescriptions pres;

  PrescriptionListTile({this.pres});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: Card(
        margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
        child: ListTile(
          leading: Container(child: Text('1')),
          title: Text(pres.docName),
          subtitle: Text(pres.date),
        ),
      ),
    );
  }
}
