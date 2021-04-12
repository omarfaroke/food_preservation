import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:food_preservation/ui/theme/app_colors.dart';
import 'package:get/get.dart';

showTextSuccess(String msg, {Duration duration})  {
  BotToast.showText(text: msg, duration: duration ?? Duration(seconds: 2));
}

showTextError(String errorMsg) {
  BotToast.showText(
    text: errorMsg,
    contentColor: Colors.red,
  );
}

get showSuccessEditForm {
  showTextSuccess('تم التعديل بنجاح');
}

get showSuccessAddRowInForm {
  showTextSuccess('تم اضافة البيانات بنجاح');
}

DateTime backButtonPressedTime;

bool showToastPressBackAgainToExit() {
  DateTime currentTime = DateTime.now();

  //Statement 1 Or statement2
  bool backButton = backButtonPressedTime == null ||
      currentTime.difference(backButtonPressedTime) > Duration(seconds: 2);

  if (backButton) {
    backButtonPressedTime = currentTime;
    BotToast.showText(
      text: "اضغط مرة اخرى للتأكيد ",
    );
    return false;
  }

  return true;
}

showSnackBar({String title, String message}) {
  Get.rawSnackbar(
    titleText: Directionality(
        textDirection: TextDirection.rtl,
        child: Text(
          title,
          style: TextStyle(color: AppColors.lightTextButton),
        )),
    messageText: Directionality(
        textDirection: TextDirection.rtl,
        child: Text(
          message,
          style: TextStyle(color: AppColors.lightTextButton),
        )),
    snackPosition: SnackPosition.BOTTOM,
  );
}

Future<bool> defaultDialog(
    {String confirmButtonLable = 'نعم',
    String cancelButtonLable = 'إلغاء',
    String title,
    String middleText,
    bool barrierDismissible = false}) async {
  return await Get.defaultDialog(
      barrierDismissible: barrierDismissible,
      title: title ?? '',
      middleText: middleText ?? '',
      actions: [
        FlatButton(
          onPressed: () => Get.back(result: false),
          child: Text(
            cancelButtonLable,
            style: TextStyle(color: AppColors.lightPrimary),
          ),
        ),
        FlatButton(
          onPressed: () => Get.back(result: true),
          child: Text(
            confirmButtonLable,
            style: TextStyle(color: Colors.white),
          ),
          color: AppColors.lightPrimary,
        ),
      ]);
}
