import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:food_preservation/models/donation_food_model.dart';
import 'package:food_preservation/models/user_model.dart';
import 'package:food_preservation/services/db/donation_firestore_service.dart';
import 'package:food_preservation/services/db/user_firestore_service.dart';
import 'package:food_preservation/ui/pages/edit_user/edit_user_page.dart';
import 'package:food_preservation/ui/pages/volunteer_management/volunteer_management_page.dart';
import 'package:food_preservation/ui/theme/app_colors.dart';
import 'package:food_preservation/ui/widgets/widgets.dart';
import 'package:get/get.dart';
import 'package:reactive_forms/reactive_forms.dart';

class ListDonationController extends GetxController {
  String _donationByRestaurant;
  String _donationByVolunteer;
  List<String> _donationByStatus;

  ListDonationController({
    String donationByRestaurant,
    String donationByVolunteer,
    List<String> donationByStatus,
  }) {
    _donationByRestaurant = donationByRestaurant;
    _donationByVolunteer = donationByVolunteer;
    _donationByStatus = donationByStatus;
  }

  Rx<List<DonationFoodModel>> listData = new Rx<List<DonationFoodModel>>();

  List<DonationFoodModel> get listModel {
    if (_donationByStatus.isEmpty) {
      return listData.value;
    }
    return listData.value
        .where((element) => _donationByStatus.contains(element.status))
        .toList();
  }

  var _loading = true.obs;

  bool get loading => _loading.value;

  @override
  void onInit() {
    if (_donationByRestaurant != null) {
      listData.bindStream(Get.find<DonationFirestoreService>()
          .byRetaurantStream(_donationByRestaurant));
    } else if (_donationByVolunteer != null) {
      listData.bindStream(Get.find<DonationFirestoreService>()
          .byVolunteerStream(_donationByVolunteer));
    } else {
      listData.bindStream(Get.find<DonationFirestoreService>().stream());
    }

    super.onInit();
    listData.listen((listData) {
      _loading.value = false;
      // update();
    });
  }

  changeStatus(DonationFoodModel donation, String status) async {
    // String statusLabel;
    // if (status == StatusDonation.accept) {
    //   statusLabel = 'قبول';
    // }

    // bool ok = await defaultDialog(
    //   title: statusLabel,
    //   middleText: 'هل تريد $statusLabel هذا الطلب ؟',
    // );

    bool ok = true;
    if (ok) {
      donation.status = status;
      await Get.find<DonationFirestoreService>().updateDonation(donation);
      showTextSuccess('تم التعديل بنجاح');
      // update();
    }
  }

  refuseDonation(DonationFoodModel donation) async {
    print('refuseDonation');

    String result = await Get.bottomSheet<String>(
      Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          color: Colors.white,
          height: 200,
          padding: EdgeInsets.all(18),
          child: ReactiveFormBuilder(
              form: () => fb.group({
                    'refusingReason':
                        FormControl(validators: [Validators.required])
                  }),
              builder: (context, form, child) {
                return Column(
                  children: [
                    CustomTextField(
                      formControlName: 'refusingReason',
                      hintText: 'سبب الرفض',
                      prefixIcon: Icons.info,
                      validationMessages: (control) => {...validatorRequiredMs},
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        FlatButton(
                          onPressed: () => Get.back(
                              result: form.control('refusingReason').value),
                          child: Text(
                            'ارسال',
                            style: TextStyle(color: Colors.white),
                          ),
                          color: AppColors.lightPrimary,
                        ),
                        FlatButton(
                          onPressed: () => Get.back(result: null),
                          child: Text(
                            'الغاء',
                            style: TextStyle(color: AppColors.lightPrimary),
                          ),
                        ),
                      ],
                    )
                  ],
                );
              }),
        ),
      ),
    );

    // print(result);

    if (result != null) {
      donation.status = StatusDonation.refuse;
      donation.refusingReason = result;
      await Get.find<DonationFirestoreService>().updateDonation(donation);
    }
  }

  showSelectVolunteer(DonationFoodModel donation) async {
    print('showSelectVolunteer');

    UserModel volunteer = await Get.to(VolunteersManagementPage(
      showSelected: true,
    ));

    if (volunteer != null) {
      donation.idVolunteer = volunteer.id;
      donation.status = StatusDonation.underDelivery;
      await Get.find<DonationFirestoreService>().updateDonation(donation);
      showTextSuccess('تم التعديل بنجاح');
    }
  }

  showIfofRestaurant(String id) async {
    UserModel user = await Get.find<UserFirestoreService>().getUser(id);

    if (user != null) {
      Get.to(EditUserPage(
        user: user,
        justShow: true,
      ));
    }
  }

  showInfoVolunteer(String id) async {
    UserModel user = await Get.find<UserFirestoreService>().getUser(id);

    if (user != null) {
      Get.to(EditUserPage(
        user: user,
        justShow: true,
      ));
    }
  }
}
