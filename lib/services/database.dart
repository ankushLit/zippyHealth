import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zippyhealth/models/prescription_model.dart';
import 'package:zippyhealth/models/imageDataP.dart';
import 'package:zippyhealth/models/imageDataR.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as Path;

class DatabaseService {
  final String uid;
  final String mobileNumber;
  DatabaseService({this.uid, this.mobileNumber});
  //collection reference
  final CollectionReference patients =
      Firestore.instance.collection('patients');

  Future updateUserData(String name, String age, String mobile) async {
    print(uid);
    return await patients.document(uid).setData({
      'name': name,
      'age': age,
      'mobile': mobile,
    });
  }

  Future saveStorageData(String fileName, String path, String url) async {
    return await patients.document(uid).collection(path).document().setData({
      'fileName': fileName,
      'date': DateTime.now().day.toString() +
          '/' +
          DateTime.now().month.toString() +
          '/' +
          DateTime.now().year.toString(),
      'url': url,
    });
  }

// get prescription list from snapshot
  List<Prescriptions> _prescriptionListFromSnapshot(
      QuerySnapshot querySnapshot) {
    return querySnapshot.documents.map((doc) {
      return Prescriptions(
          name: doc.data['patient_name'] ?? '',
          docName: doc.data['doctor_name'] ?? '',
          tablets: doc.data['medicines'].toString().split(',') ?? [],
          presId: doc.data['patient_no'] ?? '',
          date: doc.data['date'] ?? '');
    }).toList();
  }

  // get prescription stream
  Stream<List<Prescriptions>> get prescriptions {
    //print('uid' + uid);
    print('Mobile ' + mobileNumber);
    return Firestore.instance
        .collection('Prescriptions')
        .document(mobileNumber)
        .collection('presc')
        .snapshots()
        .map(_prescriptionListFromSnapshot);
  }

//prescription Images
  List<ImageDataP> _prescriptionsImageListFromSnapshot(
      QuerySnapshot querySnapshot) {
    return querySnapshot.documents.map((doc) {
      return ImageDataP(
        imageName: doc.data['fileName'],
        date: doc.data['date'],
        uid: uid,
        imagePath: doc.data['url'],
        docId: doc.documentID.toString(),
      );
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

  //get report Images
  List<ImageDataR> _reportsImageListFromSnapshot(QuerySnapshot querySnapshot) {
    return querySnapshot.documents.map((doc) {
      return ImageDataR(
        imageName: doc.data['fileName'],
        date: doc.data['date'],
        uid: uid,
        imagePath: doc.data['url'],
        docId: doc.documentID.toString(),
      );
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

  void deletePrescriptions(String docId) {
    patients
        .document(uid)
        .collection('prescriptionsImages')
        .document(docId)
        .delete();
  }

  void deleteReports(String docId) {
    patients.document(uid).collection('reportsImages').document(docId).delete();
  }

  Future<void> deleteImage(String imageFileUrl) async {
    var fileUrl = Uri.decodeFull(Path.basename(imageFileUrl))
        .replaceAll(new RegExp(r'(\?alt).*'), '');

    final StorageReference firebaseStorageRef =
        FirebaseStorage.instance.ref().child(fileUrl);
    await firebaseStorageRef.delete();
  }
}
