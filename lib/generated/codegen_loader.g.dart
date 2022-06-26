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
  "english": "English",
  "medicine": "Medicines",
  "patients": "Patients",
  "service": "Services",
  "txt_about_app": "About app",
  "txt_language": "Language",
  "txt_log_out": "Log Out",
  "vietnam": "Việt Nam"
};
static const Map<String,dynamic> vi = {
  "app_title": "Quản lý bệnh viện",
  "doctor": "Bác sĩ",
  "english": "English",
  "medicine": "Thuốc",
  "patients": "Bệnh nhân",
  "service": "Dịch vụ",
  "txt_about_app": "Giới thiệu",
  "txt_language": "Ngôn ngữ",
  "txt_log_out": "Đăng Xuất",
  "vietnam": "Việt Nam"
};
static const Map<String, Map<String,dynamic>> mapLocales = {"en": en, "vi": vi};
}
