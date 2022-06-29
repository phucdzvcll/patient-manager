import 'package:sqflite/sqlite_api.dart';

class Order {
  int? orderNo;
  final int patientId;
  final int doctorId;
  final double totalPrice;
  final String orderDate;

  Order({
    this.orderNo,
    required this.patientId,
    required this.doctorId,
    required this.totalPrice,
    required this.orderDate,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};
    data["patientId"] = patientId;
    data["doctorId"] = doctorId;
    data["totalPrice"] = totalPrice;
    data["orderDate"] = orderDate;
    return data;
  }
}

class OrderProvider {
  final Transaction transaction;

  OrderProvider({
    required this.transaction,
  });

  Future<int> insert(Order order) async {
    return await transaction.insert("orderP", order.toJson());
  }
}
