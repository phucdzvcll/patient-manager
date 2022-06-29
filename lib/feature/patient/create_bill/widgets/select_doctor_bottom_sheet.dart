import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:sqflite/sqflite.dart';
import 'package:task_management/commons/widgets/app_text_field.dart';
import 'package:task_management/feature/patient/create_bill/model/doctor.dart';
import 'package:task_management/generated/locale_keys.g.dart';
import 'package:task_management/main.dart';

class SelectDoctor extends StatefulWidget {
  const SelectDoctor({Key? key}) : super(key: key);

  @override
  State<SelectDoctor> createState() => _SelectDoctorState();
}

class _SelectDoctorState extends State<SelectDoctor> {
  List<Doctor> allDoctor = [];
  List<Doctor> filterDoctor = [];
  final Database db = getIt.get();
  bool loading = true;
  String searchKey = "";
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      searchKey = _searchController.text;
      _searchAction();
    });
    _fetchListPatient();
  }

  void _fetchListPatient() async {
    try {
      DoctorProvider patientProvider = DoctorProvider(db: db);
      allDoctor = await patientProvider.getDoctor();
      if (allDoctor.isNotEmpty) {
        _searchAction();
      }
      setState(() {
        loading = false;
      });
    } catch (e) {
      EasyLoading.showError(LocaleKeys.mss_error.tr()).then((value) {
        setState(() {
          loading = false;
        });
      });
    }
  }

  void _searchAction() {
    setState(() {
      filterDoctor.clear();
      for (var patient in allDoctor) {
        var patientName = patient.doctorName.toLowerCase();
        String s = searchKey.toLowerCase();
        if (patientName.contains(s) || s.contains(patientName)) {
          filterDoctor.add(patient);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 700,
        color: const Color(0xffdfdfdf),
        child: loading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    AppTextField(
                      hint: LocaleKeys.txt_seatch_doctor.tr(),
                      label: LocaleKeys.txt_seatch.tr(),
                      prefixIcon: const Icon(Icons.search),
                      controller: _searchController,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Expanded(
                      child: filterDoctor.isNotEmpty
                          ? _renderListPatients()
                          : const Center(
                              child: Text("No doctor"),
                            ),
                    ),
                  ],
                ),
              ));
  }

  ListView _renderListPatients() {
    return ListView.separated(
      itemBuilder: (ctx, index) {
        return _renderDoctor(filterDoctor[index]);
      },
      separatorBuilder: (ctx, index) {
        return const Divider(
          height: 4,
          color: Colors.grey,
        );
      },
      itemCount: filterDoctor.length,
    );
  }

  Widget _renderDoctor(Doctor patient) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context, patient);
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(8)),
        child: Text(
          patient.doctorName,
          style: Theme.of(context).textTheme.headline6,
        ),
      ),
    );
  }
}
