import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:task_management/commons/extensions/number.dart';
import 'package:task_management/commons/widgets/app_text_field.dart';
import 'package:task_management/commons/widgets/tw_swipe_for_delete.dart';
import 'package:task_management/feature/patient/create_bill/model/doctor.dart';
import 'package:task_management/feature/patient/create_bill/model/medicine.dart';
import 'package:task_management/feature/patient/create_bill/model/medicine_by_order.dart';
import 'package:task_management/feature/patient/create_bill/model/order.dart';
import 'package:task_management/feature/patient/create_bill/model/patient.dart';
import 'package:task_management/feature/patient/create_bill/model/service.dart';
import 'package:task_management/feature/patient/create_bill/model/service_by_order.dart';
import 'package:task_management/feature/patient/create_bill/widgets/select_medicine_bottom_sheet.dart';
import 'package:task_management/feature/patient/create_bill/widgets/select_patient_bottom_sheet.dart';
import 'package:task_management/feature/patient/create_bill/widgets/select_doctor_bottom_sheet.dart';
import 'package:task_management/feature/patient/create_bill/widgets/select_service_bottom_sheet.dart';
import 'package:task_management/generated/locale_keys.g.dart';
import 'package:collection/collection.dart';
import 'package:task_management/main.dart';

class CreateBillScreen extends StatefulWidget {
  const CreateBillScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<CreateBillScreen> createState() => _CreateBillScreenState();
}

class _CreateBillScreenState extends State<CreateBillScreen> {
  final patientController = TextEditingController();
  final doctorController = TextEditingController();
  Patient? patient;
  Doctor? doctor;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final List<ServiceSelect> listService = [];
  final List<MedicineSelect> listMedicine = [];
  final DateFormat dateFormat = DateFormat('dd/MM/yyyy');

