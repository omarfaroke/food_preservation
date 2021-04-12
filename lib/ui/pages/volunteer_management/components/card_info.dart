import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:food_preservation/models/user_model.dart';
import 'package:food_preservation/ui/theme/app_colors.dart';
import 'package:food_preservation/util/enums.dart';
import 'package:get/get.dart';

class CardInfoVolunteer extends StatelessWidget {
  const CardInfoVolunteer({
    Key key,
    @required this.parent,
    this.onStatusChanged,
    this.onPressDelete,
    this.onPressEdit,
    this.onPressSelected,
  }) : super(key: key);

  final UserModel parent;
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
                    leading: imageUser(parent),
                    title: Text(
                      parent.name,
                      style: TextStyle(
                        color: AppColors.lightPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      ' ${parent.email}',
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
                                    subtitle: Text(parent.address),
                                  ),
                                  ListTile(
                                    leading: Icon(Icons.email),
                                    title: Text("البريد الالكتروني"),
                                    subtitle: Text(parent.email),
                                  ),
                                  ListTile(
                                    leading: Icon(Icons.phone_android),
                                    title: Text("جوال"),
                                    subtitle: Text(parent.phone),
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
                                  onPressed: () => onPressSelected(parent),
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
                                      onPressed: () => onPressEdit(parent)),
                                  IconButton(
                                      icon: Icon(Icons.delete),
                                      onPressed: () => onPressDelete(parent)),
                                  Switch(
                                    // checkColor: AppColors.lightPrimary,
                                    activeColor: AppColors.lightPrimary,
                                    value: parent.status == Status.approve,
                                    onChanged: (bool value) =>
                                        onStatusChanged(parent, value),
                                  ),
                                ])),
                ],
              ),
            ],
          ),
        ));
  }

  Widget imageUser(parent) {
    List<String> shorCutName = parent.name.trim().split(" ");

    shorCutName.first = shorCutName.first.toUpperCase();

    Widget pictureName = Container(
      height: 90,
      width: 60,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.lightTextPrimary, width: 2.0),

//        border: Border.all(color: AppColors.textDarkColor, width: 2.0),
//        borderRadius: BorderRadius.circular(40.0),
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

    if (parent.photo == null) {
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
          image: CachedNetworkImageProvider(parent.photo),
        ),
      ),
    );
  }
}
