import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:task_management/commons/presentation/res/color.dart';
import 'package:task_management/commons/presentation/routes/routes.dart';
import 'package:timezone/data/latest.dart' as tz2;

import 'generated/codegen_loader.g.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz2.initializeTimeZones();
  await EasyLocalization.ensureInitialized();
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