  @override
  Widget build(BuildContext context) {
    double totalPrice = 0;
    for (var element in listService) {
      totalPrice += element.price;
    }
    for (var element in listMedicine) {
      totalPrice += element.price;
    }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(LocaleKeys.txt_create_bill.tr()),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _renderSelectPatient(context),
              const SizedBox(
                height: 30,
              ),
              _renderSelectDoctor(context),
              const SizedBox(
                height: 20,
              ),
              Container(
                color: const Color(0xfffff6d3),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return const SelectService();
                            },
                            isScrollControlled: true,
                          ).then((value) {
                            if (value is List<ServiceSelect>) {
                              setState(() {
                                for (var service in value) {
                                  ServiceSelect? serviceSelect = listService
                                      .firstWhereOrNull((currentService) =>
                                          service.id == currentService.id);
                                  if (serviceSelect == null) {
                                    listService.add(service);
                                  }
                                }
                              });
                            }
                          });
                        },
                        behavior: HitTestBehavior.opaque,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              const Icon(
                                Icons.medical_services_outlined,
                                color: Colors.green,
                              ),
                              Text(LocaleKeys.service.tr()),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return const SelectMedicine();
                            },
                            isScrollControlled: true,
                          ).then((value) {
                            if (value is List<MedicineSelect>) {
                              setState(() {
                                for (var medicine in value) {
                                  MedicineSelect? m = listMedicine
                                      .firstWhereOrNull((currentMedicine) =>
                                          medicine.id == currentMedicine.id);
                                  if (m == null) {
                                    listMedicine.add(medicine);
                                  }
                                }
                              });
                            }
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              const Icon(
                                Icons.medical_information_sharp,
                                color: Colors.green,
                              ),
                              Text(LocaleKeys.medicine.tr()),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Text(
                    LocaleKeys.txt_total.tr(),
                  ),
                  Text(
                    totalPrice.format(),
                  ),
                  const Text(
                    " VNĐ ",
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _renderService(context),
                      const SizedBox(
                        height: 20,
                      ),
                      _renderMedicine(context),
                    ],
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: (listMedicine.isEmpty && listService.isEmpty)
                    ? null
                    : () async {
                        var isValid = _validate(context);
                        if (isValid && patient != null && doctor != null) {
                          EasyLoading.show(
                              maskType: EasyLoadingMaskType.black,
                              dismissOnTap: false);
                          try {
                            Database db = getIt.get();
                            db.transaction((txn) async {
                              OrderProvider orderProvider =
                                  OrderProvider(transaction: txn);

                              int orderNo = await orderProvider.insert(Order(
                                patientId: patient!.patientId,
                                doctorId: doctor!.id,
                                totalPrice: totalPrice,
                                orderDate: dateFormat.format(DateTime.now()),
                              ));

                              ServiceByOrderProvider serviceByOrderProvider =
                                  ServiceByOrderProvider(transaction: txn);

                              for (var element in listService) {
                                await serviceByOrderProvider
                                    .insert(ServiceByOrder(
                                  orderNo: orderNo,
                                  serviceId: element.id,
                                  price: element.price,
                                ));
                              }

                              MedicineByOrderProvider medicineByOrderProvider =
                                  MedicineByOrderProvider(transaction: txn);

                              for (var element in listMedicine) {
                                await medicineByOrderProvider
                                    .insert(MedicineByOrder(
                                  orderNo: orderNo,
                                  medicineId: element.id,
                                  price: element.price,
                                ));
                              }
                              EasyLoading.dismiss();
                              _dialogSuccess(context).then((value) {
                                Navigator.pop(context, orderNo);
                              });
                            });
                          } catch (e) {
                            log(1);
                            EasyLoading.dismiss();
                            EasyLoading.showError(LocaleKeys.mss_error.tr());
                          }
                        }
                      },
                child: Text(LocaleKeys.txt_create_bill.tr()),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ExpandablePanel _renderService(BuildContext context) {
    return ExpandablePanel(
      theme: const ExpandableThemeData(
          tapHeaderToExpand: true,
          tapBodyToCollapse: true,
          iconPlacement: ExpandablePanelIconPlacement.left,
          hasIcon: true,
          collapseIcon: Icons.arrow_drop_up,
          expandIcon: Icons.arrow_drop_down,
          iconColor: Colors.grey,
          headerAlignment: ExpandablePanelHeaderAlignment.center),
      header: _renderServiceHeader(context),
      collapsed: const SizedBox.shrink(),
      expanded: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: _renderListService(),
      ),
    );
  }

  ExpandablePanel _renderMedicine(BuildContext context) {
    return ExpandablePanel(
      theme: const ExpandableThemeData(
          tapHeaderToExpand: true,
          tapBodyToCollapse: true,
          iconPlacement: ExpandablePanelIconPlacement.left,
          hasIcon: true,
          collapseIcon: Icons.arrow_drop_up,
          expandIcon: Icons.arrow_drop_down,
          iconColor: Colors.grey,
          headerAlignment: ExpandablePanelHeaderAlignment.center),
      header: _renderMedicineHeader(context),
      collapsed: const SizedBox.shrink(),
      expanded: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: _renderListMedicine(),
      ),
    );
  }

  Widget _renderServiceHeader(BuildContext context) {
    double totalPrice = 0;
    for (var element in listService) {
      totalPrice += element.price;
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.service.tr(),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(
          height: 5,
        ),
        Row(
          children: [
            Text(
              LocaleKeys.txt_total.tr(),
            ),
            Text(
              totalPrice.format(),
            ),
            const Text(
              " VNĐ ",
            ),
          ],
        ),
      ],
    );
  }

  Widget _renderMedicineHeader(BuildContext context) {
    double totalPrice = 0;
    for (var element in listMedicine) {
      totalPrice += element.price;
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.medicine.tr(),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(
          height: 5,
        ),
        Row(
          children: [
            Text(
              LocaleKeys.txt_total.tr(),
            ),
            Text(
              totalPrice.format(),
            ),
            const Text(
              " VNĐ ",
            ),
          ],
        ),
      ],
    );
  }

  ListView _renderListService() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (ctx, index) {
        return TWSwipeLeftForDeleteTile(
          deleteAction: () {
            setState(() {
              listService.remove(listService[index]);
            });
          },
          key: ValueKey(listService[index].id),
          child: _renderServiceItem(listService[index]),
        );
      },
      separatorBuilder: (ctx, index) {
        return const Divider(
          height: 12,
        );
      },
      itemCount: listService.length,
    );
  }

  ListView _renderListMedicine() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (ctx, index) {
        return TWSwipeLeftForDeleteTile(
          deleteAction: () {
            setState(() {
              listMedicine.remove(listMedicine[index]);
            });
          },
          key: ValueKey(listMedicine[index].id),
          child: _renderMedicineItem(listMedicine[index]),
        );
      },
      separatorBuilder: (ctx, index) {
        return const Divider(
          height: 12,
        );
      },
      itemCount: listMedicine.length,
    );
  }

  Widget _renderServiceItem(ServiceSelect service) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            service.serviceName,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            LocaleKeys.txt_price.tr(args: [service.price.format()]),
          ),
        ],
      ),
    );
  }

  Widget _renderMedicineItem(MedicineSelect medicineSelect) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            medicineSelect.medicineName,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Text(LocaleKeys.txt_price
                  .tr(args: [medicineSelect.price.format()])),
              Text(" /${medicineSelect.unit}"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _renderSelectPatient(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (context) {
            return const SelectPatient();
          },
          isScrollControlled: true,
        ).then((value) {
          if (value is Patient) {
            setState(() {
              patient = value;
              patientController.text = value.patientName;
            });
          }
        });
      },
      child: AppTextField(
        enable: false,
        controller: patientController,
        label: LocaleKeys.patients.tr(),
        hint: LocaleKeys.txt_select_doctor_hint.tr(),
        errorMess: LocaleKeys.txt_select_patient_error.tr(),
        isRequire: true,
        prefixIcon: const Icon(
          Icons.person,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _renderSelectDoctor(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (context) {
            return const SelectDoctor();
          },
          isScrollControlled: true,
        ).then((value) {
          if (value is Doctor) {
            setState(() {
              doctor = value;
              doctorController.text = value.doctorName;
            });
          }
        });
      },
      child: AppTextField(
        enable: false,
        controller: doctorController,
        label: LocaleKeys.doctor.tr(),
        hint: LocaleKeys.txt_select_doctor_hint.tr(),
        errorMess: LocaleKeys.txt_select_doctor_error.tr(),
        isRequire: true,
        prefixIcon: const Icon(
          Icons.person,
          color: Colors.grey,
        ),
      ),
    );
  }

  bool _validate(BuildContext context) {
    final form = _formKey.currentState;
    return form?.validate() ?? false;
  }

  Future<dynamic> _dialogSuccess(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) {
          return Center(
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.green, width: 2),
              ),
              child: Scaffold(
                backgroundColor: Colors.transparent,
                body: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    const Center(
                      child: Icon(
                        Icons.check,
                        color: Colors.green,
                        size: 72,
                      ),
                    ),
                    const Spacer(),
                    Center(
                      child: Text(
                        LocaleKeys.txt_success.tr(),
                        style: Theme.of(context).textTheme.displayMedium,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("OK"),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}
