import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:food_preservation/models/donation_food_model.dart';
import 'package:food_preservation/ui/theme/app_colors.dart';
import '../../../../util/extensions.dart';

class CardInfoGratitude extends StatelessWidget {
  const CardInfoGratitude({
    Key key,
    @required this.donation,
  }) : super(key: key);

  final DonationFoodModel donation;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Card(
        elevation: 7,
        margin: EdgeInsets.all(8),
        child: Column(
          children: <Widget>[
            Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildImage(donation.photo),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'وصف الطعام : ',
                          style: TextStyle(
                            fontSize: 18,
                            // color: AppColors.lightTextButton,
                            fontFamily: "DinNextLtW23",
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            donation.description,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                            style: TextStyle(
                              fontSize: 18,
                              // color: AppColors.lightTextButton,
                              fontFamily: "DinNextLtW23",
                              // fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: donation.note != null,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8, bottom: 8),
                      child: Row(
                        children: [
                          Text(
                            'ملاحظات : ',
                            style: TextStyle(
                              fontSize: 16,
                              // color: AppColors.lightTextButton,
                              fontFamily: "DinNextLtW23",
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            donation.note ?? '',
                            style: TextStyle(
                              fontSize: 16,
                              // color: AppColors.lightTextButton,
                              fontFamily: "DinNextLtW23",
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(right: 8, bottom: 8, left: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              'رقم الطلب : ',
                              style: TextStyle(
                                fontSize: 14,
                                // color: AppColors.lightTextButton,
                                fontFamily: "DinNextLtW23",
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              donation.number,
                              style: TextStyle(
                                fontSize: 14,
                                // color: AppColors.lightTextButton,
                                fontFamily: "DinNextLtW23",
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              'تاريخ التوصيل : ',
                              style: TextStyle(
                                fontSize: 14,
                                // color: AppColors.lightTextButton,
                                fontFamily: "DinNextLtW23",
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              donation.dateUpdate.formatDate(),
                              style: TextStyle(
                                fontSize: 14,
                                // color: AppColors.lightTextButton,
                                fontFamily: "DinNextLtW23",
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                                      child: Text(
                      'شكراً جزيلا لك على تبرعك بهذا الطعام  ',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.primary_1,
                        fontFamily: "DinNextLtW23",
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(String url) {
    if (url != null) {
      return Container(
        height: 200,
        child: CachedNetworkImage(
          fit: BoxFit.fitWidth,
          imageUrl: url,
          placeholder: (context, url) => Center(
              child: CircularProgressIndicator(
            backgroundColor: AppColors.lightPrimary,
          )),
        ),
      );
    } else {
      return SizedBox();
    }
  }
}
