import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:task_management/commons/extensions/number.dart';
import 'package:task_management/feature/patient/history/models/order_history.dart';
import 'package:task_management/feature/patient/history_detail/models/medicine_detail.dart';
import 'package:task_management/feature/patient/history_detail/models/service_detail.dart';
import 'package:task_management/generated/locale_keys.g.dart';
import 'package:task_management/main.dart';

class HistoryDetailScreen extends StatefulWidget {
  const HistoryDetailScreen({
    Key? key,
    required this.orderHistory,
  }) : super(key: key);
  final OrderHistory orderHistory;

  @override
  State<HistoryDetailScreen> createState() => _HistoryDetailScreenState();
}

class _HistoryDetailScreenState extends State<HistoryDetailScreen> {
  List<ServiceDetail> serviceDetails = [];
  List<MedicineDetail> medicineDetails = [];
  final Database db = getIt.get();

  @override
  void initState() {
    super.initState();
    _fetchListPatient();
  }

  void _fetchListPatient() async {
    try {
      db.transaction((txn) async {
        ServiceDetailProvider serviceDetailProvider =
            ServiceDetailProvider(transaction: txn);
        List<ServiceDetail> s1 = await serviceDetailProvider
            .getServiceDetail(widget.orderHistory.orderNo);
        MedicineDetailDetailProvider medicineDetailDetailProvider =
            MedicineDetailDetailProvider(transaction: txn);
        var s2 = await medicineDetailDetailProvider
            .getServiceDetail(widget.orderHistory.orderNo);
        setState(() {
          serviceDetails = s1;
          medicineDetails = s2;
        });
      });
    } catch (e) {
      EasyLoading.showError(LocaleKeys.mss_error.tr());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.txt_history_detail.tr()),
      ),
      body: SingleChildScrollView(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _renderOrderHeader(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              LocaleKeys.service.tr(),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          ListView.separated(
            shrinkWrap: true,
            padding: const EdgeInsets.all(12),
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return _renderServiceItem(serviceDetails[index]);
            },
            separatorBuilder: (ctx, index) {
              return const Divider(
                height: 12,
              );
            },
            itemCount: serviceDetails.length,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              LocaleKeys.medicine.tr(),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          ListView.separated(
            shrinkWrap: true,
            padding: const EdgeInsets.all(12),
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return _renderMedicineItem(medicineDetails[index]);
            },
            separatorBuilder: (ctx, index) {
              return const Divider(
                height: 12,
              );
            },
            itemCount: medicineDetails.length,
          ),
        ],
      )),
    );
  }

  Widget _renderMedicineItem(MedicineDetail medicineSelect) {
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
              Text("/${medicineSelect.unit}"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _renderServiceItem(ServiceDetail service) {
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
          Text(LocaleKeys.txt_price.tr(args: [service.price.format()])),
        ],
      ),
    );
  }

  Widget _renderOrderHeader() {
    const titleStyle = TextStyle(fontWeight: FontWeight.bold);
    const spacing = SizedBox(height: 4);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  LocaleKeys.txt_order_no.tr(),
                  style: titleStyle,
                ),
                spacing,
                Text(
                  LocaleKeys.txt_doctor_name.tr(),
                  style: titleStyle,
                ),
                spacing,
                Text(
                  LocaleKeys.txt_patient_name.tr(),
                  style: titleStyle,
                ),
                spacing,
                Text(
                  LocaleKeys.txt_order_date.tr(),
                  style: titleStyle,
                ),
                spacing,
                Text(
                  LocaleKeys.txt_total_price.tr(),
                  style: titleStyle,
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(":"),
              spacing,
              Text(":"),
              spacing,
              Text(":"),
              spacing,
              Text(":"),
              spacing,
              Text(":"),
            ],
          ),
          const SizedBox(width: 5),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.orderHistory.orderNo.toString()),
                spacing,
                Text(widget.orderHistory.doctorName),
                spacing,
                Text(widget.orderHistory.patientName),
                spacing,
                Text(widget.orderHistory.orderDate),
                spacing,
                Text("${widget.orderHistory.totalPrice.format()} VNĐ"),
              ],
            ),
          )
        ],
      ),
    );
  }
}
