import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_preservation/constants/constants.dart';
import 'package:food_preservation/models/donation_food_model.dart';
import 'package:get/get.dart';

import '../storge_services.dart';

class DonationFirestoreService extends GetxService {
  final CollectionReference _donationCollectionReference =
      FirebaseFirestore.instance.collection('donation');

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

  Future<bool> updateDonation(DonationFoodModel donation) async {
    try {
      await _donationCollectionReference
          .doc(donation.id)
          .update(donation.toMap()..addAll(updatedAtField));
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> updateDonationStatus({String id, String status}) async {
    try {
      await _donationCollectionReference
          .doc(id)
          .update({'status': status}..addAll(updatedAtField));
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<DonationFoodModel> getDonation(String id) async {
    try {
      DocumentSnapshot doc = await _donationCollectionReference.doc(id).get();
      if (doc.exists) {
        return DonationFoodModel.fromMap(doc.data());
      }

      return null;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Stream<List<DonationFoodModel>> stream() {
    return _donationCollectionReference
        .orderBy(updatedAtKey, descending: true)
        .snapshots(includeMetadataChanges: true)
        .map((QuerySnapshot query) {
      List<DonationFoodModel> retVal = List();
      query.docs.forEach((element) {
        Map mapData = element.data();
        mapData['id'] = element.id;
        retVal.add(DonationFoodModel.fromMap(mapData));
      });
      return retVal;
    });
  }

  Stream<List<DonationFoodModel>> byRetaurantStream(String id) {
    return _donationCollectionReference
        .where('idRestaurant', isEqualTo: id)
        .orderBy(updatedAtKey, descending: true)
        .snapshots(includeMetadataChanges: true)
        .map((QuerySnapshot query) {
      List<DonationFoodModel> retVal = List();
      query.docs.forEach((element) {
        Map mapData = element.data();
        mapData['id'] = element.id;
        retVal.add(DonationFoodModel.fromMap(mapData));
      });
      return retVal;
    });
  }

  Stream<List<DonationFoodModel>> byVolunteerStream(String id) {
    return _donationCollectionReference
        .where('idVolunteer', isEqualTo: id)
        .orderBy(updatedAtKey, descending: true)
        .snapshots(includeMetadataChanges: true)
        .map((QuerySnapshot query) {
      List<DonationFoodModel> retVal = List();
      query.docs.forEach((element) {
        Map mapData = element.data();
        mapData['id'] = element.id;
        retVal.add(DonationFoodModel.fromMap(mapData));
      });
      return retVal;
    });
  }
}
