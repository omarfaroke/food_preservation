import 'package:flutter/material.dart';
import 'package:food_preservation/ui/animation/fade_animation.dart';
import 'package:food_preservation/ui/widgets/custom_submit_button.dart';
import 'package:food_preservation/ui/widgets/widgets.dart';
import 'package:get/get.dart';
import 'package:reactive_forms/reactive_forms.dart';

import 'reset_password_controller.dart';

class ResetPasswordPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ResetPasswordController>(
        init: ResetPasswordController(),
        builder: (controller) {
          return SafeArea(
            child: Scaffold(
              body: ReactiveFormBuilder(
                  form: () => controller.form,
                  builder: (context, form, child) {
                    return FadeAnimation(
                      1.6,
                      TempletForm(
                        title: 'استعادة كلمة المرور',
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
                          _sizeBetween,
                          controller.isBusy
                              ? Loading()
                              : CustomSubmitButton(
                                  label: "ارسال",
                                  onPressed: () => controller.reset(),
                                ),
                          SizedBox(
                            height: 30,
                          ),
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
}
