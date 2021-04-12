import 'package:flutter/material.dart';
import 'package:food_preservation/ui/animation/fade_animation.dart';
import 'package:food_preservation/ui/theme/app_colors.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'disable_widget.dart';

class CustomSubmitButton extends StatelessWidget {
  const CustomSubmitButton({Key key, @required this.onPressed, this.label})
      : super(key: key);

  final Function onPressed;
  final String label;

  @override
  Widget build(BuildContext context) {
    return FadeAnimation(
        1.6,
        ReactiveFormConsumer(
            builder: (context, form, child) => DisableWidget(
                  condition: !form.valid,
                  child: InkWell(
                    onTap: () => onPressed(),
                    child: Container(
                      height: 50,
                      width: 300,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: AppColors.buttonColor),
                      child: Center(
                        child: Text(
                          label ?? '',
                          style: TextStyle(
                              fontSize: 18,
                              color: AppColors.lightTextButton,
                              fontFamily: "DinNextLtW23",
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                )));
  }
}
