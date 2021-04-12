import 'package:food_preservation/models/user_model.dart';
import 'package:food_preservation/services/db/restaurant_firestore_service.dart';
import 'package:food_preservation/services/db/user_firestore_service.dart';
import 'package:food_preservation/services/db/volunteers_firestore_service.dart';
import 'package:food_preservation/ui/pages/add_user/add_user_page.dart';
import 'package:food_preservation/ui/pages/edit_user/edit_user_page.dart';
import 'package:food_preservation/ui/widgets/widgets.dart';
import 'package:food_preservation/util/enums.dart';
import 'package:get/get.dart';

class VolunteersManagementController extends GetxController {
  Rx<List<UserModel>> listParents = new Rx<List<UserModel>>();

  List<UserModel> get listModel => listParents.value;

  get add {
    Get.to(AddUserPage(userType: UserType.Volunteers));
  }

  var _loading = true.obs;

  bool get loading => _loading.value;

  @override
  void onInit() {
    listParents.bindStream(Get.find<VolunteersFirestoreService>().stream());
    super.onInit();
    listParents.listen((listData) {
      _loading.value = false;
      // update();
    });
  }

  delete(UserModel user) async {
    // String name = teacher.info.name;
    bool ok = await defaultDialog(
      title: 'حذف المتطوع',
      middleText: 'هل تريد حذف هذا المتطوع ؟',
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
      middleText: 'هل تريد $statusLabel هذا المتطوع ؟',
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
