import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_management/commons/extensions/number.dart';
import 'package:task_management/feature/service/bloc/service_cubit.dart';
import 'package:task_management/feature/service/bloc/service_state.dart';
import 'package:task_management/generated/locale_keys.g.dart';

class ServiceScreen extends StatelessWidget {
  const ServiceScreen({Key? key}) : super(key: key);
  static const String routeName = "/service-screen";

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ServiceCubit()..getServices(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(LocaleKeys.service_app_bar.tr()),
        ),
        body: Builder(builder: (context) {
          return BlocConsumer<ServiceCubit, ServiceState>(
              builder: (ctx, state) {
            return _renderBody(state);
          }, listener: (ctx, state) {
            if (state is GetServiceFail) {
              showDialog(
                  context: context,
                  builder: (ctx) {
                    return SizedBox(
                      height: 200,
                      child: Text(LocaleKeys.mss_error.tr()),
                    );
                  });
            }
          });
        }),
      ),
    );
  }

  Widget _renderBody(ServiceState state) {
    if (state is ServiceLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else if (state is GetServiceFail) {
      return Center(
        child: Text(LocaleKeys.mss_error.tr()),
      );
    } else if (state is GetServiceSuccess) {
      return ListView.builder(
          itemBuilder: (ctx, index) {
            return Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 0.5)),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      state.services[index].serviceName,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(LocaleKeys.txt_price
                        .tr(args: [state.services[index].price.format()])),
                  ],
                ),
              ),
            );
          },
          itemCount: state.services.length);
    }
    return const SizedBox.shrink();
  }
}
