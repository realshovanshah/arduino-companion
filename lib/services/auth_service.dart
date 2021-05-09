import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:task_weplay/models/user_model.dart';

abstract class BaseAuth {
  Future<String> currentUser();
  Future<String> signIn(String email, String password);
  Future<String> createUser(UserModel userModel);
  Future<void> signOut();
}

class AuthService implements BaseAuth {
  final FirebaseAuth _firebaseAuth;
  final _db = FirebaseFirestore.instance;

  AuthService(this._firebaseAuth);

  Future<String> signIn(String email, String password) async {
    UserCredential user = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    return user.credential.providerId;
  }

  Future<String> createUser(UserModel userModel) async {
    UserCredential user = await _firebaseAuth.createUserWithEmailAndPassword(
        email: userModel.email, password: userModel.password);

    addUser(userModel: userModel);

    return user.credential.providerId;
  }

  Future<String> currentUser() async {
    User user = _firebaseAuth.currentUser;
    return user != null ? user.uid : null;
  }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

  // Future<UserModel> getImages(String id) {
  //   return _db.collection("users").snapshots((snapshots) {
  //     return snapshots.docs.map(
  //       (doc) {
  //         print(doc.data().values);
  //         return ImageModel.fromSnapshot(doc);
  //       },
  //     ).toList();
  //   });
  // }

  Future<void> addUser({UserModel userModel}) async {
    var collection = _db.collection('user');
    userModel = userModel.copyWith(id: collection.id);
    await collection.add(userModel.toMap());
  }
}
