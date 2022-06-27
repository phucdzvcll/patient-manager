import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:task_management/feature/medicine/bloc/medicine_state.dart';

import '../../../main.dart';

class MedicineCubit extends Cubit<MedicineState> {
  MedicineCubit() : super(MedicineLoading());

  final Database db = getIt.get<Database>();

  void getMedicines() async {
    MedicineProvider medicineProvider = MedicineProvider(db: db);
    try {
      List<Medicine> s = await medicineProvider.getDoctor();
      emit(GetMedicineSuccess(medicines: s));
    } catch (e) {
      emit(GetMedicineFail());
    }
  }
}

class Medicine {
  final int id;
  final String medicineName;
  final double price;
  final String unit;

  const Medicine({
    required this.id,
    required this.medicineName,
    required this.unit,
    required this.price,
  });

  factory Medicine.fromMap(Map<String, dynamic> json) {
    return Medicine(
      id: json['medicineId'],
      medicineName: json['medicineName'],
      price: json['medicinePrice'],
      unit: json['unit'],
    );
  }
}

class MedicineProvider {
  final Database db;

  MedicineProvider({
    required this.db,
  });

  Future<List<Medicine>> getDoctor() async {
    List<Map<String, dynamic>> maps = await db.query(
      "medicine",
      columns: ["medicineId", "medicineName", "medicinePrice", "unit"],
    );
    if (maps.isNotEmpty) {
      return maps.map((e) => Medicine.fromMap(e)).toList();
    }
    return [];
  }
}
