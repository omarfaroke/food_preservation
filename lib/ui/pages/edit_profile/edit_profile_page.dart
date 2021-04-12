import 'dart:io';

import 'package:flutter/material.dart';
import 'package:food_preservation/models/user_model.dart';
import 'package:food_preservation/ui/animation/fade_animation.dart';
import 'package:food_preservation/ui/theme/app_colors.dart';
import 'package:food_preservation/ui/widgets/custom_submit_button.dart';
import 'package:food_preservation/ui/widgets/pick_Image_and_crop.dart';
import 'package:food_preservation/ui/widgets/widgets.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:reactive_forms/reactive_forms.dart';

import 'edit_profile_controller.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({
    Key key,
    @required this.user,
    this.justShow = false,
  }) : super(key: key);

  final UserModel user;
  final bool justShow;

  @override
  Widget build(BuildContext context) {
    bool canEdit = !justShow;
    return GetBuilder<EditProfileController>(
      init: EditProfileController(user),
      builder: (controller) => SafeArea(
          child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            title: !canEdit
                ? Text(' البيانات الشخصية')
                : Text('تعديل البيانات الشخصية'),
            centerTitle: true,
            actions: [
              justShow
                  ? canEdit
                      ? IconButton(
                          icon: Icon(Icons.cancel),
                          onPressed: () {
                            canEdit = false;
                            controller.update();
                          })
                      : IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            canEdit = true;
                            controller.update();
                          })
                  : SizedBox()
            ],
          ),
          body: ReactiveFormBuilder(
            form: () => controller.form,
            builder: (context, form, child) {
              return FadeAnimation(
                1.6,
                TempletForm(
                  formCenter: false,
                  disable: !canEdit,
                  children: [
                    _sizeBetween,
                    _buildImageUser(),
                    _sizeBetween,
                    CustomTextField(
                      formControlName: 'name',
                      hintText: 'الاسم',
                      prefixIcon: Icons.perm_identity,
                      validationMessages: (control) => {...validatorRequiredMs},
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
                      readOnly: true,
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
                    _pass,
                    _sizeBetween,
                    _sizeBetween,
                    Visibility(
                      visible: canEdit,
                      child: controller.isBusy
                          ? Loading()
                          : CustomSubmitButton(
                              label: "تعديل",
                              onPressed: () => controller.edit(),
                            ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      )),
    );
  }

  get _sizeBetween => SizedBox(
        height: 20,
      );

  Widget get buildButtonLocation {
    EditProfileController controller = Get.find<EditProfileController>();

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

  get _pass {
    return ExpansionTile(
      title: Row(
        children: [
          Text('تعديل كلمة المرور :'),
          ReactiveSwitch.adaptive(
            activeColor: AppColors.lightPrimary,
            formControlName: 'editPass',
          ),
        ],
      ),
      children: [
        ReactiveStatusListenableBuilder(
            formControlName: 'editPass',
            builder: (context, form, child) {
              return DisableWidget(
                condition: !form.value,
                child: Column(
                  children: [
                    _sizeBetween,
                    CustomTextField(
                      formControlName: 'oldPassword',
                      hintText: 'كلمة المرور السابقة',
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
                      formControlName: 'password',
                      hintText: ' كلمة المرور الجديدة',
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
                        ValidationMessage.mustMatch: 'كلمة المرور غير متطابقة '
                      },
                    ),
                  ],
                ),
              );
            }),
      ],
    );
  }

  _buildImageUser() {
    File imageFile;
    EditProfileController controller = Get.find<EditProfileController>();

    return ReactiveValueListenableBuilder(
        formControlName: 'photo',
        builder: (context, controllerForm, child) {
          String value = controllerForm.value;
          bool isUrl = value?.isURL ?? false;

          return value != null
              ? Stack(
                  alignment: AlignmentDirectional.center,
                  children: [
                    GFImageOverlay(
                      height: Get.height / 6,
                      width: Get.height / 6,
                      shape: BoxShape.circle,
                      image: isUrl
                          ? Image.network(controllerForm.value).image
                          : Image.file(File(controllerForm.value)).image,
                      boxFit: BoxFit.cover,
                    ),
                    Positioned(
                        top: 1,
                        left: Get.height / 11,
                        child: IconButton(
                            icon: Icon(Icons.remove_circle),
                            onPressed: () {
                              if (isUrl) {
                                controller.deletePhoto(value);
                              }
                              controllerForm.value = null;
                            })),
                  ],
                )
              : InkWell(
                  onTap: () async {
                    imageFile = await pickImage();
                    controller.form.control('photo').value =
                        imageFile?.path ?? null;
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
