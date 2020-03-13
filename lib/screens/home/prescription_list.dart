import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class PrescriptionList extends StatefulWidget {
  @override
  _PrescriptionListState createState() => _PrescriptionListState();
}

class _PrescriptionListState extends State<PrescriptionList> {
  @override
  Widget build(BuildContext context) {
    final prescriptions = Provider.of<QuerySnapshot>(context);
    print(prescriptions);
    return Container();
  }
}
