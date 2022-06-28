import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:task_management/commons/widgets/app_text_field.dart';
import 'package:task_management/feature/patient/add_new_patient/bloc/add_patient_cubit.dart';
import 'package:task_management/generated/locale_keys.g.dart';

class AddPatientScreen extends StatefulWidget {
  const AddPatientScreen({Key? key}) : super(key: key);

  @override
  State<AddPatientScreen> createState() => _AddPatientScreenState();
}

class _AddPatientScreenState extends State<AddPatientScreen> {
  final TextEditingController patientNameController = TextEditingController();
  final TextEditingController patientGenderController = TextEditingController();
  final TextEditingController patientDateOfBirthController =
      TextEditingController();
  final TextEditingController hospitalizedDayController =
      TextEditingController();
  final TextEditingController hospitalDischargeDateController =
      TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final DateFormat dateFormat = DateFormat('dd/MM/yyyy');
  int patientGender = -1;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: BlocProvider(
        create: (context) => AddPatientCubit(),
        child: Scaffold(
          appBar: AppBar(
            title: Text(LocaleKeys.txt_add_patient.tr()),
          ),
          body: BlocListener<AddPatientCubit, AddPatientState>(
            listener: (context, state) {
              if (state is AddPatientFail) {
                EasyLoading.showError(LocaleKeys.mss_error.tr());
              } else {
                _dialogSuccess(context).then(
                  (value) => Navigator.pop(context),
                );
              }
            },
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            _renderPatientNameInput(context),
                            const SizedBox(
                              height: 30,
                            ),
                            _renderPatientDateOfBirthInput(context),
                            const SizedBox(
                              height: 30,
                            ),
                            _renderPatientSexInput(context),
                            const SizedBox(
                              height: 30,
                            ),
                            _renderHospitalizedDayInput(context),
                            const SizedBox(
                              height: 30,
                            ),
                            _renderHospitalDischargeDateInput(context),
                          ],
                        ),
                      ),
                    ),
                    Builder(builder: (context) {
                      return ElevatedButton(
                        onPressed: () {
                          FocusScope.of(context).unfocus();
                          if (_validate(context) && patientGender != -1) {
                            BlocProvider.of<AddPatientCubit>(context)
                                .savePatient(
                              patientDateOfBirth:
                                  patientDateOfBirthController.text,
                              gender: patientGender,
                              hospitalDischargeDate:
                                  hospitalDischargeDateController.text,
                              hospitalizedDay: hospitalizedDayController.text,
                              patientName: patientNameController.text,
                            );
                          }
                        },
                        child: Text(LocaleKeys.txt_save.tr()),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _renderPatientNameInput(BuildContext context) {
    return AppTextField(
      controller: patientNameController,
      label: LocaleKeys.txt_patient_name_label.tr(),
      hint: LocaleKeys.txt_patient_name_hint.tr(),
      isRequire: true,
      enable: true,
      prefixIcon: const Icon(
        Icons.person_outline_rounded,
        color: Colors.grey,
      ),
      errorMess: LocaleKeys.txt_patient_name_error.tr(),
    );
  }

  Widget _renderPatientSexInput(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusScope.of(context).unfocus();
        _renderSelectGender(context).then((value) {
          if (value is int) {
            patientGender = value;
            switch (value) {
              case 1:
                patientGenderController.text = LocaleKeys.txt_male.tr();
                break;
              case 0:
                patientGenderController.text = LocaleKeys.txt_female.tr();
                break;
              default:
                patientGenderController.text = LocaleKeys.txt_male.tr();
                break;
            }
          }
        });
      },
      child: AppTextField(
        controller: patientGenderController,
        label: LocaleKeys.txt_patient_gender_label.tr(),
        hint: LocaleKeys.txt_patient_gender_hint.tr(),
        isRequire: true,
        enable: false,
        prefixIcon: const Icon(
          Icons.transgender,
          color: Colors.grey,
        ),
        errorMess: LocaleKeys.txt_patient_gender_error.tr(),
      ),
    );
  }

  Future<dynamic> _renderSelectGender(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return SizedBox(
            height: 200,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context, 1);
                  },
                  behavior: HitTestBehavior.opaque,
                  child: SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: Text(
                        LocaleKeys.txt_male.tr(),
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ),
                  ),
                ),
                const Divider(
                  height: 1,
                  color: Colors.black,
                ),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    Navigator.pop(context, 0);
                  },
                  child: SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: Text(
                        LocaleKeys.txt_female.tr(),
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ),
                  ),
                ),
                const Divider(
                  height: 1,
                  color: Colors.black,
                ),
              ],
            ),
          );
        });
  }

  Widget _renderHospitalizedDayInput(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusScope.of(context).unfocus();
        _dialogDatePicker(
          context,
          hospitalizedDayController.text,
        ).then((value) {
          if (value is String) {
            setState(() {
              hospitalizedDayController.value = TextEditingValue(text: value);
            });
          }
        });
      },
      child: Stack(
        children: [
          AppTextField(
            enable: false,
            controller: hospitalizedDayController,
            label: LocaleKeys.txt_hospitalized_day_label.tr(),
            hint: LocaleKeys.txt_hospitalized_day_hint.tr(),
            isRequire: false,
            prefixIcon: const Icon(
              Icons.calendar_month,
              color: Colors.grey,
            ),
          ),
          hospitalizedDayController.text.isNotEmpty
              ? Positioned(
                  right: 8,
                  bottom: 17,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        hospitalizedDayController.text = "";
                      });
                    },
                    child: const Icon(
                      Icons.highlight_remove_sharp,
                      color: Colors.black,
                    ),
                  ),
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }

  Widget _renderHospitalDischargeDateInput(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusScope.of(context).unfocus();
        _dialogDatePicker(
          context,
          hospitalDischargeDateController.text,
        ).then((value) {
          if (value is String) {
            setState(() {
              hospitalDischargeDateController.value =
                  TextEditingValue(text: value);
            });
          }
        });
      },
      child: Stack(
        children: [
          AppTextField(
            enable: false,
            controller: hospitalDischargeDateController,
            label: LocaleKeys.txt_hospital_discharge_date_label.tr(),
            hint: LocaleKeys.txt_hospital_discharge_date_hint.tr(),
            isRequire: false,
            prefixIcon: const Icon(
              Icons.calendar_month,
              color: Colors.grey,
            ),
          ),
          hospitalDischargeDateController.text.isNotEmpty
              ? Positioned(
                  right: 8,
                  bottom: 17,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        hospitalDischargeDateController.text = "";
                      });
                    },
                    child: const Icon(
                      Icons.highlight_remove_sharp,
                      color: Colors.black,
                    ),
                  ),
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }

  Widget _renderPatientDateOfBirthInput(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusScope.of(context).unfocus();
        _dialogDatePicker(
          context,
          patientDateOfBirthController.text,
        ).then((value) {
          if (value is String) {
            setState(() {
              patientDateOfBirthController.value =
                  TextEditingValue(text: value);
            });
          }
        });
      },
      child: AppTextField(
        enable: false,
        controller: patientDateOfBirthController,
        label: LocaleKeys.txt_select_patient_of_date_birth_label.tr(),
        hint: LocaleKeys.txt_select_patient_of_date_birth_hint.tr(),
        isRequire: true,
        prefixIcon: const Icon(
          Icons.calendar_month,
          color: Colors.grey,
        ),
        errorMess: LocaleKeys.txt_patient_date_of_birth_error.tr(),
      ),
    );
  }

  Future<dynamic> _dialogDatePicker(
    BuildContext context,
    String initDate,
  ) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          String s = "";
          return Column(
            children: [
              Expanded(
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.date,
                  initialDateTime: initDate.isNotEmpty
                      ? dateFormat.parse(initDate)
                      : DateTime.now(),
                  onDateTimeChanged: (time) {
                    s = dateFormat.format(time);
                  },
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, s);
                },
                child: Text(LocaleKeys.txt_confirm.tr()),
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          );
        });
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
