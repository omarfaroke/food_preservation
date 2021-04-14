import 'package:food_preservation/models/user_model.dart';
import 'package:food_preservation/services/db/restaurant_firestore_service.dart';
import 'package:food_preservation/services/db/user_firestore_service.dart';
import 'package:food_preservation/ui/pages/add_user/add_user_page.dart';
import 'package:food_preservation/ui/pages/edit_user/edit_user_page.dart';
import 'package:food_preservation/ui/widgets/widgets.dart';
import 'package:food_preservation/util/enums.dart';
import 'package:get/get.dart';

class RestaurantsManagementController extends GetxController {
  Rx<List<UserModel>> listData = new Rx<List<UserModel>>();

  List<UserModel> get listModel => listData.value;

  get add {
    Get.to(AddUserPage(userType: UserType.Restaurant));
  }

  var _loading = true.obs;

  bool get loading => _loading.value;

  @override
  void onInit() {
    listData
        .bindStream(Get.find<RestaurantFirestoreService>().stream());
    super.onInit();
    listData.listen((listData) {
      _loading.value = false;
      // update();
    });
  }

  delete(UserModel user) async {
    // String name = teacher.info.name;
    bool ok = await defaultDialog(
      title: 'حذف المطعم',
      middleText: 'هل تريد حذف هذا المطعم ؟',
    );

    if (ok) {
      await Get.find<UserFirestoreService>().deleteUser(user.id);
      showTextSuccess('تم الحذف بنجاح');
      // update();
    }
  }

  changeStatus(UserModel user, bool status) async {
    String statusLabel = status ? 'تفعيل' : 'الغاء تفعيل';
    bool ok = await defaultDialog(
      title: statusLabel,
      middleText: 'هل تريد $statusLabel هذا المطعم ؟',
    );

    if (ok) {
      await Get.find<UserFirestoreService>().updateUserStatus(
          user.id, status ? Status.approve : Status.notApprove);
      showTextSuccess('تم التعديل بنجاح');
      // update();
    }
  }

  edit(UserModel user) async {
    await Get.to(EditUserPage(
      user: user,
    ));
  }

  selected(UserModel user) {
    Get.back(result: user);
  }
}
