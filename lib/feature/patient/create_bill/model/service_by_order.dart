import 'package:sqflite/sqlite_api.dart';

class ServiceByOrder {
  final int orderNo;
  final int serviceId;
  final double price;

  const ServiceByOrder({
    required this.orderNo,
    required this.serviceId,
    required this.price,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};
    data["orderNo"] = orderNo;
    data["serviceId"] = serviceId;
    data["price"] = price;
    return data;
  }
}

class ServiceByOrderProvider {
  final Transaction transaction;

  const ServiceByOrderProvider({
    required this.transaction,
  });

  Future<int> insert(ServiceByOrder serviceByOrder) async {
    return await transaction.insert("serviceByOrder", serviceByOrder.toJson());
  }
}
