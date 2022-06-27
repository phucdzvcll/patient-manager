import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:task_management/commons/presentation/res/color.dart';
import 'package:task_management/generated/locale_keys.g.dart';
import 'package:url_launcher/url_launcher.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          _renderDrawerHeader(context),
          _renderSelectLanguage(context),
          ListTile(
            leading: const Icon(
              Icons.info,
              color: Colors.green,
            ),
            title: Text(LocaleKeys.txt_about_app.tr()),
            subtitle: const Text('Tiny Flutter Team'),
            isThreeLine: true,
            dense: true,
            onTap: () async {
              var uri = Uri.parse("https://tinyflutterteam.com/");
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri);
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout_outlined),
            title: Text(
              LocaleKeys.txt_log_out.tr(),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: Text(
              LocaleKeys.txt_exit.tr(),
            ),
            onTap: () async {
              await _warningBeforeExitApp(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _renderSelectLanguage(BuildContext context) {
    return ListTile(
      leading: const Icon(
        Icons.language,
        color: Colors.blue,
      ),
      title: Text(LocaleKeys.txt_language.tr()),
      subtitle: Text(
        getCurrentLanguage(context),
        style: const TextStyle(color: Colors.blue),
      ),
      isThreeLine: true,
      dense: true,
      onTap: () {
        showModalBottomSheet(
            context: context,
            isScrollControlled: false,
            builder: (builder) {
              return SizedBox(
                height: 220,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _renderLanguageItem(context, () async {
                      context.setLocale(const Locale('vi'));
                      await Future.delayed(const Duration(milliseconds: 200));
                      Navigator.pop(context);
                    }, LocaleKeys.vietnam.tr()),
                    _renderLanguageItem(context, () async {
                      context.setLocale(const Locale('en'));
                      await Future.delayed(const Duration(milliseconds: 200));
                      Navigator.pop(context);
                    }, LocaleKeys.english.tr()),
                  ],
                ),
              );
            }).then((value) => Navigator.pop(context));
      },
    );
  }

  Widget _renderLanguageItem(
      BuildContext context, Function() onTap, String title) {
    return InkWell(
      // behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
          child: Text(
            title,
            style:
                Theme.of(context).textTheme.headline6?.copyWith(fontSize: 20),
          ),
        ),
      ),
      onTap: onTap,
    );
  }

  String getCurrentLanguage(BuildContext context) {
    var s = context.locale;
    if (s.languageCode == 'vi') {
      return LocaleKeys.vietnam.tr();
    } else {
      return LocaleKeys.english.tr();
    }
  }

  DrawerHeader _renderDrawerHeader(BuildContext context) {
    return DrawerHeader(
      decoration: BoxDecoration(color: AppColors.primaryColor),
      child: Row(
        children: [
          const ClipRect(
            child: CircleAvatar(
              radius: 45,
              backgroundColor: Colors.amber,
              child: Icon(
                Icons.person,
                color: Colors.white,
                size: 32,
              ),
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          Expanded(
            child: Text(
              'Tiny Flutter Team',
              style: Theme.of(context)
                  .textTheme
                  .displaySmall!
                  .copyWith(color: Colors.white),
            ),
          )
        ],
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
}
