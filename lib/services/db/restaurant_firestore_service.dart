import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_preservation/constants/constants.dart';
import 'package:food_preservation/models/donation_food_model.dart';
import 'package:food_preservation/models/user_model.dart';
import 'package:food_preservation/services/db/user_firestore_service.dart';
import 'package:food_preservation/util/enums.dart';
import 'package:get/get.dart';

import '../storge_services.dart';

class RestaurantFirestoreService extends GetxService {
  final CollectionReference _donationCollectionReference =
      FirebaseFirestore.instance.collection('donation');

  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  Future<bool> addDonation(DonationFoodModel donation, {File imageFile}) async {
    QuerySnapshot docs = await _donationCollectionReference.get();
    donation.number = (docs.docs.length + 1).toString();
    donation.id = donation.number;

    if (imageFile != null) {
      donation.photo = await StorageService.uploadFile(
          'donationsImages/${donation.id}', imageFile);
    }

    await _donationCollectionReference
        .doc(donation.id)
        .set(donation.toMap()..addAll(updatedAtField));

    return true;
  }

  Stream<List<UserModel>> stream() {
    return Get.find<UserFirestoreService>()
        .usersStream()
        .map<List<UserModel>>((event) {
      List<UserModel> list = List();
      for (UserModel u in event) {
        if (u.type == UserType.Restaurant.index) {
          list.add(u);
        }
      }
      return list;
    });
  }
}
