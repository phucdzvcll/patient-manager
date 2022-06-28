import 'package:sqflite/sqlite_api.dart';

class Patient {
  final int patientId;
  final String patientName;
  final String patientDateOfBirth;
  final int gender;
  final String? hospitalizedDay;
  final String? hospitalDischargeDate;

  const Patient({
    required this.patientId,
    required this.patientName,
    required this.patientDateOfBirth,
    required this.gender,
    this.hospitalizedDay,
    this.hospitalDischargeDate,
  });

  factory Patient.fromJson(Map<String, dynamic> json) => Patient(
        patientName: json["patientName"],
        patientId: json["patientId"],
        patientDateOfBirth: json["patientDateOfBirth"],
        gender: json["sex"],
        hospitalizedDay: json["hospitalizedDay"],
        hospitalDischargeDate: json["hospitalDischargeDate"],
      );

  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = {};
    data["patientId"] = patientId;
    data["patientName"] = patientName;
    data["patientDateOfBirth"] = patientDateOfBirth;
    data["sex"] = gender;
    data["hospitalizedDay"] = hospitalizedDay;
    data["hospitalDischargeDate"] = hospitalDischargeDate;
    return data;
  }
}

class PatientProvider {
  final _tableName = "patient";
  final _patientId = "patientId";
  final _patientName = "patientName";
  final _patientDateOfBirth = "patientDateOfBirth";
  final _hospitalDischargeDate = "hospitalDischargeDate";
  final _hospitalizedDay = "hospitalizedDay";
  final _sex = "sex";

  final Database db;

  PatientProvider({
    required this.db,
  });

  Future<int> insert(Patient patient) async {
    var s = await db.insert("patient", patient.toMap());
    return s;
  }

  Future<Patient?> getPatient(int id) async {
    List<Map<String, dynamic>> maps = await db.query(_tableName,
        columns: [
          _patientId,
          _patientName,
          _patientDateOfBirth,
          _hospitalDischargeDate,
          _hospitalizedDay,
          _sex
        ],
        where: '$_patientId = $id',
        whereArgs: [id]);
    if (maps.isNotEmpty) {
      return Patient.fromJson(maps.first);
    }
    return null;
  }

  Future<List<Patient>> getListPatient() async {
    List<Map<String, dynamic>> maps = await db.query(
      _tableName,
      columns: [
        _patientId,
        _patientName,
        _patientDateOfBirth,
        _hospitalDischargeDate,
        _hospitalizedDay,
        _sex
      ],
    );
    if (maps.isNotEmpty) {
      return maps.map((e) => Patient.fromJson(e)).toList();
    }
    return [];
  }

  Future<int> update(Patient patient) async {
    return await db.update(
      _tableName,
      patient.toMap(),
      where: '$_patientId = ${patient.patientId}',
    );
  }
}
