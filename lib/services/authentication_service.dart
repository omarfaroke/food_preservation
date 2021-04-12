import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:food_preservation/app/locator.dart';
import 'package:food_preservation/models/user_model.dart';
import 'package:food_preservation/services/db/user_firestore_service.dart';
import 'package:food_preservation/services/storge_services.dart';
import 'package:food_preservation/ui/pages/login/login_page.dart';
import 'package:get/get.dart';

import 'app_service.dart';

class AuthenticationService extends GetxService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  Rx<User> _firebaseUser = Rx<User>();

  @override
  onInit() {
    super.onInit();
    _firebaseUser.bindStream(_firebaseAuth.userChanges());
  }

  User get currentUser => _firebaseUser.value;

  Future loginWithEmail({
    @required String email,
    @required String password,
  }) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      UserModel user = await Get.find<UserFirestoreService>()
          .getUser(userCredential.user.uid);

      // if not found from firestore
      if (user == null) {
        await userCredential.user.delete();
        throw Exception('');
      }

      await locator<AppService>().refreshUserInfo(user);

      userCredential.user.reload();

      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw UserNotFoundException();
      } else if (e.code == 'wrong-password') {
        throw WrongPasswordException();
      }
    } catch (e) {
      rethrow;
      // return e.message;
    }
  }

  Future signUpWithEmail(
      {@required String email,
      @required String password,
      UserModel user,
      File imageFile,
      bool newUserFromAdmin = false}) async {
    //
    FirebaseApp appSecondary;
    FirebaseAuth auth;

    if (newUserFromAdmin) {
      appSecondary = await Firebase.initializeApp(
          name: 'Secondary', options: Firebase.app().options);
      auth = FirebaseAuth.instanceFor(app: appSecondary);
    } else {
      auth = _firebaseAuth;
    }

    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // auth.currentUser.updateProfile(displayName: user.name);

      user.id = userCredential.user.uid;

      if (imageFile != null) {
        user.photo = await StorageService.uploadFile(
            'usersImages/${user.id}', imageFile);
        auth.currentUser.updateProfile(photoURL: user.photo);
      }

      bool ok = await Get.find<UserFirestoreService>().createUser(user);
      if (!ok) {
        await userCredential.user.delete();
        throw Exception('');
      }

      if (!newUserFromAdmin) {
        await locator<AppService>().refreshUserInfo(user);
      } else {
        await appSecondary.delete();
      }

      return userCredential.user?.uid;
    } on FirebaseAuthException catch (e) {
      print(e.code);
      if (e.code == 'weak-password') {
        throw WeakPasswordException();
      } else if (e.code == 'email-already-in-use') {
        throw EmailAlreadyInUseException();
      }
    } catch (e) {
      rethrow;
      // print(e);
    }
  }

  // Reset Password
  Future sendPasswordResetEmail({@required String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw UserNotFoundException();
      } else {
        rethrow;
      }
    } catch (e) {
      rethrow;
    }
  }

  // sign out
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
      locator<AppService>().refreshUserInfo(null);
      Get.offAll(LoginPage());
    } catch (error) {
      print(error.toString());
      return;
    }
  }

  Future updatePassword(
      {@required String oldPassword, String newPassword, String email}) async {
    try {
      User user;

      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: oldPassword);

      // AuthCredential credential =
      //     EmailAuthProvider.credential(email: email, password: newPassword);

      user = userCredential.user;
      // await user.reauthenticateWithCredential(credential);
      user.reload();
      await user.updatePassword(newPassword);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw UserNotFoundException();
      } else if (e.code == 'wrong-password') {
        throw WrongPasswordException();
      }
    } catch (e) {
      rethrow;
      // return e.message;
    }
  }
}

class UserNotFoundException implements Exception {
  UserNotFoundException();
}

class WrongPasswordException implements Exception {
  WrongPasswordException();
}

class WeakPasswordException implements Exception {
  WeakPasswordException();
}

class EmailAlreadyInUseException implements Exception {
  EmailAlreadyInUseException();
}
