import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';

import '../../../main.dart';
import 'doctor_state.dart';

class DoctorCubit extends Cubit<DoctorState> {
  DoctorCubit() : super(DoctorLoading());

  final Database db = getIt.get<Database>();

  void getDoctor() async {
    DoctorProvider doctorProvider = DoctorProvider(db: db);
    try {
      List<Doctor> s = await doctorProvider.getDoctor();
      emit(GetDoctorSuccess(doctors: s));
    } catch (e) {
      emit(GetDoctorFail());
    }
  }
}

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
