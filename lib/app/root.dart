import 'package:flutter/material.dart';
import 'package:food_preservation/services/app_service.dart';
import 'package:food_preservation/services/authentication_service.dart';
import 'package:food_preservation/ui/pages/home/home_page.dart';
import 'package:food_preservation/ui/pages/login/login_page.dart';
import 'package:get/get.dart';

import 'locator.dart';

class Root extends GetWidget<AuthenticationService> {
  @override
  Widget build(BuildContext context) {
    return GetX(
      // initState: (_) async {
      //  await Get.find<AppService>().init();
      // },

      builder: (_) {
        if (Get.find<AuthenticationService>().currentUser?.uid != null) {
          if (locator<AppService>().currentUser != null) {
            return HomePage();
          }
        }
        return LoginPage();
      },
    );
  }
}
