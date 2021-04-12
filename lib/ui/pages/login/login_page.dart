import 'package:flutter/material.dart';
import 'package:food_preservation/ui/animation/fade_animation.dart';
import 'package:food_preservation/ui/pages/login/login_controller.dart';
import 'package:food_preservation/ui/pages/signup/sign_up_page.dart';
import 'package:food_preservation/ui/theme/app_colors.dart';
import 'package:food_preservation/ui/widgets/custom_submit_button.dart';
import 'package:food_preservation/ui/widgets/widgets.dart';
import 'package:get/get.dart';
import 'package:reactive_forms/reactive_forms.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginController>(
        init: LoginController(),
        builder: (controller) {
          return SafeArea(
            child: Scaffold(
              body: ReactiveFormBuilder(
                  form: () => controller.form,
                  builder: (context, form, child) {
                    return FadeAnimation(
                      1.6,
                      TempletForm(
                        title: 'تسجيل الدخول',
                        iconForm: 'assets/images/icon.png',
                        children: [
                          CustomTextField(
                            formControlName: 'email',
                            hintText: 'البريد الالكتروني',
                            prefixIcon: Icons.email,
                            validationMessages: (control) => {
                              ...validatorRequiredMs,
                              ValidationMessage.email:
                                  'صيغة البريد الاكتروني غير صحيحة'
                            },
                          ),
                          _sizeBetween,
                          CustomTextField(
                            formControlName: 'password',
                            hintText: 'كلمة المرور',
                            prefixIcon: Icons.vpn_key_rounded,
                            obscureText: true,
                            validationMessages: (control) => {
                              ...validatorRequiredMs,
                              ValidationMessage.minLength:
                                  'كملة المرور يجب ان لا تقل عن 6 احرف '
                            },
                          ),
                          _sizeBetween,
                          controller.isBusy
                              ? Loading()
                              : CustomSubmitButton(
                                  label: "دخول",
                                  onPressed: () => controller.login(),
                                ),
                          _sizeBetween,
                          TextButton(
                              onPressed: () => controller.resetPassword(),
                              child: Text(
                                'نسيت كلمة المرور',
                                style: TextStyle(
                                    fontFamily: 'DinNextLtW23',
                                    fontSize: 15.0,
                                    color: AppColors.primary_1),
                              )),
                          // _sizeBetween,
                          _buildRegster
                        ],
                      ),
                    );
                  }),
            ),
          );
        });
  }

  get _sizeBetween => SizedBox(
        height: 20,
      );

  get _buildRegster {
    return Column(
      children: [
        Text(
          'أو',
          style: TextStyle(
            fontFamily: 'DinNextLtW23',
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(30)),
            child: FlatButton(
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  "انشاء حساب جديد",
                  style: TextStyle(
                      fontFamily: 'DinNextLtW23',
                      fontSize: 15.0,
                      color: AppColors.primary_1),
                  textAlign: TextAlign.right,
                ),
              ),
              // color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              textColor: Colors.white,
              onPressed: () {
                Get.to(SignUpPage());
              },
            ),
          ),
        ),
      ],
    );
  }
}
