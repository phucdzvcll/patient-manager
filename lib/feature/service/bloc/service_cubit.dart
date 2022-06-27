import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:task_management/feature/service/bloc/service_state.dart';

import '../../../main.dart';

class ServiceCubit extends Cubit<ServiceState> {
  ServiceCubit() : super(ServiceLoading());

  final Database db = getIt.get<Database>();

  void getServices() async {
    ServiceProvider doctorProvider = ServiceProvider(db: db);
    try {
      List<Service> s = await doctorProvider.getDoctor();
      emit(GetServiceSuccess(services: s));
    } catch (e) {
      emit(GetServiceFail());
    }
  }
}

class Service {
  final int id;
  final String serviceName;
  final double price;

  const Service({
    required this.id,
    required this.serviceName,
    required this.price,
  });

  factory Service.fromMap(Map<String, dynamic> json) {
    return Service(
      id: json['serviceId'],
      serviceName: json['serviceName'],
      price: json['servicePrice'],
    );
  }
}

class ServiceProvider {
  final Database db;

  ServiceProvider({
    required this.db,
  });

  Future<List<Service>> getDoctor() async {
    List<Map<String, dynamic>> maps = await db.query("service",
        columns: ["serviceId", "serviceName", "servicePrice"],
        where: 'active = 1');
    if (maps.isNotEmpty) {
      return maps.map((e) => Service.fromMap(e)).toList();
    }
    return [];
  }
}
