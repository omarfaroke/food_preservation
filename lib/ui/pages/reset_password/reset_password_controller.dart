import 'package:food_preservation/services/authentication_service.dart';
import 'package:food_preservation/ui/widgets/toast_msg.dart';
import 'package:get/get.dart';
import 'package:reactive_forms/reactive_forms.dart';

class ResetPasswordController extends GetxController {
  FormGroup _form;

  get setupForm {
    _form = fb.group({
      'email': FormControl(
        validators: [
          Validators.required,
          Validators.email,
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

  Future reset() async {
    print('reset');
    if (_form.valid) {
      //
      isBusy = true;

      Map mapFrom = _form.value;

      String email = mapFrom['email'];

      try {
        await Get.find<AuthenticationService>()
            .sendPasswordResetEmail(email: email);
      } on UserNotFoundException catch (e) {
        showTextError("البريد الالكتروني الذي ادخلته غير مسجل لدينا !");
        isBusy = false;
        return;
      } catch (e) {
        isBusy = false;
        showTextError("خطأ في اعادة كلمة المرور");
        return;
      }

      isBusy = false;
      showTextSuccess('تم ارسال رابط استعادة كلمة المرور الى بريدك الالكتروني',
          duration: Duration(seconds: 3));

      await Future.delayed(Duration(seconds: 1));
      Get.back();
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
