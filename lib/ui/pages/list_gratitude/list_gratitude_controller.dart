import 'package:food_preservation/app/locator.dart';
import 'package:food_preservation/models/donation_food_model.dart';
import 'package:food_preservation/services/app_service.dart';
import 'package:food_preservation/services/db/donation_firestore_service.dart';
import 'package:get/get.dart';

class ListGratitudeController extends GetxController {
  Rx<List<DonationFoodModel>> listData = new Rx<List<DonationFoodModel>>();

  List<DonationFoodModel> get listModel {
    return listData.value.where((element) => element.status==StatusDonation.delivered).toList();
  }

  String get idRetaurant => locator<AppService>().currentUser.id;

  var _loading = true.obs;

  bool get loading => _loading.value;

  @override
  void onInit() {
    listData.bindStream(
        Get.find<DonationFirestoreService>().byRetaurantStream(idRetaurant));
    super.onInit();
    listData.listen((listData) {
      _loading.value = false;
      // update();
    });
  }
}
