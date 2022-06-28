import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:task_management/commons/widgets/app_text_field.dart';
import 'package:task_management/feature/patient/create_bill/model/doctor.dart';
import 'package:task_management/feature/patient/create_bill/model/patient.dart';
import 'package:task_management/feature/patient/create_bill/model/service.dart';
import 'package:task_management/feature/patient/create_bill/widgets/select_patient_bottom_sheet.dart';
import 'package:task_management/feature/patient/create_bill/widgets/select_doctor_bottom_sheet.dart';
import 'package:task_management/feature/patient/create_bill/widgets/select_service_bottom_sheet.dart';
import 'package:task_management/generated/locale_keys.g.dart';
import 'package:collection/collection.dart';

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

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final List<ServiceSelect> listService = [];

  @override
  Widget build(BuildContext context) {
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
                                      .firstWhereOrNull((currentService) => service.id == currentService.id);
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
                            children: const [
                              Icon(
                                Icons.medical_services_outlined,
                                color: Colors.green,
                              ),
                              Text("Dịch vụ"),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: const [
                            Icon(
                              Icons.medical_information_sharp,
                              color: Colors.green,
                            ),
                            Text("Thuốc"),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                  child: ListView(
                children: listService.map((e) => Text(e.serviceName)).toList(),
              )),
            ],
          ),
        ),
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
              patientController.text = value.patientName;
            });
          }
        });
      },
      child: AppTextField(
        enable: false,
        controller: patientController,
        label: "Bệnh nhân",
        hint: "Chọn bệnh nhân",
        errorMess: "Vui lòng chọn bệnh nhân!",
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
              doctorController.text = value.doctorName;
            });
          }
        });
      },
      child: AppTextField(
        enable: false,
        controller: doctorController,
        label: "Bác Sĩ",
        hint: "Chọn Bác Sĩ",
        errorMess: "Vui lòng chọn bác sĩ!",
        isRequire: true,
        prefixIcon: const Icon(
          Icons.person,
          color: Colors.grey,
        ),
      ),
    );
  }
}
