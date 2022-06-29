import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:sqflite/sqflite.dart';
import 'package:task_management/commons/extensions/number.dart';
import 'package:task_management/commons/widgets/app_text_field.dart';
import 'package:task_management/feature/patient/create_bill/model/medicine.dart';
import 'package:task_management/generated/locale_keys.g.dart';
import 'package:task_management/main.dart';

class SelectMedicine extends StatefulWidget {
  const SelectMedicine({Key? key}) : super(key: key);

  @override
  State<SelectMedicine> createState() => _SelectMedicineState();
}

class _SelectMedicineState extends State<SelectMedicine> {
  List<MedicineSelect> allMedicine = [];
  List<MedicineSelect> filterMedicine = [];
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
      MedicineSelectProvider medicineProvider = MedicineSelectProvider(db: db);
      allMedicine = await medicineProvider.getMedicine();
      if (allMedicine.isNotEmpty) {
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
      filterMedicine.clear();
      for (var medicine in allMedicine) {
        var medicineName = medicine.medicineName.toLowerCase();
        var medicinePrice = medicine.price.toString().toLowerCase();
        String s = searchKey.toLowerCase();
        if (medicineName.contains(s) ||
            s.contains(medicineName) ||
            medicinePrice.contains(s) ||
            s.contains(medicinePrice)) {
          filterMedicine.add(medicine);
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
                      hint: LocaleKeys.txt_seatch_medicine.tr(),
                      label: LocaleKeys.txt_seatch.tr(),
                      prefixIcon: const Icon(Icons.search),
                      controller: _searchController,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Expanded(
                      child: filterMedicine.isNotEmpty
                          ? _renderListMedicine()
                          : const Center(
                              child: Text("No Medicine"),
                            ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        List<MedicineSelect> result = [];
                        if (allMedicine.isNotEmpty) {
                          for (var medicine in allMedicine) {
                            if (medicine.selected) {
                              result.add(medicine);
                            }
                          }
                        }
                        Navigator.pop(context, result);
                      },
                      child: Text(
                        LocaleKeys.txt_confirm.tr(),
                      ),
                    ),
                  ],
                ),
              ));
  }

  ListView _renderListMedicine() {
    return ListView.separated(
      itemBuilder: (ctx, index) {
        return _renderMedicine(filterMedicine[index]);
      },
      separatorBuilder: (ctx, index) {
        return const Divider(
          height: 4,
          color: Colors.grey,
        );
      },
      itemCount: filterMedicine.length,
    );
  }

  Widget _renderMedicine(MedicineSelect medicineSelect) {
    return GestureDetector(
      onTap: () {
        setState(() {
          medicineSelect.selected = !medicineSelect.selected;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(8)),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    medicineSelect.medicineName,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  Text(
                    LocaleKeys.txt_price
                        .tr(args: [medicineSelect.price.format()]),
                  ),
                ],
              ),
            ),
            Icon(
              medicineSelect.selected
                  ? Icons.check_box
                  : Icons.check_box_outline_blank,
              color: Colors.green,
            ),
          ],
        ),
      ),
    );
  }
}
