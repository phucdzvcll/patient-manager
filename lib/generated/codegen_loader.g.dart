// DO NOT EDIT. This is code generated via package:easy_localization/generate.dart

// ignore_for_file: prefer_single_quotes

import 'dart:ui';

import 'package:easy_localization/easy_localization.dart' show AssetLoader;

class CodegenLoader extends AssetLoader{
  const CodegenLoader();

  @override
  Future<Map<String, dynamic>> load(String fullPath, Locale locale ) {
    return Future.value(mapLocales[locale.toString()]);
  }

  static const Map<String,dynamic> en = {
  "app_title": "Hospital Manager",
  "doctor": "Doctors",
  "doctor_app_bar": "Doctor Information",
  "english": "English",
  "medicine": "Medicines",
  "mss_error": "Error",
  "mss_warning_exit": "Are you sure to exit app?",
  "patients": "Patients",
  "service": "Services",
  "service_app_bar": "Service Information",
  "txt_about_app": "About app",
  "txt_cancel": "Cancel",
  "txt_exit": "Exit",
  "txt_language": "Language",
  "txt_log_out": "Log Out",
  "txt_price": "Price: {} VNĐ",
  "txt_yes": "Yes",
  "vietnam": "Việt Nam"
};
static const Map<String,dynamic> vi = {
  "app_title": "Quản lý bệnh viện",
  "doctor": "Bác sĩ",
  "doctor_app_bar": "Thông Tin Bác Sĩ",
  "english": "English",
  "medicine": "Thuốc",
  "mss_error": "Lỗi",
  "mss_warning_exit": "Bạnc có chắc chắn thoát ứng dụng không?",
  "patients": "Bệnh nhân",
  "service": "Dịch vụ",
  "service_app_bar": "Thông Tin Dịch Vụ",
  "txt_about_app": "Giới thiệu",
  "txt_cancel": "Huỷ",
  "txt_exit": "Thoát",
  "txt_language": "Ngôn ngữ",
  "txt_log_out": "Đăng Xuất",
  "txt_price": "Giá: {} VNĐ",
  "txt_yes": "Có",
  "vietnam": "Việt Nam"
};
static const Map<String, Map<String,dynamic>> mapLocales = {"en": en, "vi": vi};
}
