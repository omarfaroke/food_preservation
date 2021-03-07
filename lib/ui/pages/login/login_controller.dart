import 'package:food_preservation/services/authentication_service.dart';
import 'package:food_preservation/ui/widgets/toast_msg.dart';
import 'package:get/get.dart';
import 'package:reactive_forms/reactive_forms.dart';

class LoginController extends GetxController {
  FormGroup _form;

  get setupForm {
    _form = fb.group({
      'email': FormControl(
        validators: [
          Validators.required,
        ],
      ),
      'password': FormControl(
        validators: [
          Validators.required,
          Validators.minLength(6),
        ],
      ),
    });
  }

  get form => _form;

  bool _isBusy = false;

  bool get isBusy => _isBusy;
  set isBusy(bool value) {
    _isBusy = value;
    update();
  }

  Future login() async {
    print('login');
    if (_form.valid) {
      //
      isBusy = true;

      Map mapFrom = _form.value;

      String email = mapFrom['email'];
      String password = mapFrom['password'];

      try {
        await Get.find<AuthenticationService>()
            .loginWithEmail(email: email, password: password);
      } catch (e) {
        showSnackBar(
          title: "خطأ في تسجيل الدخول",
          message: "تأكد من البريد الالكتروني وكلمة المرور !",
        );

        showTextError("خطأ في تسجيل الدخول");

        isBusy = false;

        return;
      }

      showTextSuccess('تم تسجيل الدخول بنجاح');

      isBusy = false;
    } else {
      _form.markAllAsTouched();

      return false;
    }

    return true;
  }

  @override
  void onInit() {
    super.onInit();
    setupForm;
  }
}
