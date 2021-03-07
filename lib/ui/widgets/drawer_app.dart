import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_preservation/services/authentication_service.dart';
import 'package:food_preservation/ui/theme/app_colors.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    User user = Get.find<AuthenticationService>().currentUser;
    return Drawer(
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
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

                // ,child: user?.photoURL == null
                //     ? Image.asset(
                //         "assets/images/icon.png",
                //         fit: BoxFit.cover,
                //       )
                //     : SizedBox(),
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
            ),
            ListTile(
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
            ),
            Divider(),
            ListTile(
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
            ),
          ],
        ),
      ),
    );
  }
}
