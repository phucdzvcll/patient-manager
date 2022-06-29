import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_management/commons/extensions/number.dart';
import 'package:task_management/feature/medicine/bloc/medicine_cubit.dart';
import 'package:task_management/feature/medicine/bloc/medicine_state.dart';
import 'package:task_management/generated/locale_keys.g.dart';

class MedicineScreen extends StatelessWidget {
  const MedicineScreen({Key? key}) : super(key: key);
  static const String routeName = "/medicine-screen";

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MedicineCubit()..getMedicines(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(LocaleKeys.txt_medicine_info.tr()),
        ),
        body: Builder(builder: (context) {
          return BlocConsumer<MedicineCubit, MedicineState>(
              builder: (ctx, state) {
            return _renderBody(state);
          }, listener: (ctx, state) {
            if (state is GetMedicineFail) {
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

  Widget _renderBody(MedicineState state) {
    if (state is MedicineLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else if (state is GetMedicineFail) {
      return Center(
        child: Text(LocaleKeys.mss_error.tr()),
      );
    } else if (state is GetMedicineSuccess) {
      return ListView.builder(
          itemBuilder: (ctx, index) {
            return Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 0.5)),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      state.medicines[index].medicineName,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Text(LocaleKeys.txt_price
                            .tr(args: [state.medicines[index].price.format()])),
                        Text("/ ${state.medicines[index].unit}")
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
          itemCount: state.medicines.length);
    }
    return const SizedBox.shrink();
  }
}
