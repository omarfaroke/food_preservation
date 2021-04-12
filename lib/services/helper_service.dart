import 'package:flutter/material.dart';
import 'package:food_preservation/ui/widgets/toast_msg.dart';
import 'package:food_preservation/util/function_helpers.dart';
import 'package:get/get.dart';
import 'package:google_map_location_picker/google_map_location_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class HelperService {
  static Future<bool> get checkPermissionStorage async {
    PermissionStatus permission = await Permission.storage.status;

    if (permission != PermissionStatus.granted) {
      PermissionStatus permissionStatus = await Permission.storage.request();

      if (permissionStatus.isDenied) {
        showTextError('فشل الحصول على صلاحية التعامل مع الملفات !');
        return false;
      }
      return true;
    } else {
      return true;
    }
  }

  static Future<LocationResult> showMapView() async {
    String apiKey = 'AIzaSyCYH1e8Jk3brXKinzKU7OCb5DmONdwBJMs';

    LatLng latLng = LatLng(24.706218959658127, 46.669893711805344); // الرياض

    LocationResult result = await showLocationPicker(Get.context, apiKey,
        requiredGPS: false,
        resultCardConfirmIcon: Center(child: Text('تحديد')),
        initialCenter: latLng,
        automaticallyAnimateToCurrentLocation: false,
        myLocationButtonEnabled: true,
        layersButtonEnabled: true,
        resultCardAlignment: Alignment.bottomCenter,
        countries: ['YE', 'SA'],
        language: 'AR');

    print(result);

    return result;
  }
}
