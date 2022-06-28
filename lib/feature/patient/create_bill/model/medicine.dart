import 'package:sqflite/sqflite.dart';

class MedicineSelect {
  final int id;
  final String medicineName;
  final double price;
  final String unit;
  bool selected = false;

  MedicineSelect({
    required this.id,
    required this.medicineName,
    required this.unit,
    required this.price,
  });

  factory MedicineSelect.fromMap(Map<String, dynamic> json) {
    return MedicineSelect(
      id: json['medicineId'],
      medicineName: json['medicineName'],
      price: json['medicinePrice'],
      unit: json['unit'],
    );
  }
}

class MedicineSelectProvider {
  final Database db;

  MedicineSelectProvider({
    required this.db,
  });

  Future<List<MedicineSelect>> getMedicine() async {
    List<Map<String, dynamic>> maps = await db.query(
      "medicine",
      columns: ["medicineId", "medicineName", "medicinePrice", "unit"],
    );
    if (maps.isNotEmpty) {
      return maps.map((e) => MedicineSelect.fromMap(e)).toList();
    }
    return [];
  }
}
