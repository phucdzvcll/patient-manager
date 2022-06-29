import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:task_management/commons/extensions/number.dart';
import 'package:task_management/feature/patient/history/models/order_history.dart';
import 'package:task_management/feature/patient/history_detail/history_detail_screen.dart';
import 'package:task_management/generated/locale_keys.g.dart';
import 'package:task_management/main.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({Key? key}) : super(key: key);

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  final Database db = getIt.get();
  List<OrderHistory> orderHistory = [];

  @override
  void initState() {
    super.initState();
    _fetchListPatient();
  }

  void _fetchListPatient() async {
    try {
      OrderHistoryProvider patientProvider = OrderHistoryProvider(db: db);
      var _orderHistory = await patientProvider.getListOrderHistory();
      setState(() {
        orderHistory = _orderHistory;
      });
    } catch (e) {
      EasyLoading.showError(LocaleKeys.mss_error.tr());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.txt_history.tr()),
      ),
      body: ListView.separated(
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (ctx) {
                return HistoryDetailScreen(orderHistory: orderHistory[index]);
              }));
            },
            behavior: HitTestBehavior.opaque,
            child: _renderOrderHistory(orderHistory[index]),
          );
        },
        separatorBuilder: (context, index) {
          return const Divider(
            height: 12,
            color: Colors.black,
          );
        },
        itemCount: orderHistory.length,
      ),
    );
  }

  Widget _renderOrderHistory(OrderHistory e) {
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
              children:  [
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
                Text(e.orderNo.toString()),
                spacing,
                Text(e.doctorName),
                spacing,
                Text(e.patientName),
                spacing,
                Text(e.orderDate),
                spacing,
                Text("${e.totalPrice.format()} VNĐ"),
              ],
            ),
          )
        ],
      ),
    );
  }
}
