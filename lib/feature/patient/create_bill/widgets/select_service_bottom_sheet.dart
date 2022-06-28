import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:sqflite/sqflite.dart';
import 'package:task_management/commons/extensions/number.dart';
import 'package:task_management/commons/widgets/app_text_field.dart';
import 'package:task_management/feature/patient/create_bill/model/service.dart';
import 'package:task_management/generated/locale_keys.g.dart';
import 'package:task_management/main.dart';

class SelectService extends StatefulWidget {
  const SelectService({Key? key}) : super(key: key);

  @override
  State<SelectService> createState() => _SelectServiceState();
}

class _SelectServiceState extends State<SelectService> {
  List<ServiceSelect> allService = [];
  List<ServiceSelect> filterService = [];
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
      ServiceSelectProvider serviceProvider = ServiceSelectProvider(db: db);
      allService = await serviceProvider.getDoctor();
      if (allService.isNotEmpty) {
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
      filterService.clear();
      for (var service in allService) {
        var serviceName = service.serviceName.toLowerCase();
        var servicePrice = service.price.toString().toLowerCase();
        String s = searchKey.toLowerCase();
        if (serviceName.contains(s) ||
            s.contains(serviceName) ||
            servicePrice.contains(s) ||
            s.contains(servicePrice)) {
          filterService.add(service);
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
                      hint: "Tìm dịch vụ",
                      label: "Tìm kiếm",
                      prefixIcon: const Icon(Icons.search),
                      controller: _searchController,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Expanded(
                      child: filterService.isNotEmpty
                          ? _renderListService()
                          : const Center(
                              child: Text("No Service"),
                            ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        List<ServiceSelect> result = [];
                        if (allService.isNotEmpty) {
                          for (var service in allService) {
                            if (service.selected) {
                              result.add(service);
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

  ListView _renderListService() {
    return ListView.separated(
      itemBuilder: (ctx, index) {
        return _renderService(filterService[index]);
      },
      separatorBuilder: (ctx, index) {
        return const Divider(
          height: 4,
          color: Colors.grey,
        );
      },
      itemCount: filterService.length,
    );
  }

  Widget _renderService(ServiceSelect service) {
    return GestureDetector(
      onTap: () {
        setState(() {
          service.selected = !service.selected;
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
                    service.serviceName,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  Row(
                    children: [
                      const Text("Giá: "),
                      const SizedBox(
                        width: 2,
                      ),
                      Text(service.price.format()),
                      const Text(" VNĐ"),
                    ],
                  ),
                ],
              ),
            ),
            Icon(
              service.selected
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
