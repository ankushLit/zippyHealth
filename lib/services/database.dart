import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});
  //collection reference
  final CollectionReference patients =
      Firestore.instance.collection('patients');

  Future updateUserData(String name, String age, String weight) async {
    print(uid);
    return await patients.document(uid).setData({
      'name': name,
      'age': age,
      'weight': weight,
    });
  }

  // get prescription stream

  Stream<QuerySnapshot> get prescriptions {
    return patients.snapshots();
  }
}
