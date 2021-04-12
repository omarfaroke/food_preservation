import 'dart:io';

import 'package:flutter/material.dart';
import 'package:food_preservation/models/user_model.dart';
import 'package:food_preservation/ui/animation/fade_animation.dart';
import 'package:food_preservation/ui/theme/app_colors.dart';
import 'package:food_preservation/ui/widgets/pick_Image_and_crop.dart';
import 'package:food_preservation/ui/widgets/widgets.dart';
import 'package:food_preservation/util/enums.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:reactive_forms/reactive_forms.dart';

import 'edit_user_controller.dart';

class EditUserPage extends StatelessWidget {
  const EditUserPage({
    Key key,
    @required this.user,
    this.justShow = false,
  }) : super(key: key);

  final UserModel user;
  final bool justShow;

  @override
  Widget build(BuildContext context) {
    bool canEdit = !justShow;
    String title = user.type == UserType.Restaurant.index
        ? ' بيانات المطعم'
        : 'بيانات المتطوع';
    return GetBuilder<EditUserController>(
      init: EditUserController(user),
      builder: (controller) => SafeArea(
          child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            title: !canEdit ? Text(title) : Text('تعديل $title'),
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
    EditUserController controller = Get.find<EditUserController>();

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
    EditUserController controller = Get.find<EditUserController>();

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
