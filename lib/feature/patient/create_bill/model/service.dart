import 'package:sqflite/sqlite_api.dart';

class ServiceSelect {
  final int id;
  final String serviceName;
  final double price;
  bool selected = false;

  ServiceSelect({
    required this.id,
    required this.serviceName,
    required this.price,
  });

  factory ServiceSelect.fromMap(Map<String, dynamic> json) {
    return ServiceSelect(
      id: json['serviceId'],
      serviceName: json['serviceName'],
      price: json['servicePrice'],
    );
  }
}

class ServiceSelectProvider {
  final Database db;

  ServiceSelectProvider({
    required this.db,
  });

  Future<List<ServiceSelect>> getDoctor() async {
    List<Map<String, dynamic>> maps = await db.query("service",
        columns: ["serviceId", "serviceName", "servicePrice"],
        where: 'active = 1');
    if (maps.isNotEmpty) {
      return maps.map((e) => ServiceSelect.fromMap(e)).toList();
    }
    return [];
  }
}
