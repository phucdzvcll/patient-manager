import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_management/feature/doctor/bloc/doctor_cubit.dart';
import 'package:task_management/feature/doctor/bloc/doctor_state.dart';
import 'package:task_management/generated/locale_keys.g.dart';

class DoctorScreen extends StatelessWidget {
  const DoctorScreen({Key? key}) : super(key: key);
  static const String routeName = "/doctor-screen";

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DoctorCubit()..getDoctor(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(LocaleKeys.doctor_app_bar.tr()),
        ),
        body: Builder(builder: (context) {
          return BlocConsumer<DoctorCubit, DoctorState>(builder: (ctx, state) {
            return _renderBody(state);
          }, listener: (ctx, state) {
            if (state is GetDoctorFail) {
              showDialog(
                  context: context,
                  builder: (ctx) {
                    return SizedBox(
                      height: 200,
                      child: Text(LocaleKeys.mss_error.tr()),
                    );
                  });
            }
          });
        }),
      ),
    );
  }

  Widget _renderBody(DoctorState state) {
    if (state is DoctorLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else if (state is GetDoctorFail) {
      return Center(
        child: Text(
          LocaleKeys.mss_error.tr(),
        ),
      );
    } else if (state is GetDoctorSuccess) {
      return ListView.builder(
          itemBuilder: (ctx, index) {
            return Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 0.5)),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                child: Text(
                  state.doctors[index].doctorName,
                ),
              ),
            );
          },
          itemCount: state.doctors.length);
    }
    return const SizedBox.shrink();
  }
}
