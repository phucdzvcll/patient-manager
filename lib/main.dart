import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import 'package:task_management/commons/presentation/res/color.dart';
import 'package:task_management/commons/presentation/routes/routes.dart';
import 'package:timezone/data/latest.dart' as tz2;
import 'package:path/path.dart';
import 'generated/codegen_loader.g.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz2.initializeTimeZones();
  await EasyLocalization.ensureInitialized();
  var databasesPath = await getDatabasesPath();
  var path = join(databasesPath, "local_database.db");
  var exists = await databaseExists(path);
  if (!exists) {
    try {
      await Directory(dirname(path)).create(recursive: true);
    } catch (_) {

    }
    ByteData data = await rootBundle.load(join("assets/db", "local_database.db"));
    List<int> bytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

    await File(path).writeAsBytes(bytes, flush: true);
  }

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('vi')],
      startLocale: const Locale('vi'),
      fallbackLocale: const Locale('vi'),
      assetLoader: const CodegenLoader(),
      path: 'assets/languages',
      saveLocale: true,
      useOnlyLangCode: false,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppColors.getTheme,
      initialRoute: Routes.home,
      onGenerateRoute: RouterGenerator.generateRoutes,
      locale: context.locale,
      supportedLocales: context.supportedLocales,
      localizationsDelegates: context.localizationDelegates,
    );
  }
}
