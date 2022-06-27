import 'package:flutter/foundation.dart';
import 'package:task_management/feature/medicine/bloc/medicine_cubit.dart';


@immutable
abstract class MedicineState {}

class MedicineLoading extends MedicineState {}

class GetMedicineSuccess extends MedicineState {
  final List<Medicine> medicines;

  GetMedicineSuccess({
    required this.medicines,
  });
}

class GetMedicineFail extends MedicineState {}
