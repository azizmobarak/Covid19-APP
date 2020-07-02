import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
import 'package:sensibilisation/classes/language.dart';
import 'package:sensibilisation/localization/localization_constants.dart';
import 'package:sensibilisation/theme.dart';
import 'package:provider/provider.dart';

import '../main.dart';

class AppSettings extends StatefulWidget {
  @override
  _AppSettingsState createState() => _AppSettingsState();
}

class _AppSettingsState extends State<AppSettings> {
  void _changeLanguage(Language language) async {
    Locale _temp = await setLocale(language.languageCode);
    MyApp.setLocale(context, _temp);
  }

  bool isArabic = false;
  bool isEnglish = false;
  bool isFrench = false;
  bool isTrue = true;

  String whatLanguage() {
    if (isArabic) {
      return getTranslated(context, "arabic");
    } else if (isEnglish) {
      return getTranslated(context, "english");
    } else if (isFrench) {
      return getTranslated(context, "french");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(getTranslated(context, "appSettings")),
      ),
      body: Column(
        children: <Widget>[
          Consumer<ThemeNotifier>(
            builder: (context, ThemeNotifier notifier, child) {
              return Container(
                padding: EdgeInsets.all(22),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          getTranslated(context, "darkMode"),
                          style: TextStyle(fontSize: 20),
                        ),
                        CupertinoSwitch(
                          value: notifier.isDark,
                          onChanged: (value) {
                            notifier.toggleTheme();
                          },
                          activeColor: Colors.green,
                        ),
                      ],
                    ),
                    Divider(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          getTranslated(context, "chooseYouLanguage"),
                          style: TextStyle(fontSize: 20),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        CustomRadioButton(
                          buttonColor:
                              Theme.of(context).scaffoldBackgroundColor,
                          buttonLables: [
                            getTranslated(context, "arabic"),
                            getTranslated(context, "french"),
                            getTranslated(context, "english"),
                          ],
                          buttonValues: [
                            getTranslated(context, "arabic"),
                            getTranslated(context, "french"),
                            getTranslated(context, "english"),
                          ],
                          radioButtonValue: (value) {
                            if (value == "العربية" ||
                                value == "Arabe" ||
                                value == "Arabic") {
                              isEnglish = false;
                              isFrench = false;
                              isArabic = true;
                              final language1 =
                                  Language(2, "🇲🇦", 'Arabic', 'ar');
                              _changeLanguage(language1);
                              print(language1.languageCode);
                            }
                            if (value == "الفرنسية" ||
                                value == "Français" ||
                                value == "French") {
                              isEnglish = false;
                              isFrench = true;
                              isArabic = false;
                              final languageFr =
                                  Language(1, "🇲🇦", 'French', 'fr');
                              _changeLanguage(languageFr);
                              print(languageFr.languageCode);
                            }
                            if (value == "الإنجليزية" ||
                                value == "Anglais" ||
                                value == "English") {
                              isEnglish = true;
                              isFrench = false;
                              isArabic = false;
                              final languageEn =
                                  Language(2, "🇲🇦", 'English', 'en');
                              _changeLanguage(languageEn);
                              print(languageEn.languageCode);
                            }
                          },
                          horizontal: false,
                          width: MediaQuery.of(context).size.width / 3,
                          selectedColor: Colors.transparent,
                        ),
                      ],
                    )
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
