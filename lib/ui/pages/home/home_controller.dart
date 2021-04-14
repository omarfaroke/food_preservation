import 'package:food_preservation/app/locator.dart';
import 'package:food_preservation/models/donation_food_model.dart';
import 'package:food_preservation/models/user_model.dart';
import 'package:food_preservation/services/app_service.dart';
import 'package:food_preservation/services/authentication_service.dart';
import 'package:food_preservation/ui/pages/list_donation/list_donation_page.dart';
import 'package:food_preservation/util/enums.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  @override
  void onInit() {
    super.onInit();
  }

  UserType get userType => locator<AppService>().userType;

  UserModel get user => locator<AppService>().currentUser;

  get openNewListDontion async {
    Get.to(
      ListDonationPage(
        donationByStatus: [StatusDonation.newDonation],
        titlePage: 'طلبات التبرع الجديدة',
        forUser: UserType.Admin,
        onlyNewDonation: true,
      ),
    );
  }

  get openAllListDontion async {
    Get.to(
      ListDonationPage(
        donationByStatus: [],
        titlePage: 'كل طلبات التبرع ',
        forUser: UserType.Admin,
      ),
    );
  }

  get openUnderDeliveryRequestsListDontionForAdmin async {
    Get.to(
      ListDonationPage(
        donationByStatus: [StatusDonation.accept],
        titlePage: 'طلبات التبرع المعلقة',
        forUser: UserType.Admin,
        showSelectVolunteer: true,
      ),
    );
  }

  get openPreviousListDontion async {
    Get.to(
      ListDonationPage(
        donationByStatus: [],
        titlePage: 'طلبات التبرع السابقة',
        forUser: UserType.Restaurant,
        donationByRestaurant: user.id,
      ),
    );
  }

  get openCompletedRequestsListDontion async {
    Get.to(
      ListDonationPage(
        donationByStatus: [StatusDonation.delivered],
        titlePage: 'طلبات التبرع المنجزة',
        forUser: UserType.Volunteers,
        donationByVolunteer: user.id,
      ),
    );
  }

  get openUnderDeliveryRequestsListDontion async {
    Get.to(
      ListDonationPage(
        donationByStatus: [StatusDonation.underDelivery],
        titlePage: 'طلبات التبرع المعلقة',
        forUser: UserType.Volunteers,
        donationByVolunteer: user.id,
      ),
    );
  }

  signOut() {
    Get.find<AuthenticationService>().signOut();
  }
}
