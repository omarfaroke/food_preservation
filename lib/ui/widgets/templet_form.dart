import 'package:flutter/material.dart';
import 'package:food_preservation/ui/theme/app_colors.dart';
import 'package:get/get.dart';
import 'disable_widget.dart';

class TempletForm extends StatelessWidget {
  const TempletForm({
    Key key,
    this.title,
    this.children,
    this.iconForm,
    this.scrollController,
    this.formCenter = true,
    this.disable = false,
  }) : super(key: key);

  final title;
  final List<Widget> children;
  final String iconForm;
  final ScrollController scrollController;
  final bool formCenter;
  final bool disable;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: DisableWidget(
        withOpacity: false,
        condition: disable,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(color: AppColors.lightAccent),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                (!formCenter && title != null)
                    ? _buildTitleWithIConWidget
                    : SizedBox(),
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: Scrollbar(
                        child: ListView(
                          controller: scrollController,
                          shrinkWrap: true,
                          physics: ClampingScrollPhysics(),
                          // physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                          padding: const EdgeInsets.symmetric(horizontal: 40.0),
                          children: formCenter
                              ? [_buildTitleWithIConWidget, ...this.children]
                              : this.children,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  get _buildTitleWithIConWidget {
    final width = Get.width;
    final height = Get.width;
    if (iconForm == null) {
      return _buildTitleWidget;
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(
            padding: EdgeInsets.only(
              top: 5,
            ),
            child: Image.asset(
              iconForm,
              width: width * .3,
              height: height * .4,
            )),
        Text(
          title ?? '',
          style: TextStyle(
            fontSize: 22,
            color: AppColors.lightTextPrimary,
            fontWeight: FontWeight.bold,
            fontFamily: "DinNextLtW23",
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: 30,
        )
      ],
    );
  }

  get _buildTitleWidget {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      // mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: (EdgeInsets.only(top: 0, right: 10, bottom: 0, left: 10)),
          child: Container(
            height: 100,
            width: 250,
            decoration: BoxDecoration(
                color: AppColors.lightAccent,
                borderRadius: BorderRadius.only()),
            child: Center(
                child: Text(
              this.title ?? '',
              style: TextStyle(
                  color: AppColors.lightTextPrimary,
                  fontWeight: FontWeight.bold,
                  fontFamily: "DinNextLtW23",
                  fontSize: 26),
            )),
          ),
        )
      ],
    );
  }
}

customAppBar({bool withBackArrow = false}) => AppBar(
      backgroundColor: Colors.white,
      leading: withBackArrow
          ? IconButton(
              icon: new Icon(Icons.arrow_back, color: AppColors.lightPrimary),
              onPressed: () => Get.back(),
            )
          : null,
    );
