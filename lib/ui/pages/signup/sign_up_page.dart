import 'dart:io';

import 'package:flutter/material.dart';
import 'package:food_preservation/ui/animation/fade_animation.dart';
import 'package:food_preservation/ui/theme/app_colors.dart';
import 'package:food_preservation/ui/widgets/custom_submit_button.dart';
import 'package:food_preservation/ui/widgets/pick_Image_and_crop.dart';
import 'package:food_preservation/ui/widgets/widgets.dart';
import 'package:food_preservation/util/enums.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:reactive_forms/reactive_forms.dart';

import 'sign_up_controller.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SignUpController>(
      init: SignUpController(),
      builder: (controller) => SafeArea(
          child: Scaffold(
        body: Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              body: ReactiveFormBuilder(
                form: () => controller.form,
                builder: (context, form, child) {
                  return FadeAnimation(
                    1.6,
                    TempletForm(
                      title: 'تسجيل',
                      formCenter: false,
                      children: [
                        _sizeBetween,
                        _buildImageUser(),
                        _sizeBetween,
                        _buildTypeUserList,
                        _sizeBetween,
                        CustomTextField(
                          formControlName: 'name',
                          hintText: 'الاسم',
                          prefixIcon: Icons.perm_identity,
                          validationMessages: (control) =>
                              {...validatorRequiredMs},
                          onSubmitted: () => form.focus('email'),
                        ),
                        _sizeBetween,
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
                        CustomTextField(
                          formControlName: 'confirmPassword',
                          hintText: ' تأكيد كلمة المرور',
                          prefixIcon: Icons.vpn_key_rounded,
                          obscureText: true,
                          validationMessages: (control) => {
                            ...validatorRequiredMs,
                            ValidationMessage.mustMatch:
                                'كلمة المرور غير متطابقة '
                          },
                        ),
                        _sizeBetween,
                        CustomTextField(
                          formControlName: 'phone',
                          hintText: ' رقم التلفون',
                          prefixIcon: Icons.phone_android,
                          isNumber: true,
                          validationMessages: (control) => {
                            ...validatorRequiredMs,
                          },
                        ),
                        // _sizeBetween,
                        // CustomTextField(
                        //   formControlName: 'note',
                        //   hintText: ' ملاحظات',
                        //   prefixIcon: Icons.note,
                        //   validationMessages: (control) => {
                        //     ...validatorRequiredMs,
                        //   },
                        //   minLines: 2,
                        //   maxLines: 4,
                        // ),
                        _sizeBetween,
                        CustomTextField(
                          formControlName: 'address',
                          hintText: ' العنوان',
                          prefixIcon: Icons.location_city_sharp,
                          validationMessages: (control) => {
                            ...validatorRequiredMs,
                          },
                          minLines: 2,
                          maxLines: 4,
                        ),
                        _sizeBetween,
                        buildButtonLocation,
                        _sizeBetween,
                        controller.isBusy
                            ? Loading()
                            : CustomSubmitButton(
                                label: "تسجيل",
                                onPressed: () => controller.signUp(),
                              ),
                        SizedBox(
                          height: 30,
                        ),
                      ],
                    ),
                  );
                },
              ),
            )),
      )),
    );
  }

  get _sizeBetween => SizedBox(
        height: 20,
      );

  get _buildTypeUserList {
    return ReactiveValueListenableBuilder(
        formControlName: 'type',
        builder: (context, controllerForm, child) {
          return Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'تسجيل كـ : ',
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'DinNextLtW23',
                  ),
                ),
              ),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ChoiceChip(
                      label: Text('مطعم'),
                      avatar: Icon(Icons.restaurant),
                      selected:
                          controllerForm.value == UserType.Restaurant.index,
                      onSelected: (value) {
                        if (value) {
                          controllerForm.value = UserType.Restaurant.index;
                        }
                      },
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    ChoiceChip(
                      label: Text('متطوع'),
                      avatar: Icon(Icons.person_sharp),
                      selected:
                          controllerForm.value == UserType.Volunteers.index,
                      onSelected: (value) {
                        if (value) {
                          controllerForm.value = UserType.Volunteers.index;
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        });
  }

  Widget get buildButtonLocation {
    SignUpController controller = Get.find<SignUpController>();

    return ReactiveValueListenableBuilder(
        formControlName: 'location',
        builder: (context, controllerForm, child) {
          String location = controllerForm.value;

          return 1 == 1
              ? GFButton(
                  onPressed: () => controller.showMapView(),
                  text: location == null
                      ? 'الموقع على الخريطة'
                      : location.substring(1, 15),
                  icon: Icon(Icons.map),
                  size: GFSize.LARGE,
                  type: GFButtonType.outline2x,
                  // type: GFButtonType.transparent,
                  shape: GFButtonShape.pills,
                  color: Colors.grey,
                  textStyle: TextStyle(
                    fontSize: 16,
                    color: AppColors.primary_1,
                  ),
                  fullWidthButton: true,
                  // child: Text(''),
                )
              : Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    color: AppColors.primary_3,
                  ),
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.map,
                        color: AppColors.lightAccent,
                      ),
                      Expanded(
                        child: Text(
                          location == null ? 'الموقع على الخريطة' : location,
                          style: TextStyle(
                              fontSize: 14, color: AppColors.lightAccent),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ));
        });
  }

  _buildImageUser() {
    File imageFile;
    SignUpController controller = Get.find<SignUpController>();

    return ReactiveValueListenableBuilder(
        formControlName: 'photo',
        builder: (context, controllerForm, child) {
          return controllerForm.value != null
              ? GFImageOverlay(
                  height: Get.height / 6,
                  width: Get.height / 6,
                  shape: BoxShape.circle,
                  image: Image.file(File(controllerForm.value)).image,
                  boxFit: BoxFit.cover,
                )
              : InkWell(
                  onTap: () async {
                    imageFile = await pickImage();
                    controller.form.control('photo').value = imageFile?.path ?? null;
                  },
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Container(
                        child: Icon(
                          Icons.photo_camera,
                          size: Get.height / 10,
                        ),
                      )),
                );
        });
  }
}
