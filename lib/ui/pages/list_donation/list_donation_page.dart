import 'package:flutter/material.dart';
import 'package:food_preservation/ui/theme/app_colors.dart';
import 'package:food_preservation/ui/widgets/widgets.dart';
import 'package:food_preservation/util/enums.dart';
import 'package:get/get.dart';
import 'components/card_info.dart';
import 'list_donation_controller.dart';

class ListDonationPage extends StatelessWidget {
  const ListDonationPage({
    Key key,
    @required this.titlePage,
    this.donationByRestaurant,
    this.donationByVolunteer,
    @required this.donationByStatus,
    this.forUser,
    this.onlyNewDonation = false,
    this.showSelectVolunteer = false,
  }) : super(key: key);

  final String titlePage;
  final String donationByRestaurant;
  final String donationByVolunteer;
  final List<String> donationByStatus;
  final UserType forUser;
  final bool onlyNewDonation;
  final bool showSelectVolunteer;

  @override
  Widget build(BuildContext context) {
    return MixinBuilder<ListDonationController>(
        init: ListDonationController(
          donationByRestaurant: donationByRestaurant,
          donationByVolunteer: donationByVolunteer,
          donationByStatus: donationByStatus,
        ),
        builder: (controller) {
          return SafeArea(
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Scaffold(
                appBar: AppBar(
                  title: Text(titlePage),
                  centerTitle: true,

                ),
                body: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      controller.loading
                          ? Loading()
                          : (controller.listModel?.isEmpty ?? true)
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
    final controller = Get.find<ListDonationController>();
    final list = controller.listModel;

    return Expanded(
      child: ListView.builder(
          // shrinkWrap: true,
          itemCount: list.length,
          itemBuilder: (context, index) {
            return CardInfoDonation(
              donation: list[index],
              forUser: forUser,
              onPressRefuse: !onlyNewDonation
                  ? null
                  : (donation) => controller.refuseDonation(donation),
              onPressSelectVolunteer: !showSelectVolunteer
                  ? null
                  : (donation) => controller.showSelectVolunteer(donation),
              onStatusChanged: (donation, status) =>
                  controller.changeStatus(donation, status),
              onPressInfoRestaurant: (id) => controller.showIfofRestaurant(id),
              onPressInfoVolunteer: (id) => controller.showInfoVolunteer(id),
            );
          }),
    );
  }

  Widget empty() {
    return Center(
      child: Text(
        'قائمة الطلبات فارغة ..',
        style: TextStyle(
            fontSize: 18,
            color: AppColors.lightPrimary,
            fontFamily: "DinNextLtW23",
            fontWeight: FontWeight.bold),
      ),
    );
  }
}
