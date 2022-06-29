import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:sqflite/sqflite.dart';
import 'package:task_management/commons/widgets/app_text_field.dart';
import 'package:task_management/feature/patient/create_bill/model/patient.dart';
import 'package:task_management/generated/locale_keys.g.dart';
import 'package:task_management/main.dart';

class SelectPatient extends StatefulWidget {
  const SelectPatient({Key? key}) : super(key: key);

  @override
  State<SelectPatient> createState() => _SelectPatientState();
}

class _SelectPatientState extends State<SelectPatient> {
  List<Patient> allPatients = [];
  List<Patient> filterPatients = [];
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
      PatientProvider patientProvider = PatientProvider(db: db);
      allPatients = await patientProvider.getListPatient();
      if (allPatients.isNotEmpty) {
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
      filterPatients.clear();
      for (var patient in allPatients) {
        var patientName = patient.patientName.toLowerCase();
        var patientDateOfBirth = patient.patientDateOfBirth.toLowerCase();
        String s = searchKey.toLowerCase();
        if (patientName.contains(s) ||
            s.contains(patientName) ||
            patientDateOfBirth.contains(s) ||
            s.contains(patientDateOfBirth)) {
          filterPatients.add(patient);
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
                hint: LocaleKeys.txt_seatch_patient.tr(),
                label: LocaleKeys.txt_seatch.tr(),
                prefixIcon: const Icon(Icons.search),
                controller: _searchController,
              ),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: filterPatients.isNotEmpty
                    ? _renderListPatients()
                    : const Center(
                  child: Text("No patient"),
                ),
              ),
            ],
          ),
        ));
  }

  ListView _renderListPatients() {
    return ListView.separated(
      itemBuilder: (ctx, index) {
        return _renderPatient(filterPatients[index]);
      },
      separatorBuilder: (ctx, index) {
        return const Divider(
          height: 4,
          color: Colors.grey,
        );
      },
      itemCount: filterPatients.length,
    );
  }

  Widget _renderPatient(Patient patient) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context, patient);
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(8)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              patient.patientName,
              style: Theme
                  .of(context)
                  .textTheme
                  .headline6,
            ),
            const SizedBox(
              height: 6,
            ),
            Row(
              children: [
                const Text("Ngày sinh: "),
                const SizedBox(
                  width: 2,
                ),
                Text(patient.patientDateOfBirth),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
