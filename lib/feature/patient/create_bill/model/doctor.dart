import 'package:sqflite/sqlite_api.dart';

class Doctor {
  final int id;
  final String doctorName;

  const Doctor({
    required this.id,
    required this.doctorName,
  });

  factory Doctor.fromMap(Map<String, dynamic> json) {
    return Doctor(id: json['doctorID'], doctorName: json['doctorName']);
  }
}

class DoctorProvider {
  final Database db;

  DoctorProvider({
    required this.db,
  });

  Future<List<Doctor>> getDoctor() async {
    List<Map<String, dynamic>> maps = await db.query(
      "doctor",
      columns: ["doctorID", "doctorName"],
    );
    if (maps.isNotEmpty) {
      return maps.map((e) => Doctor.fromMap(e)).toList();
    }
    return [];
  }
}