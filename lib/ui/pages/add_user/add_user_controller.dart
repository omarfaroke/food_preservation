import 'dart:io';

import 'package:food_preservation/models/user_model.dart';
import 'package:food_preservation/services/authentication_service.dart';
import 'package:food_preservation/services/helper_service.dart';
import 'package:food_preservation/ui/widgets/toast_msg.dart';
import 'package:food_preservation/util/enums.dart';
import 'package:food_preservation/util/function_helpers.dart';
import 'package:get/get.dart';
import 'package:google_map_location_picker/google_map_location_picker.dart';
import 'package:reactive_forms/reactive_forms.dart';

class AddUserController extends GetxController {
  UserType _userType;

  AddUserController(UserType userType) {
    _userType = userType;
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

  bool _isBusy = false;

  bool get isBusy => _isBusy;
  set isBusy(bool value) {
    _isBusy = value;
    update();
  }

  String defaultPassword = '123456';

  Future add() async {
    print('add');
    if (_form.valid) {
      //
      try {
        isBusy = true;

        Map mapFrom = _form.value;

        UserModel user = UserModel.fromMap(mapFrom);
        String password = defaultPassword;

        File imageFile =
            mapFrom['photo'] != null ? File(mapFrom['photo']) : null;

        user.type = _userType.index;
        user.status = Status.approve;

        String id = await Get.find<AuthenticationService>().signUpWithEmail(
          email: user.email,
          password: password,
          user: user,
          imageFile: imageFile,
          newUserFromAdmin: true,
        );
      } catch (e) {
        if (e is EmailAlreadyInUseException) {
          showSnackBar(
              title: "خطأ في التسجيل",
              message: "البريد المستخدم موجود مسبقاً !");
        } else {
          showSnackBar(
            title: "خطأ في التسجيل",
            message: '',
          );
        }
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
