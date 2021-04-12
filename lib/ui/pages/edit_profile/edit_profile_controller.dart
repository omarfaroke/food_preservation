import 'dart:io';

import 'package:food_preservation/models/user_model.dart';
import 'package:food_preservation/services/authentication_service.dart';
import 'package:food_preservation/services/db/user_firestore_service.dart';
import 'package:food_preservation/services/helper_service.dart';
import 'package:food_preservation/services/storge_services.dart';
import 'package:food_preservation/ui/widgets/toast_msg.dart';
import 'package:food_preservation/util/enums.dart';
import 'package:food_preservation/util/function_helpers.dart';
import 'package:get/get.dart';
import 'package:google_map_location_picker/google_map_location_picker.dart';
import 'package:reactive_forms/reactive_forms.dart';

class EditProfileController extends GetxController {
  UserModel _user;

  EditProfileController(UserModel user) {
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
    'oldPassword': FormControl(
      value: '123456',
      validators: [
        Validators.required,
        Validators.minLength(6),
      ],
    ),
    'password': FormControl(
      value: '123456',
      validators: [
        Validators.required,
        Validators.minLength(6),
      ],
    ),
    'confirmPassword': FormControl(
      value: '123456',
      validators: [
        Validators.required,
      ],
    ),
    'editPass': FormControl<bool>(
      value: false,
      validators: [],
    ),
  }, [
    Validators.mustMatch('password', 'confirmPassword'),
  ]);

  FormGroup get form => _form;

  get setUpDefualtValue {
    form.updateValue({
      ..._user.toMap(),
      'editPass': false,
      'oldPassword': '123456',
      'password': '123456',
      'confirmPassword': '123456',
    });
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

        if (_form.control('editPass').value) {
          await Get.find<AuthenticationService>().updatePassword(
            oldPassword: mapFrom['oldPassword'],
            newPassword: mapFrom['password'],
            email: user.email,
          );
        }

        user.id = _user.id;
        user.status = _user.status;

        bool pathPhotoIsUrl = user.photo?.isURL ?? false;

        File imageFile;
        if (!pathPhotoIsUrl) {
          imageFile = mapFrom['photo'] != null ? File(mapFrom['photo']) : null;
        }

        user.type = _user.type;
        user.status = _user.status;

        if (imageFile != null) {
          user.photo = await StorageService.uploadFile(
              'usersImages/${user.id}', imageFile);
        }

        await Get.find<UserFirestoreService>().updateUserInfo(user);
      } on WrongPasswordException catch (e) {
        showSnackBar(
          title: "كلمة المرور غير صحيحة",
          message: '',
        );

        isBusy = false;
        return;
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
