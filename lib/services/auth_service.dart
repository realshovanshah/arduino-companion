import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:task_weplay/models/user_model.dart';

import '../models/user_model.dart';

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

    addUser(
      userModel: userModel,
      uid: user.credential.providerId,
    );

    return user.credential.providerId;
  }

  Future<String> currentUser() async {
    User user = _firebaseAuth.currentUser;
    return user != null ? user.uid : null;
  }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

  Future<UserModel> getCurrentUser(String uid) {
    return _db
        .collection('users')
        .where(FieldPath.documentId, isEqualTo: uid)
        .get()
        .then(
          (value) => UserModel.fromMap(value.docs.single.data()),
        );
  }

  Future<void> addUser({UserModel userModel, String uid}) async {
    var collection = _db.collection('users');
    userModel = userModel.copyWith(id: uid);
    await collection.add(userModel.toMap());
  }
}
