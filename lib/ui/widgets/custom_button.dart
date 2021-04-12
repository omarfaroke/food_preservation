import 'package:flutter/material.dart';
import 'package:food_preservation/ui/animation/fade_animation.dart';
import 'package:food_preservation/ui/theme/app_colors.dart';
import 'package:getwidget/getwidget.dart';
import 'package:reactive_forms/reactive_forms.dart';

import 'disable_widget.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({Key key, @required this.onPressed, this.label})
      : super(key: key);

  final Function onPressed;
  final String label;

  @override
  Widget build(BuildContext context) {
    return FadeAnimation(
      1.6,
      ElevatedButton(
        child: Container(
          alignment: Alignment.center,
          height: 120,
          width: 120,
          child: Text(
            label ?? '',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 18,
                color: AppColors.lightTextButton,
                fontFamily: "DinNextLtW23",
                fontWeight: FontWeight.bold),
          ),
        ),
        onPressed: () => onPressed(),
        style: ElevatedButton.styleFrom(
            primary: AppColors.primary_1,
            shape: BeveledRectangleBorder(
                borderRadius: BorderRadius.circular(20))),
        clipBehavior: Clip.antiAlias,
      ),
      // InkWell(
      //   onTap: () => onPressed(),
      //   child: Container(
      //     height: 150,
      //     width: 150,
      //     decoration: BoxDecoration(
      //         borderRadius: BorderRadius.circular(25),
      //         color: AppColors.buttonColor),
      //     child: Center(
      //       child: Text(
      //         label ?? '',
      //         style: TextStyle(
      //             fontSize: 18,
      //             color: AppColors.lightTextButton,
      //             fontFamily: "DinNextLtW23",
      //             fontWeight: FontWeight.bold),
      //       ),
      //     ),
      //   ),
      // ),
    );
  }
}
