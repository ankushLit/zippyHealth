import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zippyhealth/models/prescription_model.dart';
import 'package:zippyhealth/screens/home/prescriptionTile.dart';
import 'package:zippyhealth/shared/loading.dart';

class PrescriptionList extends StatefulWidget {
  @override
  _PrescriptionListState createState() => _PrescriptionListState();
}

class _PrescriptionListState extends State<PrescriptionList> {
  @override
  Widget build(BuildContext context) {
    final prescriptions = Provider.of<List<Prescriptions>>(context);
    //print(prescriptions.documents);
    // prescriptions.forEach((pres) {
    //   print(pres.name);
    //   print(pres.docName);
    //   print(pres.tablets);
    // });
    return prescriptions == null
        ? Loading()
        : ListView.builder(
            itemCount: prescriptions.length ?? 0,
            itemBuilder: (context, index) {
              return PrescriptionListTile(pres: prescriptions[index]);
            });
  }
}
