import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:food_preservation/models/donation_food_model.dart';
import 'package:food_preservation/ui/theme/app_colors.dart';
import 'package:food_preservation/util/enums.dart';
import 'package:food_preservation/util/extensions.dart';
import 'package:get/get.dart';

class CardInfoDonation extends StatelessWidget {
  const CardInfoDonation({
    Key key,
    @required this.donation,
    this.onStatusChanged,
    this.onPressSelectVolunteer,
    this.onPressRefuse,
    this.forUser,
    this.onPressInfoVolunteer,
    this.onPressInfoRestaurant,
  }) : super(key: key);

  final DonationFoodModel donation;
  final UserType forUser;
  final Function(DonationFoodModel donation, String value) onStatusChanged;
  final Function(DonationFoodModel donation) onPressSelectVolunteer;
  final Function(DonationFoodModel donation) onPressRefuse;
  final Function(String id) onPressInfoVolunteer;
  final Function(String id) onPressInfoRestaurant;

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
                      padding: const EdgeInsets.only(right: 8, bottom: 8 , left: 8),
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
                                'تاريخ الاضافة : ',
                                style: TextStyle(
                                  fontSize: 14,
                                  // color: AppColors.lightTextButton,
                                  fontFamily: "DinNextLtW23",
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                donation.dateAdd.formatDate(),
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
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    Visibility(
                      visible: forUser == UserType.Admin &&
                          donation.status == StatusDonation.newDonation,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                            // mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              FlatButton(
                                onPressed: () => onStatusChanged(
                                    donation, StatusDonation.accept),
                                child: Text(
                                  'قبول الطلب',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: "DinNextLtW23",
                                  ),
                                ),
                                color: AppColors.lightPrimary,
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              FlatButton(
                                onPressed: () => onPressRefuse(donation),
                                child: Text(
                                  'رفض الطلب',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: "DinNextLtW23",
                                  ),
                                ),
                                color: AppColors.lightPrimary,
                              ),
                            ]),
                      ),
                    ),
                    Visibility(
                      visible: onPressSelectVolunteer != null,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            FlatButton(
                              onPressed: () => onPressSelectVolunteer(donation),
                              child: Text(
                                'تحديد متطوع لهذا الطلب',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: "DinNextLtW23",
                                ),
                              ),
                              color: AppColors.lightPrimary,
                            ),
                          ]),
                    ),
                    Visibility(
                      visible: forUser == UserType.Volunteers,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            _buildStatusDonations(donation),
                            SizedBox(
                              width: 20,
                            ),
                            donation.status == StatusDonation.underDelivery
                                ? FlatButton(
                                    onPressed: () => onStatusChanged(
                                        donation, StatusDonation.delivered),
                                    child: Text(
                                      'تم التوصيل',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: "DinNextLtW23",
                                      ),
                                    ),
                                    color: AppColors.lightPrimary,
                                  )
                                : SizedBox(),
                          ]),
                    ),
                    Visibility(
                      visible: (forUser == UserType.Restaurant ||
                          (forUser == UserType.Admin &&
                              onPressRefuse == null &&
                              onPressSelectVolunteer == null)),
                      child: Column(children: <Widget>[
                        _buildStatusDonations(donation),
                        _buildRefusingReason(donation),
                      ]),
                    ),
                    Visibility(
                      visible: forUser == UserType.Admin &&
                          donation.idVolunteer != null,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            FlatButton(
                              onPressed: () =>
                                  onPressInfoVolunteer(donation.idVolunteer),
                              child: Text(
                                'بيانات المتطوع لهذا الطلب',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: "DinNextLtW23",
                                ),
                              ),
                              color: AppColors.primary_1,
                            ),
                          ]),
                    ),
                    Visibility(
                      visible: forUser == UserType.Admin,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            // TextButton.icon(
                            //   onPressed: () {},
                            //   icon: Icon(
                            //     Icons.info,
                            //     color: AppColors.primary_1,
                            //   ),
                            //   label: Text(
                            //     'بيانات صاحب هذا الطلب',
                            //     style: TextStyle(
                            //       color: AppColors.primary_1,
                            //     ),
                            //   ),
                            //   style: TextButton.styleFrom(),
                            // ),
                            FlatButton(
                              onPressed: () =>
                                  onPressInfoRestaurant(donation.idRestaurant),
                              child: Text(
                                'بيانات صاحب هذا الطلب',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: "DinNextLtW23",
                                ),
                              ),
                              color: AppColors.primary_1,
                            ),
                          ]),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  Widget _buildStatusDonations(DonationFoodModel donation) {
    String statusLable;

    if (donation.status == StatusDonation.accept) {
      statusLable = 'تم قبول الطلب';
    } else if (donation.status == StatusDonation.refuse) {
      statusLable = 'تم رفض الطلب';
    } else if (donation.status == StatusDonation.newDonation) {
      statusLable = 'الطلب مُعَلق';
    } else if (donation.status == StatusDonation.underDelivery) {
      statusLable = 'الطلب قيد التوصيل';
    } else if (donation.status == StatusDonation.delivered) {
      statusLable = 'تم توصيل الطلب';
    }

    return Row(
      children: [
        Text(
          'حالة الطلب : ',
          style: TextStyle(
            fontSize: 18,
            fontFamily: "DinNextLtW23",
          ),
        ),
        Text(
          statusLable,
          style: TextStyle(
            fontSize: 16,
            fontFamily: "DinNextLtW23",
            // color: AppColors.primary_2,
          ),
        ),
      ],
    );
  }

  Widget _buildRefusingReason(DonationFoodModel donation) {
    if (donation.status != StatusDonation.refuse) {
      return SizedBox();
    }

    return Row(
      children: [
        Text(
          'سبب الرفض :',
          style: TextStyle(
            fontSize: 16,
            fontFamily: "DinNextLtW23",
          ),
        ),
        Text(
          donation.refusingReason ?? '',
          style: TextStyle(
            fontSize: 14,
            fontFamily: "DinNextLtW23",
          ),
        ),
      ],
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

