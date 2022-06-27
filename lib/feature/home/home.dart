import 'dart:async';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:task_management/commons/presentation/res/color.dart';
import 'package:task_management/feature/doctor/doctor_screen.dart';
import 'package:task_management/feature/home/widgets/drawable.dart';
import 'package:task_management/feature/home/widgets/task_group.dart';
import 'package:task_management/feature/medicine/medicine_screen.dart';
import 'package:task_management/feature/service/service_screen.dart';
import 'package:task_management/generated/assets.gen.dart';
import 'package:task_management/generated/locale_keys.g.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _warningBeforeExitApp(context);
        return false;
      },
      child: Scaffold(
        drawer: const AppDrawer(),
        drawerEnableOpenDragGesture: false,
        appBar: AppBar(
          centerTitle: true,
          leading: Builder(builder: (context) {
            return IconButton(
              icon: const Icon(
                Icons.menu,
                color: Colors.white,
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          }),
          backgroundColor: AppColors.primaryColor,
          title: Text(
            LocaleKeys.app_title.tr(),
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                fontWeight: FontWeight.bold, fontSize: 22, color: Colors.white),
          ),
        ),
        body: _buildBody(),
      ),
    );
  }

  Future<dynamic> _warningBeforeExitApp(BuildContext context) {
    return showDialog(
        context: context,
        builder: (ctx) {
          return Center(
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.deepOrange, width: 2),
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
                        Icons.warning,
                        color: Colors.red,
                        size: 72,
                      ),
                    ),
                    const Spacer(),
                    Center(
                      child: Text(
                        LocaleKeys.mss_warning_exit.tr(),
                        style: Theme.of(context).textTheme.displayMedium,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      width: double.infinity,
                      height: 0.5,
                      color: Colors.black,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(LocaleKeys.txt_cancel.tr()),
                          ),
                        ),
                        Expanded(
                          child: DecoratedBox(
                            decoration: const BoxDecoration(
                                border: Border(
                              left: BorderSide(
                                color: Colors.black,
                                width: 0.5,
                              ),
                            )),
                            child: TextButton(
                              onPressed: () {
                                exit(0);
                              },
                              child: Text(LocaleKeys.txt_yes.tr()),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  Stack _buildBody() {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 10,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 10,
                ),
                const SizedBox(
                  height: 15,
                ),
                buildGrid(),
                const SizedBox(
                  height: 25,
                ),
                const OnGoingTask(),
                const SizedBox(
                  height: 40,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  StaggeredGrid buildGrid() {
    return StaggeredGrid.count(
      crossAxisCount: 2,
      mainAxisSpacing: 15,
      crossAxisSpacing: 15,
      children: [
        StaggeredGridTile.count(
          crossAxisCellCount: 1,
          mainAxisCellCount: 1.3,
          child: TaskGroupContainer(
              color: Colors.lightGreen,
              icon: Assets.images.patient.image(width: 120, height: 160),
              title: LocaleKeys.patients.tr()),
        ),
        StaggeredGridTile.count(
          crossAxisCellCount: 1,
          mainAxisCellCount: 1,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              Navigator.pushNamed(context, DoctorScreen.routeName);
            },
            child: TaskGroupContainer(
              color: Colors.orange,
              icon: Assets.images.doctor.image(width: 100, height: 100),
              title: LocaleKeys.doctor.tr(),
            ),
          ),
        ),
        StaggeredGridTile.count(
          crossAxisCellCount: 1,
          mainAxisCellCount: 1.3,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              Navigator.pushNamed(context, ServiceScreen.routeName);
            },
            child: TaskGroupContainer(
                color: Colors.green,
                icon: SizedBox(
                  width: 120,
                  height: 120,
                  child: Assets.images.insurance.image(fit: BoxFit.fill),
                ),
                title: LocaleKeys.service.tr()),
          ),
        ),
        StaggeredGridTile.count(
          crossAxisCellCount: 1,
          mainAxisCellCount: 1,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              Navigator.pushNamed(context, MedicineScreen.routeName);
            },
            child: TaskGroupContainer(
                color: Colors.blue,
                icon: SizedBox(
                  width: 100,
                  height: 100,
                  child: Assets.images.medicine.image(fit: BoxFit.fill),
                ),
                title: LocaleKeys.medicine.tr()),
          ),
        ),
      ],
    );
  }
}

class OnGoingTask extends StatefulWidget {
  const OnGoingTask({
    Key? key,
  }) : super(key: key);

  @override
  State<OnGoingTask> createState() => _OnGoingTaskState();
}

class _OnGoingTaskState extends State<OnGoingTask> {
  StreamController<DateTime> streamController = StreamController();

  @override
  void initState() {
    timer();
    super.initState();
  }

  Future<void> timer() async {
    while (true) {
      await Future.delayed(const Duration(seconds: 1))
          .then((value) => streamController.sink.add(DateTime.now()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(
        20,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "www.tinyFlutterTeam.com",
                  style: TextStyle(
                    color: Colors.blueGrey[700],
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Row(
                      children: <Widget>[
                        const Icon(Icons.today, color: Colors.blue),
                        const SizedBox(width: 4),
                        Text(
                          DateFormat('E, d MMM', 'vi')
                              .format(DateTime.now())
                              .toUpperCase()
                              .replaceAll('.', ''),
                          style: const TextStyle(color: Colors.blue),
                        ),
                      ],
                    ),
                    const Spacer(),
                    StreamBuilder<DateTime>(
                      stream: streamController.stream,
                      builder: (ctx, AsyncSnapshot<DateTime> value) {
                        return Row(
                          children: <Widget>[
                            const Icon(Icons.access_time, color: Colors.green),
                            const SizedBox(width: 4),
                            Text(
                              DateFormat('hh:mm:ss a')
                                  .format(value.data ?? DateTime.now()),
                              style: const TextStyle(color: Colors.green),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Icon(
            Icons.rocket_rounded,
            size: 60,
            color: Colors.orange,
          )
        ],
      ),
    );
  }
}
