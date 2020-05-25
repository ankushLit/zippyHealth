import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zippyhealth/models/prescription_model.dart';
import 'package:zippyhealth/models/imageDataP.dart';
import 'package:zippyhealth/models/imageDataR.dart';

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

  Future saveStorageData(String fileName, String path) async {
    return await patients.document(uid).collection(path).document().setData({
      'fileName': fileName,
      'date': DateTime.now().day.toString() +
          '/' +
          DateTime.now().month.toString() +
          '/' +
          DateTime.now().year.toString(),
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
          presId: doc.data['presId'] ?? '',
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

//prescription Images
  List<ImageDataP> _prescriptionsImageListFromSnapshot(
      QuerySnapshot querySnapshot) {
    return querySnapshot.documents.map((doc) {
      return ImageDataP(
          imageName: doc.data['fileName'], date: doc.data['date']);
    }).toList();
  }

//get prescriptionImages stream
  Stream<List<ImageDataP>> get prescriptionImages {
    print('Prescription stream');
    return patients
        .document(uid)
        .collection('prescriptionsImages')
        .snapshots()
        .map(_prescriptionsImageListFromSnapshot);
  }

  //report Images
  List<ImageDataR> _reportsImageListFromSnapshot(QuerySnapshot querySnapshot) {
    return querySnapshot.documents.map((doc) {
      return ImageDataR(
          imageName: doc.data['fileName'], date: doc.data['date']);
    }).toList();
  }

//get prescriptionImages stream
  Stream<List<ImageDataR>> get reportImages {
    print('Report stream');
    return patients
        .document(uid)
        .collection('reportsImages')
        .snapshots()
        .map(_reportsImageListFromSnapshot);
  }
}
