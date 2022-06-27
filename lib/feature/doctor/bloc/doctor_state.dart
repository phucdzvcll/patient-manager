import 'package:flutter/foundation.dart';

import 'doctor_cubit.dart';

@immutable
abstract class DoctorState {}

class DoctorLoading extends DoctorState {}

class GetDoctorSuccess extends DoctorState {
  final List<Doctor> doctors;

  GetDoctorSuccess({
    required this.doctors,
  });
}

class GetDoctorFail extends DoctorState {}
