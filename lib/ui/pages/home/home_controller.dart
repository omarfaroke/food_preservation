import 'package:food_preservation/app/locator.dart';
import 'package:food_preservation/models/user_model.dart';
import 'package:food_preservation/services/app_service.dart';
import 'package:food_preservation/services/authentication_service.dart';
import 'package:food_preservation/util/enums.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  @override
  void onInit() {
    super.onInit();
  }

  UserType get userType => locator<AppService>().userType;

  UserModel get user => locator<AppService>().currentUser;

  signOut() {
    Get.find<AuthenticationService>().signOut();
  }
}
