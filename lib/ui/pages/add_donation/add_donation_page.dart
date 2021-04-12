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

import 'add_donation_controller.dart';

class AddDonationPage extends StatelessWidget {
  const AddDonationPage({
    Key key,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    String title ='إضافة طلب تبرع';
    return GetBuilder<AddDonationController>(
      init: AddDonationController(),
      builder: (controller) => SafeArea(
          child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            title: Text(title),
            centerTitle: true,
          ),
          body: ReactiveFormBuilder(
            form: () => controller.form,
            builder: (context, form, child) {
              return FadeAnimation(
                1.6,
                TempletForm(
                  formCenter: false,
                  children: [
                    _sizeBetween,
                    _buildImage(),
                    _sizeBetween,
                    CustomTextField(
                      formControlName: 'description',
                      hintText: 'وصف الطعام',
                      prefixIcon: Icons.perm_identity,
                      validationMessages: (control) => {...validatorRequiredMs},
                      onSubmitted: () => form.focus('note'),
                    ),
                    _sizeBetween,
                    CustomTextField(
                      formControlName: 'note',
                      hintText: 'ملاحظات',
                      prefixIcon: Icons.perm_identity,
                      validationMessages: (control) => {...validatorRequiredMs},
                      onSubmitted: () => form.focus('phone'),
                    ),
                    _sizeBetween,
                    CustomTextField(
                      formControlName: 'phone',
                      hintText: ' رقم تلفون التواصل',
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
                    controller.isBusy
                        ? Loading()
                        : CustomSubmitButton(
                            label: "إرسال الطلب",
                            onPressed: () => controller.add(),
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
    AddDonationController controller = Get.find<AddDonationController>();

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

  _buildImage() {
    File imageFile;
    AddDonationController controller = Get.find<AddDonationController>();

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
