import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:task_management/feature/patient/add_new_patient/add_patient_screen.dart';
import 'package:task_management/feature/patient/create_bill/create_bill_screen.dart';
import 'package:task_management/feature/patient/history/order_history_screen.dart';
import 'package:task_management/generated/locale_keys.g.dart';

class PatientMenu extends StatelessWidget {
  const PatientMenu({Key? key}) : super(key: key);

  static const routeName = "/patient-menu";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.patients.tr()),
      ),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.green, width: 1.35),
                      ),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddPatientScreen()));
                        },
                        behavior: HitTestBehavior.opaque,
                        child: Center(
                          child: Column(
                            children: [
                              const Expanded(
                                child: Icon(
                                  Icons.add_circle_outline,
                                  size: 100,
                                  color: Colors.blue,
                                ),
                              ),
                              Text(
                                LocaleKeys.txt_add_patient.tr(),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                        fontSize: 20, color: Colors.green),
                              ),
                              const SizedBox(
                                height: 20,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.blue, width: 1.35),
                      ),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const CreateBillScreen()));
                        },
                        behavior: HitTestBehavior.opaque,
                        child: Center(
                          child: Column(
                            children: [
                              const Expanded(
                                child: Icon(
                                  Icons.change_history_rounded,
                                  size: 100,
                                  color: Colors.green,
                                ),
                              ),
                              Text(
                                LocaleKeys.txt_create_bill.tr(),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                        fontSize: 20, color: Colors.blueAccent),
                              ),
                              const SizedBox(
                                height: 20,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.purple, width: 1.35),
                      ),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (ctx) => const OrderHistoryScreen()));
                        },
                        behavior: HitTestBehavior.opaque,
                        child: Center(
                          child: Column(
                            children: [
                              const Expanded(
                                child: Icon(
                                  Icons.history,
                                  size: 100,
                                  color: Colors.deepOrange,
                                ),
                              ),
                              Text(
                                LocaleKeys.txt_history.tr(),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                        fontSize: 20, color: Colors.brown),
                              ),
                              const SizedBox(
                                height: 20,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(child: const SizedBox()),
            ],
          )
        ],
      ),
    );
  }
}
