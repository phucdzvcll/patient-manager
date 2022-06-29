import 'package:sqflite/sqflite.dart';

class ServiceDetail {
  final double price;
  final String serviceName;

  const ServiceDetail({
    required this.price,
    required this.serviceName,
  });

  factory ServiceDetail.fromJson(Map<String, dynamic> json) =>
      ServiceDetail(price: json["price"], serviceName: json["serviceName"]);
}

class ServiceDetailProvider {
  final Transaction transaction;

  const ServiceDetailProvider({
    required this.transaction,
  });

  Future<List<ServiceDetail>> getServiceDetail(int orderId) async {
    var result = await transaction
        .rawQuery("SELECT s.price, s2.serviceName FROM serviceByOrder as s "
            "INNER JOIN service as s2 ON s.serviceId = s2.serviceId "
            "WHERE s.orderNo = $orderId");

    if (result.isNotEmpty) {
      return result.map((e) => ServiceDetail.fromJson(e)).toList();
    } else {
      return [];
    }
  }
}
