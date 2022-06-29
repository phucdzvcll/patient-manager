import 'package:sqflite/sqflite.dart';

class MedicineDetail {
  final double price;
  final String medicineName;
  final String unit;

  const MedicineDetail({
    required this.price,
    required this.medicineName,
    required this.unit,
  });

  factory MedicineDetail.fromJson(Map<String, dynamic> json) => MedicineDetail(
        price: json["price"],
        medicineName: json["medicineName"],
        unit: json["unit"],
      );
}

class MedicineDetailDetailProvider {
  final Transaction transaction;

  const MedicineDetailDetailProvider({
    required this.transaction,
  });

  Future<List<MedicineDetail>> getServiceDetail(int orderId) async {
    var result = await transaction.rawQuery(
        "SELECT m.price, m2.medicineName, m2.unit FROM medicineByOrder as m "
        "INNER JOIN medicine as m2 ON m.medicineId = m2.medicineId "
        "WHERE m.orderNo = $orderId ");

    if (result.isNotEmpty) {
      return result.map((e) => MedicineDetail.fromJson(e)).toList();
    } else {
      return [];
    }
  }
}
