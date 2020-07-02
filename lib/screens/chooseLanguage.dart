import 'package:flutter/material.dart';
import 'package:sensibilisation/classes/language.dart';
import 'package:sensibilisation/localization/localization_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

class ChooseLanguage extends StatefulWidget {
  @override
  _ChooseLanguageState createState() => _ChooseLanguageState();
}

class _ChooseLanguageState extends State<ChooseLanguage> {
  void _changeLanguage(Language language) async {
    Locale _temp = await setLocale(language.languageCode);
    MyApp.setLocale(context, _temp);
  }

  bool isArabic = false;
  bool isEnglish = false;
  bool isFrench = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(height: 26),
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Row(
                    children: <Widget>[
                      Image.asset(
                        "assets/flags/translate.png",
                        scale: 4,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 26),
                Padding(
                  padding: const EdgeInsets.only(right: 20.0, left: 20),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          getTranslated(context, "chooseYouLanguage"),
                          style: TextStyle(fontSize: 33, height: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 20.0, left: 20),
                  child: Row(
                    children: <Widget>[
                      Text(
                        getTranslated(context, "youCanChangeItLater"),
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.4),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                Material(
                  color: isArabic
                      ? Color(0XFF1f324a)
                      : Theme.of(context).scaffoldBackgroundColor,
                  child: InkWell(
                    onTap: () {
                      isEnglish = false;
                      isFrench = false;
                      isArabic = true;
                      final language1 = Language(2, "🇲🇦", 'Arabic', 'ar');
                      _changeLanguage(language1);
                      print(language1.languageCode);
                    },
                    child: Container(
                      // color: cardColor,
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.all(18),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            getTranslated(context, "arabic"),
                            style: TextStyle(fontSize: 23),
                          ),
                          Image.asset(
                            "assets/flags/ma.png",
                            scale: 7,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Divider(
                  color: Colors.white.withOpacity(0.1),
                  thickness: 2,
                ),
                Material(
                  color: isFrench
                      ? Color(0XFF1f324a)
                      : Theme.of(context).scaffoldBackgroundColor,
                  child: InkWell(
                    onTap: () {
                      isEnglish = false;
                      isFrench = true;
                      isArabic = false;
                      final languageFr = Language(1, "🇲🇦", 'French', 'fr');
                      _changeLanguage(languageFr);
                      print(languageFr.languageCode);
                    },
                    child: Container(
                      // color: cardColor,
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.all(18),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            getTranslated(context, "french"),
                            style: TextStyle(fontSize: 23),
                          ),
                          Image.asset(
                            "assets/flags/fr.png",
                            scale: 7,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Divider(
                  thickness: 2,
                  color: Colors.white.withOpacity(0.1),
                ),
                Material(
                  color: isEnglish
                      ? Color(0XFF1f324a)
                      : Theme.of(context).scaffoldBackgroundColor,
                  child: InkWell(
                    onTap: () {
                      isEnglish = true;
                      isFrench = false;
                      isArabic = false;
                      final languageEn = Language(2, "🇲🇦", 'English', 'en');
                      _changeLanguage(languageEn);
                      print(languageEn.languageCode);
                    },
                    child: Container(
                      // color: cardColor,
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.all(18),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            getTranslated(context, "english"),
                            style: TextStyle(fontSize: 23),
                          ),
                          Image.asset(
                            "assets/flags/us.png",
                            scale: 7,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 55),
                Container(
                  margin: EdgeInsets.fromLTRB(18, 0, 18, 0),
                  padding: EdgeInsets.only(right: 25, left: 25),
                  decoration: BoxDecoration(
                      color: Color(0xffF9474E),
                      borderRadius: BorderRadius.all(Radius.circular(4))),
                  width: MediaQuery.of(context).size.width,
                  height: 55,
                  child: FlatButton(
                    onPressed: () {
                      Navigator.pushNamed(context, "/home");
                    },
                    child: Text(
                      getTranslated(
                        context,
                        "nextButton",
                      ).toUpperCase(),
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
