import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_preservation/constants/constants.dart';
import 'package:food_preservation/models/user_model.dart';
import 'package:get/get.dart';

class UserFirestoreService extends GetxService {
  final CollectionReference _usersCollectionReference =
      FirebaseFirestore.instance.collection('users');

  Future<bool> createUser(UserModel user) async {
    try {
      await _usersCollectionReference
          .doc(user.id)
          .set(user.toMap()..addAll(updatedAtField));
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> updateUserInfo(UserModel user) async {
    await _usersCollectionReference
        .doc(user.id)
        .set(user.toMap()..addAll(updatedAtField));
    return true;
  }

  Future<bool> updateUserStatus(String id, String status) async {
    try {
      await _usersCollectionReference
          .doc(id)
          .update({'status': status}..addAll(updatedAtField));
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<UserModel> getUser(String uid) async {
    try {
      DocumentSnapshot userData =
          await _usersCollectionReference.doc(uid).get();
      if (userData.exists) {
        return UserModel.fromMap(userData.data());
      }

      return null;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<bool> deleteUser(String uid) async {
    try {
      await _usersCollectionReference.doc(uid).delete();

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Stream<List<UserModel>> usersStream({int userType}) {
    return _usersCollectionReference
        // .where('type', isEqualTo: userType) // notWorking ! TODO:
        .orderBy(updatedAtKey, descending: true)
        .snapshots(includeMetadataChanges: true)
        .map((QuerySnapshot query) {
      List<UserModel> retVal = List();
      query.docs.forEach((element) {
        Map mapData = element.data();
        mapData['id'] = element.id;
        retVal.add(UserModel.fromMap(mapData));
      });
      return retVal;
    });
  }

  Future<List<UserModel>> usersFuture({int userType}) async {
    try {
      QuerySnapshot listData = await _usersCollectionReference
          .where('type', isEqualTo: userType)
          .orderBy(updatedAtKey, descending: true)
          .get();
      List<UserModel> retVal = List();
      for (QueryDocumentSnapshot doc in listData.docs) {
        Map mapData = doc.data();
        mapData['id'] = doc.id;
        retVal.add(UserModel.fromMap(mapData));
      }
      return retVal;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<List<UserModel>> usersFromListId({List<String> listId}) async {
    try {
      List<UserModel> retVal = List();
      for (String id in listId) {
        UserModel user = await getUser(id);
        if (user != null) {
          retVal.add(user);
        }
      }

      return retVal;
    } catch (e) {
      print(e);
      return null;
    }
  }
}
