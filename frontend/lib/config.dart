import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

class Config {
  static const String appName = "BeautyMinder";
  static String get apiURL {
    if (kIsWeb) {
      return "211.221.220.124:8080";
    }
    if (Platform.isAndroid) {
      return '10.0.2.2:8080';
    } else {
      return '211.221.220.124:8080';
    }
  }

  static const loginAPI = "/login";
  static const registerAPI = "/user/signup";
  static const userProfileAPI = "/user/me/";
  static const userProfileUpdateAPI = "/user/update/";

  // Todo
  static const todoAPI = "/todo/all";
  static const todoAddAPI = "/todo/add";
  static const todoDelAPI = "/todo/delete/";
}
