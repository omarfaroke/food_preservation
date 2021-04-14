import 'package:flutter/material.dart';
import 'package:food_preservation/app/locator.dart';
import 'package:food_preservation/services/app_service.dart';
import 'package:food_preservation/ui/pages/add_donation/add_donation_controller.dart';
import 'package:food_preservation/ui/pages/add_donation/add_donation_page.dart';
import 'package:food_preservation/ui/pages/list_donation/list_donation_page.dart';
import 'package:food_preservation/ui/pages/list_gratitude/list_gratitude_page.dart';
import 'package:food_preservation/ui/pages/restaurant_management/restaurants_management_page.dart';
import 'package:food_preservation/ui/pages/volunteer_management/volunteer_management_page.dart';
import 'package:food_preservation/ui/theme/app_colors.dart';
import 'package:food_preservation/ui/widgets/drawer_app.dart';
import 'package:food_preservation/ui/widgets/widgets.dart';
import 'package:food_preservation/util/enums.dart';
import 'package:get/get.dart';

import 'home_controller.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
        init: HomeController(),
        builder: (controller) {
          return SafeArea(
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Scaffold(
                drawer: AppDrawer(),
                appBar: AppBar(
                  title: Text('الرئيسية'),
                  centerTitle: true,
                ),
                body: Center(
                  child: Container(
                    padding: EdgeInsets.all(16),
                    child: buildHomeBody,
                  ),
                ),
              ),
            ),
          );
        });
  }

  Widget get buildHomeBody {
    final controller = Get.find<HomeController>();

    switch (controller.userType) {
      case UserType.Admin:
        return adminHome();
      case UserType.Restaurant:
        return restaurantHome();
      case UserType.Volunteers:
        return volunteersHome();
      default:
    }

    return Container();
  }

  Widget adminHome() {
    final controller = Get.find<HomeController>();
    //     var size = Get.size;

    // /*24 is for notification bar on Android*/
    // final double itemHeight = (size.height - kToolbarHeight - 24 ) / 2;
    // final double itemWidth = size.width / 2;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: GridView.count(
            // childAspectRatio: (itemWidth / itemHeight),
            crossAxisCount: 2,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,

            children: [
              CustomButton(
                label: 'ادارة المطاعم',
                onPressed: () => Get.to(RestaurantsManagementPage()),
              ),
              CustomButton(
                label: 'ادارة المتطوعين',
                onPressed: () => Get.to(VolunteersManagementPage()),
              ),
              CustomButton(
                label: 'طلبات التبرع الجديدة',
                onPressed: () =>
                    controller.openNewListDontion,
              ),
              CustomButton(
                label: 'طلبات التبرع المعلقة',
                onPressed: () =>
                    controller.openUnderDeliveryRequestsListDontionForAdmin,
              ),
              CustomButton(
                label: ' كل طلبات التبرع ',
                onPressed: () =>
                    controller.openAllListDontion,
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget volunteersHome() {
    final controller = Get.find<HomeController>();

    bool notApprove = (controller.user.status == null) ||
        (controller.user.status == Status.notApprove);

    if (notApprove) {
      return notApproveWidget();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: GridView.count(
            // childAspectRatio: (itemWidth / itemHeight),
            crossAxisCount: 2,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            children: [
              CustomButton(
                label: 'الطلبات المعلقة',
                onPressed: () =>
                    controller.openUnderDeliveryRequestsListDontion,
              ),
              CustomButton(
                label: 'الطلبات المنجزة',
                onPressed: () => controller.openCompletedRequestsListDontion,
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget restaurantHome() {
    final controller = Get.find<HomeController>();

    bool notApprove = (controller.user.status == null) ||
        (controller.user.status == Status.notApprove);

    if (notApprove) {
      return notApproveWidget();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: GridView.count(
            // childAspectRatio: (itemWidth / itemHeight),
            crossAxisCount: 2,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            children: [
              CustomButton(
                label: 'إضافة طلب تبرع بالطعام ',
                onPressed: () => Get.to(AddDonationPage()),
              ),
              CustomButton(
                label: 'طلبات التبرع السابقة ',
                onPressed: () => controller.openPreviousListDontion,
              ),
              CustomButton(
                label: 'قائمة الامتنان ',
                onPressed: () => Get.to(ListGratitudePage()),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget notApproveWidget() {
    final controller = Get.find<HomeController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Container(
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Text(
                'حسابك غير مفعل ! \n الرجاء التواصل مع ادارة التطبيق لتفعيل حسابك ',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 18,
                    color: AppColors.lightPrimary,
                    fontFamily: "DinNextLtW23",
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
        FlatButton(
          onPressed: () => controller.signOut(),
          child: Text(
            'تسجيل خروح',
            style: TextStyle(color: Colors.white),
          ),
          color: AppColors.lightPrimary,
        ),
      ],
    );
  }
}
