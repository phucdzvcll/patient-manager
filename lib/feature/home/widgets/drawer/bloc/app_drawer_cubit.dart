import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'app_drawer_state.dart';

class AppDrawerCubit extends Cubit<AppDrawerState> {
  AppDrawerCubit() : super(AppDrawerInitial());
}
