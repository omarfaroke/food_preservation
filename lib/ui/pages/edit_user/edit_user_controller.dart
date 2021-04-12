import 'dart:io';

import 'package:food_preservation/models/user_model.dart';
import 'package:food_preservation/services/db/user_firestore_service.dart';
import 'package:food_preservation/services/helper_service.dart';
import 'package:food_preservation/services/storge_services.dart';
import 'package:food_preservation/ui/widgets/toast_msg.dart';
import 'package:food_preservation/util/function_helpers.dart';
import 'package:get/get.dart';
import 'package:google_map_location_picker/google_map_location_picker.dart';
import 'package:reactive_forms/reactive_forms.dart';

class EditUserController extends GetxController {
  UserModel _user;

  EditUserController(UserModel user) {
    _user = user;

    setUpDefualtValue;
  }

  final _form = fb.group({
    'name': FormControl(
      validators: [
        Validators.required,
      ],
    ),
    'email': FormControl(
      validators: [
        Validators.required,
        Validators.email,
      ],
    ),
    'photo': FormControl(
      validators: [],
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
    form.updateValue({..._user.toMap()});
  }

  bool _isBusy = false;

  bool get isBusy => _isBusy;
  set isBusy(bool value) {
    _isBusy = value;
    update();
  }

  Future edit() async {
    print('edit');
    if (_form.valid) {
      //
      try {
        isBusy = true;

        Map mapFrom = _form.value;

        UserModel user = UserModel.fromMap(mapFrom);

        user.id = _user.id;
        user.status = _user.status;

        bool pathPhotoIsUrl = user.photo?.isURL ?? false;

        File imageFile;
        if (!pathPhotoIsUrl) {
          imageFile = mapFrom['photo'] != null ? File(mapFrom['photo']) : null;
        }

        user.type = _user.type;

        if (imageFile != null) {
          user.photo = await StorageService.uploadFile(
              'usersImages/${user.id}', imageFile);
        }

        await Get.find<UserFirestoreService>().updateUserInfo(user);
      } catch (e) {
        showSnackBar(
          title: "خطأ في التعديل",
          message: '',
        );

        isBusy = false;

        return;
      }

      showTextSuccess('تم تعديل البيانات بنجاح');

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

  Future<bool> deletePhoto(String value) async {
    return await StorageService.deleteFile(value);
  }
}
