import 'package:flutter/material.dart';
import 'package:task_management/feature/doctor/doctor_screen.dart';
import 'package:task_management/feature/home/home.dart';
import 'package:task_management/feature/medicine/medicine_screen.dart';
import 'package:task_management/feature/patient/patient_menu.dart';
import 'package:task_management/feature/service/service_screen.dart';

class Routes {
  static const home = "/home";
}

class RouterGenerator {
  static Route<dynamic> generateRoutes(RouteSettings settings) {
    switch (settings.name) {
      case Routes.home:
        return MaterialPageRoute(
          builder: ((context) => const HomeScreen()),
        );
      case DoctorScreen.routeName:
        return MaterialPageRoute(
          builder: ((context) => const DoctorScreen()),
        );
      case ServiceScreen.routeName:
        return MaterialPageRoute(
          builder: ((context) => const ServiceScreen()),
        );
      case MedicineScreen.routeName:
        return MaterialPageRoute(
          builder: ((context) => const MedicineScreen()),
        );
      case PatientMenu.routeName:
        return MaterialPageRoute(
          builder: ((context) => const PatientMenu()),
        );
      default:
        return MaterialPageRoute(
          builder: ((context) => const HomeScreen()),
        );
    }
  }
}
