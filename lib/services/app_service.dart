import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:food_preservation/models/app_setting.dart';
import 'package:food_preservation/models/user_model.dart';
import 'package:food_preservation/util/enums.dart';
import 'db/base_db_box.dart';
import 'db/db_box_model.dart';
import 'db/hive_db_helper.dart';

class AppService {
  AppSetting _appSetting;
  DbBoxModel<AppSetting> dbBox;
  BaseDbBox _basedbBox;

  Future init() async {
    //
    await Firebase.initializeApp();

    //
    await HiveDbHelper().init();

    _appSetting = AppSetting();
    dbBox = DbBoxModel<AppSetting>(_appSetting);
    _basedbBox = BaseDbBox();
    await _basedbBox.init('customData');

    await dbBox.init(modelForstudy: false);
    _appSetting = dbBox.getDataModel();

    if (_appSetting == null) {
      _initFirstTimeRunApp();
    }
  }

  _initFirstTimeRunApp() {
    _appSetting = AppSetting(showScreenInfoEnter: true);

    refreshDb;
  }

  setCustomDataToDb({String key, String data}) async {
    await _basedbBox.setData(key: key, data: data);
  }

  getCustomDataFromDb(String key) {
    return _basedbBox.getData(key: key);
  }

  get hideScreenInfoEnter => _appSetting.showScreenInfoEnter = false;

  bool get isUserRegistered => _appSetting.currentUser != null;

  refreshUserInfo(UserModel user) async {
    _appSetting.currentUser = user;

    await refreshDb;
  }

  Future get refreshDb async => await dbBox.setData(model: _appSetting);

  UserModel get currentUser => _appSetting.currentUser;

  UserType get userType => (currentUser?.type) == null
      ? UserType.Unknown
      : UserType.values[currentUser.type];

  bool get userIsAdmin => currentUser?.type == UserType.Admin.index;

  bool get userIsRestaurant => currentUser?.type == UserType.Restaurant.index;

  bool get userIsVolunteers => currentUser?.type == UserType.Volunteers.index;

  Future exitFromApp() async {
    await Future.delayed(Duration(milliseconds: 200));

    SystemNavigator.pop();
  }
}
