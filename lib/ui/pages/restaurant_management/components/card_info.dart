import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:food_preservation/models/user_model.dart';
import 'package:food_preservation/ui/theme/app_colors.dart';
import 'package:food_preservation/util/enums.dart';
import 'package:get/get.dart';

class CardInfoRestaurant extends StatelessWidget {
  const CardInfoRestaurant({
    Key key,
    @required this.user,
    this.onStatusChanged,
    this.onPressDelete,
    this.onPressEdit,
    this.onPressSelected,
  }) : super(key: key);

  final UserModel user;
  final Function(UserModel user, bool value) onStatusChanged;
  final Function(UserModel user) onPressDelete;
  final Function(UserModel user) onPressEdit;
  final Function(UserModel user) onPressSelected;

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Card(
          elevation: 7,
          margin: EdgeInsets.all(8),
          child: Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  ExpansionTile(
                    initiallyExpanded: false,
                    leading: imageUser(user),
                    title: Text(
                      user.name,
                      style: TextStyle(
                        color: AppColors.lightPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      ' ${user.email}',
                      style: TextStyle(
                        color: AppColors.lightPrimary,
                      ),
                      maxLines: 1,
                    ),
                    trailing: Padding(
                      padding: const EdgeInsets.only(
                        top: 35,
                      ),
                      child: Icon(
                        Icons.arrow_drop_down,
                        color: Colors.red,
                      ),
                    ),
                    children: <Widget>[
                      Card(
                        elevation: 30,
                        child: Container(
                          padding: EdgeInsets.all(15),
                          child: Column(
                            children: <Widget>[
                              Container(
                                  child: Column(
                                children: <Widget>[
                                  ListTile(
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 4),
                                    leading: Icon(Icons.location_on),
                                    title: Text("العنوان"),
                                    subtitle: Text(user.address),
                                  ),
                                  ListTile(
                                    leading: Icon(Icons.email),
                                    title: Text("البريد الالكتروني"),
                                    subtitle: Text(user.email),
                                  ),
                                  ListTile(
                                    leading: Icon(Icons.phone_android),
                                    title: Text("جوال"),
                                    subtitle: Text(user.phone),
                                  ),
                                ],
                              ))
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Align(
                      alignment: Alignment.topLeft,
                      child: onPressSelected != null
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                FlatButton(
                                  onPressed: () => onPressSelected(user),
                                  child: Text(
                                    'تحديد',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  color: AppColors.lightPrimary,
                                ),
                              ],
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                  IconButton(
                                      icon: Icon(Icons.edit),
                                      onPressed: () => onPressEdit(user)),
                                  IconButton(
                                      icon: Icon(Icons.delete),
                                      onPressed: () => onPressDelete(user)),
                                  // Text("حالة المعلم"),
                                  Switch(
                                    // checkColor: AppColors.lightPrimary,
                                    activeColor: AppColors.lightPrimary,
                                    value: user.status == Status.approve,
                                    onChanged: (bool value) =>
                                        onStatusChanged(user, value),
                                  ),
                                ])),
                ],
              ),
            ],
          ),
        ));
  }

  Widget imageUser(user) {
    List<String> shorCutName = user.name.trim().split(" ");

    shorCutName.first = shorCutName.first.toUpperCase();

    Widget pictureName = Container(
      height: 90,
      width: 60,
      decoration: BoxDecoration(
//        border: Border.all(color: AppColors.textDarkColor, width: 2.0),
//        borderRadius: BorderRadius.circular(40.0),
        border: Border.all(color: AppColors.lightTextPrimary, width: 2.0),
        shape: BoxShape.circle,
      ),
      child: FittedBox(
        child: CircleAvatar(
          backgroundColor: AppColors.lightAccent,
          child: Text(
            shorCutName.first[0] + " " + shorCutName.last[0],
            style: TextStyle(color: AppColors.lightTextPrimary),
          ),
        ),
      ),
    );

    if (user.photo == null) {
      return pictureName;
    }
//  return pictureName;
    return Container(
      height: 80,
      width: 60,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.lightTextPrimary, width: 2.0),
        // borderRadius: BorderRadius.circular(2.0),
        shape: BoxShape.circle,
        image: DecorationImage(
          fit: BoxFit.fill,
          image: CachedNetworkImageProvider(user.photo),
        ),
      ),
    );
  }
}
