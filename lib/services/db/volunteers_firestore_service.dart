import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_preservation/constants/constants.dart';
import 'package:food_preservation/models/user_model.dart';
import 'package:food_preservation/services/db/user_firestore_service.dart';
import 'package:food_preservation/util/enums.dart';
import 'package:get/get.dart';

class VolunteersFirestoreService extends GetxService {
  Stream<List<UserModel>> stream() {
    return Get.find<UserFirestoreService>()
        .usersStream()
        .map<List<UserModel>>((event) {
      List<UserModel> list = List();
      for (UserModel u in event) {
        if (u.type == UserType.Volunteers.index) {
          list.add(u);
        }
      }
      return list;
    });
  }
}
