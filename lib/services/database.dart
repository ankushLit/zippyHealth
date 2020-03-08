import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  //collection reference
  final CollectionReference patients =
      Firestore.instance.collection('patients');

  Future updateUserData(String userName, String age, String bloodGroup) {}
}
