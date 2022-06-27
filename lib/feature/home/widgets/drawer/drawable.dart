import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:task_management/commons/presentation/res/color.dart';
import 'package:task_management/generated/locale_keys.g.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          _renderDrawerHeader(context),
          _renderSelectLanguage(context),
          // const Spacer(),
          ListTile(
            leading: const Icon(
              Icons.info,
              color: Colors.green,
            ),
            title: Text(LocaleKeys.txt_about_app.tr()),
            subtitle: const Text('Tiny Flutter Team'),
            isThreeLine: true,
            dense: true,
          ),
          ListTile(
            leading: const Icon(Icons.logout_outlined),
            title: Text(
              LocaleKeys.txt_log_out.tr(),
            ),
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
}
