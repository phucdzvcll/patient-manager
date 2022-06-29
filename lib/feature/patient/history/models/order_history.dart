import 'package:sqflite/sqflite.dart';

class OrderHistory {
  final int orderNo;
  final double totalPrice;
  final String orderDate;
  final String patientName;
  final String doctorName;

  const OrderHistory({
    required this.orderNo,
    required this.totalPrice,
    required this.orderDate,
    required this.patientName,
    required this.doctorName,
  });

  factory OrderHistory.fromJson(Map<String, dynamic> json) => OrderHistory(
        orderNo: json["orderNo"],
        totalPrice: json["totalPrice"],
        orderDate: json["orderDate"],
        patientName: json["patientName"],
        doctorName: json["doctorName"],
      );
}

class OrderHistoryProvider {
  final Database db;

  const OrderHistoryProvider({
    required this.db,
  });

  Future<List<OrderHistory>> getListOrderHistory() async {
    List<Map<String, dynamic>> maps = await db.rawQuery(
      "SELECT o.orderNo, o.totalPrice, o.orderDate, p.patientName, d.doctorName  FROM orderP as o "
      "INNER join patient as p ON o. patientId = p.patientId "
      "INNER join doctor as d ON d.doctorId = o.doctorId",
    );
    if (maps.isNotEmpty) {
      return maps.map((e) => OrderHistory.fromJson(e)).toList();
    } else {
      return [];
    }
  }
}
