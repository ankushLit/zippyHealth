import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zippyhealth/models/prescription_model.dart';

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

// get prescription list from snapshot
  List<Prescriptions> _prescriptionListFromSnapshot(
      QuerySnapshot querySnapshot) {
    return querySnapshot.documents.map((doc) {
      return Prescriptions(
          name: doc.data['name'] ?? '',
          docName: doc.data['doctor_name'] ?? '',
          tablets: doc.data['tablets'].toString().split(',') ?? [],
          date: doc.data['date'] ?? '');
    }).toList();
  }

  // get prescription stream
  Stream<List<Prescriptions>> get prescriptions {
    print('uid' + uid);
    return Firestore.instance
        .collection('patients')
        .document(uid)
        .collection('prescription')
        .snapshots()
        .map(_prescriptionListFromSnapshot);
  }
}
