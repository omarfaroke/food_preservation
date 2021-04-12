import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_preservation/app/locator.dart';
import 'package:food_preservation/services/app_service.dart';
import 'package:food_preservation/services/authentication_service.dart';
import 'package:food_preservation/ui/pages/edit_profile/edit_profile_page.dart';
import 'package:food_preservation/ui/theme/app_colors.dart';
import 'package:food_preservation/util/enums.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: ListView(children: listItemDrawer),
      ),
    );
  }

  get listItemDrawer {
    UserType userType = locator<AppService>().userType;
    if (userType == UserType.Admin) {
      return adminDrawer;
    }

    if (userType == UserType.Restaurant) {
      return restaurantDrawer;
    }

    if (userType == UserType.Volunteers) {
      return volunteersDrawer;
    }

    return mainDrawer;
  }

  Widget get uerInfo {
    User user = Get.find<AuthenticationService>().currentUser;
    return UserAccountsDrawerHeader(
      currentAccountPicture: GFAvatar(
        backgroundColor: AppColors.lightAccent,
        backgroundImage: user?.photoURL != null
            ? NetworkImage(
                user.photoURL,
              )
            : AssetImage(
                "assets/images/icon.png",
              ),
        radius: 2,
      ),
      accountName: Text(
        user?.displayName ?? '',
        style: TextStyle(
          color: AppColors.lightTextButton,
          fontFamily: 'DinNextLtW23',
        ),
      ),
      accountEmail: Text(
        user?.email ?? '',
        style: TextStyle(
          color: AppColors.lightTextButton,
          fontFamily: 'DinNextLtW23',
        ),
      ),
    );
  }

  Widget get home => ListTile(
        leading: Icon(
          Icons.home,
          color: AppColors.lightPrimary,
        ),
        title: Text(
          'الرئيسية',
          style: TextStyle(
            color: AppColors.lightPrimary,
          ),
        ),
        onTap: () => print('home'),
      );

  Widget get profile => ListTile(
        leading: Icon(
          Icons.person,
          color: AppColors.lightPrimary,
        ),
        title: Text(
          'البياناات الشخصية',
          style: TextStyle(
            color: AppColors.lightPrimary,
          ),
        ),
        onTap: () async {
          await Get.to(EditProfilePage(
            user: locator<AppService>().currentUser,
            justShow: true,
          ));
          Get.back();
        },
      );

  Widget get signOut => ListTile(
        leading: Icon(
          Icons.logout,
          color: AppColors.lightPrimary,
        ),
        title: Text(
          'تسجيل خروج',
          style: TextStyle(
            color: AppColors.lightPrimary,
          ),
        ),
        onTap: () => Get.find<AuthenticationService>().signOut(),
      );

  List<Widget> get mainDrawer {
    return [];
  }

  List<Widget> get adminDrawer {
    return [
      uerInfo,
      home,
      profile,
      Divider(),
      signOut,
    ];
  }

  List<Widget> get restaurantDrawer {
    return [
      uerInfo,
      home,
      profile,
      Divider(),
      Divider(),
      signOut,
    ];
  }

  List<Widget> get volunteersDrawer {
    return [
      uerInfo,
      home,
      profile,
      Divider(),
      Divider(),
      signOut,
    ];
  }
}
