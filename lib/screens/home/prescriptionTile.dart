import 'package:flutter/material.dart';
import 'package:zippyhealth/models/prescription_model.dart';
import 'package:zippyhealth/screens/home/prescription_view.dart';

class PrescriptionListTile extends StatelessWidget {
  final Prescriptions pres;
  final int presNum;

  PrescriptionListTile({this.pres, this.presNum});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: GestureDetector(
        onTap: () => {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PrescriptionView(prescription: pres),
            ),
          ),
        },
        child: Card(
          margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
          child: ListTile(
            leading: Container(child: Text(presNum.toString())),
            title: Text(pres.docName),
            subtitle: Text(pres.date),
          ),
        ),
      ),
    );
  }
}
