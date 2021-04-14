import 'dart:io';

import 'package:food_preservation/app/locator.dart';
import 'package:food_preservation/models/donation_food_model.dart';
import 'package:food_preservation/models/user_model.dart';
import 'package:food_preservation/services/app_service.dart';
import 'package:food_preservation/services/db/donation_firestore_service.dart';
import 'package:food_preservation/services/helper_service.dart';
import 'package:food_preservation/ui/widgets/toast_msg.dart';
import 'package:food_preservation/util/function_helpers.dart';
import 'package:get/get.dart';
import 'package:google_map_location_picker/google_map_location_picker.dart';
import 'package:reactive_forms/reactive_forms.dart';

class AddDonationController extends GetxController {
  AddDonationController() {
    setUpDefualtValue;
  }

  UserModel currentUser = locator<AppService>().currentUser;

  final _form = fb.group({
    'description': FormControl(
      validators: [
        Validators.required,
      ],
    ),
    'photo': FormControl(
      validators: [
        Validators.required,
      ],
    ),
    'address': FormControl(
      validators: [
        Validators.required,
      ],
    ),
    'location': FormControl(
      validators: [],
    ),
    'note': FormControl(
      validators: [],
    ),
    'phone': FormControl(
      validators: [
        Validators.required,
        Validators.number,
      ],
    ),
  }, []);

  FormGroup get form => _form;

  get setUpDefualtValue {
    form.updateValue({
      'location': currentUser.location,
      'phone': currentUser.phone,
      'address': currentUser.address
    });
  }

  bool _isBusy = false;

  bool get isBusy => _isBusy;
  set isBusy(bool value) {
    _isBusy = value;
    update();
  }

  Future add() async {
    print('add');
    if (_form.valid) {
      //
      try {
        isBusy = true;

        Map mapFrom = _form.value;

        DonationFoodModel donation = DonationFoodModel.fromMap(mapFrom);

        File imageFile =
            mapFrom['photo'] != null ? File(mapFrom['photo']) : null;

        donation.dateAdd = DateTime.now().millisecondsSinceEpoch;
        donation.dateUpdate = DateTime.now().millisecondsSinceEpoch;
        donation.idRestaurant = currentUser.id;
        donation.status = StatusDonation.newDonation;

        await Get.find<DonationFirestoreService>().addDonation(
          donation,
          imageFile: imageFile,
        );
      } catch (e) {
        showSnackBar(
          title: "خطأ في إضافة البيانات",
          message: '',
        );

        isBusy = false;

        return;
      }

      showTextSuccess('تم إضافة البيانات بنجاح');

      isBusy = false;
      afterSuccessAdd;
    } else {
      _form.markAllAsTouched();

      return false;
    }

    return true;
  }

  get afterSuccessAdd {
    Get.back();
  }

  Future showMapView() async {
    LocationResult result = await HelperService.showMapView();

    if (result != null) {
      form.control('location').value = latLngToString(result.latLng);
    } else {
      form.control('location').value = null;
    }

    return result;
  }
}
