import 'package:firebase_auth/firebase_auth.dart';
import 'package:zippyhealth/models/user.dart';
import 'package:zippyhealth/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String uid = '';
  String mobile = '';
  // create user object based on FirebaseUser

  User _userFromFirebaseUser(FirebaseUser user) {
    return user != null ? User(uid: user.uid) : null;
  }

// auth change user stream
  Stream<User> get user {
    return _auth.onAuthStateChanged
        //.map((FirebaseUser user)=>_userFromFirebaseUser(user));
        .map(_userFromFirebaseUser); //same as above
  }

  //sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //register with email and password
  Future registerWithEmailAndPassword(String email, String password,
      String name, String age, String weight) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      //Create a new document for user with uid
      await DatabaseService(uid: user.uid).updateUserData(name, age, weight);
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

//get uid
  Future<String> getUid() async {
    final FirebaseUser user = await _auth.currentUser();
    uid = user.uid.toString();
    String x = uid + ',';
    await Firestore.instance
        .collection('patients')
        .document(uid)
        .get()
        .then((value) {
      print("WHY? " + value.data['mobile']);
      mobile = value.data['mobile'].toString();
    });
    print(uid);
    x = x + mobile;
    print('mobileX: ' + mobile);
    print('X:' + x);
    return x + mobile;
  }

  //sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
