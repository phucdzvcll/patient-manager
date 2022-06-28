import 'package:sqflite/sqlite_api.dart';

class MedicineByOrder {
  final int orderNo;
  final int medicineId;
  final double price;

  const MedicineByOrder({
    required this.orderNo,
    required this.medicineId,
    required this.price,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};
    data["orderNo"] = orderNo;
    data["medicineId"] = medicineId;
    data["price"] = price;
    return data;
  }
}

class MedicineByOrderProvider {
  final Transaction transaction;

  const MedicineByOrderProvider({
    required this.transaction,
  });

  Future<int> insert(MedicineByOrder medicineByOrder) async {
    return await transaction.insert("medicineByOrder", medicineByOrder.toJson());
  }
}
