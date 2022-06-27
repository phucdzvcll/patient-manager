import 'package:flutter/foundation.dart';
import 'package:task_management/feature/service/bloc/service_cubit.dart';


@immutable
abstract class ServiceState {}

class ServiceLoading extends ServiceState {}

class GetServiceSuccess extends ServiceState {
  final List<Service> services;

  GetServiceSuccess({
    required this.services,
  });
}

class GetServiceFail extends ServiceState {}
