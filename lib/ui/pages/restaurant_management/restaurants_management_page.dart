import 'package:flutter/material.dart';
import 'package:food_preservation/ui/theme/app_colors.dart';
import 'package:food_preservation/ui/widgets/widgets.dart';
import 'package:get/get.dart';
import 'components/card_info.dart';
import 'restaurants_management_controller.dart';

class RestaurantsManagementPage extends StatelessWidget {
  const RestaurantsManagementPage({Key key, this.showSelected = false})
      : super(key: key);

  final bool showSelected;

  @override
  Widget build(BuildContext context) {
    return MixinBuilder<RestaurantsManagementController>(
        init: RestaurantsManagementController(),
        builder: (controller) {
          return SafeArea(
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Scaffold(
                appBar: AppBar(
                  title:
                      showSelected ? Text(' المطاعم') : Text('ادارة المطاعم'),
                  centerTitle: true,
                  actions: [
                    IconButton(
                        icon: Icon(Icons.person_add),
                        onPressed: () => controller.add)
                  ],
                ),
                body: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      controller.loading
                          ? Loading()
                          : (controller.listData.value?.isEmpty ?? true)
                              ? empty()
                              : list(),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  Widget list() {
    final controller = Get.find<RestaurantsManagementController>();
    final list = controller.listData.value;
    return Expanded(
      child: ListView.builder(
          // shrinkWrap: true,
          itemCount: list.length,
          itemBuilder: (context, index) {
            return CardInfoRestaurant(
              user: list[index],
              onPressDelete: (parent) => controller.delete(parent),
              onPressEdit: (parent) => controller.edit(parent),
              onStatusChanged: (parent, status) =>
                  controller.changeStatus(parent, status),
              onPressSelected:
                  showSelected ? (parent) => controller.selected(parent) : null,
            );
          }),
    );
  }

  Widget empty() {
    return Center(
      child: Text(
        'قائمة المطاعم فارغة ..',
        style: TextStyle(
            fontSize: 18,
            color: AppColors.lightPrimary,
            fontFamily: "DinNextLtW23",
            fontWeight: FontWeight.bold),
      ),
    );
  }
}
