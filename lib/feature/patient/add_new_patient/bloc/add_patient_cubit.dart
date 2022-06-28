import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:task_management/main.dart';

part 'add_patient_state.dart';

class AddPatientCubit extends Cubit<AddPatientState> {
  AddPatientCubit() : super(AddPatientInitial());
  final Database db = getIt.get();

  void savePatient({
    required String patientName,
    required String patientDateOfBirth,
    required int gender,
    String? hospitalizedDay,
    String? hospitalDischargeDate,
  }) {
    PatientProvider patientProvider = PatientProvider(db: db);

    try {
      patientProvider.insert(Patient(
        patientName: patientName,
        patientDateOfBirth: patientDateOfBirth,
        gender: gender,
        hospitalDischargeDate: hospitalDischargeDate,
        hospitalizedDay: hospitalizedDay,
      ));
      emit(AddPatientSuccess());
    } catch (e) {
      emit(AddPatientFail());
    }
  }
}

class Patient {
  int? patientId;
  final String patientName;
  final String patientDateOfBirth;
  final int gender;
  final String? hospitalizedDay;
  final String? hospitalDischargeDate;

  Patient({
    this.patientId,
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
    data["patientName"] = patientName;
    data["patientDateOfBirth"] = patientDateOfBirth;
    data["sex"] = gender;
    data["hospitalizedDay"] = hospitalizedDay;
    data["hospitalDischargeDate"] = hospitalDischargeDate;
    return data;
  }
}

class PatientProvider {
  final Database db;

  PatientProvider({
    required this.db,
  });

  Future<int> insert(Patient patient) async {
    var s = await db.insert("patient", patient.toMap());
    return s;
  }
}
