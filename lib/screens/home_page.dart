import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:sensibilisation/classes/language.dart';
import 'package:sensibilisation/localization/localization_constants.dart';
import 'package:sensibilisation/screens/chooseLanguage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';
import '../widgets/middleCard.dart';

import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:lottie/lottie.dart';
import '../theme.dart';
import 'dart:io' show Platform;

class Splash extends StatefulWidget {
  @override
  SplashState createState() => new SplashState();
}

class SplashState extends State<Splash> {
  Future checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _seen = (prefs.getBool('seen') ?? false);

    if (_seen) {
      Navigator.of(context).pushReplacement(
          new MaterialPageRoute(builder: (context) => new HomeScreen()));
    } else {
      await prefs.setBool('seen', true);
      Navigator.of(context).pushReplacement(
          new MaterialPageRoute(builder: (context) => new ChooseLanguage()));
    }
  }

  @override
  void initState() {
    super.initState();
    new Timer(new Duration(seconds: 1), () {
      checkFirstSeen();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SpinKitWave(
          itemBuilder: (BuildContext context, int index) {
            return DecoratedBox(
              decoration: BoxDecoration(
                color: index.isEven ? Colors.red : Colors.green,
              ),
            );
          },
        ),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  void _changeLanguage(Language language) async {
    Locale _temp = await setLocale(language.languageCode);
    MyApp.setLocale(context, _temp);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  String whatOSis() {
    if (Platform.isAndroid) {
      return "https://play.google.com/store/apps/details?id=com.sensibilisationapp.com&hl=en";
    } else if (Platform.isIOS) {
      return "'https://apps.apple.com/us/app/'";
    }
  }

  @override
  Widget build(BuildContext context) {
    var alertStyle = AlertStyle(
        backgroundColor: Color(0xFF243953),
        animationType: AnimationType.fromTop,
        isCloseButton: true,
        isOverlayTapDismiss: true,
        //   descStyle: TextStyle(fontWeight: FontWeight.bold),
        animationDuration: Duration(milliseconds: 400),
        alertBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0.0),
          side: BorderSide(
            color: Colors.grey,
          ),
        ),
        titleStyle: TextStyle(
          color: Colors.white,
        ),
        descStyle: TextStyle(color: Colors.white54));

    TextStyle textStyle = TextStyle(
        color: Theme.of(context).accentColor,
        // fontWeight: FontWeight.bold,
        fontSize: 17);
    SystemChrome.setEnabledSystemUIOverlays([]);

    return Consumer<ThemeNotifier>(
        builder: (context, ThemeNotifier notifier, child) {
      return WillPopScope(
        onWillPop: () => Future.value(false),
        child: Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          drawer: Column(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width / 1.5,
                height: MediaQuery.of(context).size.height,
                child: Drawer(
                  elevation: 0,
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(bottom: 18, top: 18),
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.3,
                          color: Colors.deepOrange,
                          child: CircleAvatar(
                            backgroundColor: Colors.transparent,
                            child: Image.asset('assets/images/0.png'),
                          ),
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height,
                          child: Material(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            child: Column(
                              children: <Widget>[
                                SizedBox(height: 35),
                                // Emergency
                                ListTile(
                                  title: Text(
                                    getTranslated(context, 'rateTheApp'),
                                    style: textStyle,
                                  ),
                                  trailing: Icon(
                                    Icons.star,
                                    color: Theme.of(context).accentColor,
                                  ),
                                  onTap: () => launch(whatOSis()),
                                ),
                                SizedBox(height: 5),

                                ListTile(
                                  title: Text(
                                    //      'موقعنا الرسمي',
                                    getTranslated(context, 'ourWebsite'),
                                    style: textStyle,
                                  ),
                                  onTap: () =>
                                      launch('https://sensibilisation19.com/'),
                                  trailing: Icon(
                                    Icons.apps,
                                    color: Theme.of(context).accentColor,
                                  ),
                                ),
                                SizedBox(height: 5),
                                ListTile(
                                  title: Text(
                                    //       'الإبلاغ عن مشكلة',
                                    getTranslated(context, 'bug'),
                                    style: textStyle,
                                  ),
                                  onTap: () =>
                                      launch('mailto:info@simpower.ma'),
                                  trailing: Icon(
                                    Icons.bug_report,
                                    color: Theme.of(context).accentColor,
                                  ),
                                ),
                                SizedBox(height: 5),
                                ListTile(
                                  title: Text(
                                    //     'تواصل معنا',
                                    getTranslated(context, 'callUs'),
                                    style: textStyle,
                                  ),
                                  onTap: () =>
                                      launch('mailto:info@simpower.ma'),
                                  trailing: Icon(
                                    Icons.phone,
                                    color: Theme.of(context).accentColor,
                                  ),
                                ),
                                ListTile(
                                  title: Text(
                                    //      'إعدادات التطبيق',
                                    getTranslated(context, 'settings'),
                                    style: textStyle,
                                  ),
                                  trailing: Icon(
                                    Icons.settings,
                                    color: Theme.of(context).accentColor,
                                  ),
                                  onTap: () =>
                                      Navigator.pushNamed(context, '/settings'),
                                ),
                                SizedBox(height: 5),
                                ListTile(
                                  title: Center(
                                    child: Text('Simpower@2020',
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.white24,
                                        )),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          appBar: AppBar(
            iconTheme: IconThemeData(color: Theme.of(context).accentColor),
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            centerTitle: true,
            elevation: 1,
            //  backgroundColor: myTheme.getColor(),
            title: Text(
              'توعية',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: notifier.isDark ? Colors.white : Color(0xFF243953),
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Questv'),
            ),
            actions: <Widget>[
              Padding(
                padding: EdgeInsets.all(8),
                child: DropdownButton(
                    underline: SizedBox(),
                    onChanged: (Language language) {
                      _changeLanguage(language);
                    },
                    icon: Icon(
                      Icons.language,
                      color: Colors.white,
                    ),
                    items: Language.languageList()
                        .map<DropdownMenuItem<Language>>(
                            (lang) => DropdownMenuItem(
                                  value: lang,
                                  child: Row(
                                    children: <Widget>[
                                      Text(lang.flag),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Text(lang.name)
                                    ],
                                  ),
                                ))
                        .toList()),
              )
            ],
          ),
          body: SingleChildScrollView(
            child: Container(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 50,
                  ),
                  Container(
                    child: Column(
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(28)),
                              color: Colors.deepOrange),
                          padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                          margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
                          child: Row(
                            children: <Widget>[
                              Flexible(
                                flex: 5,
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 250,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        getTranslated(
                                            context, "HomeScreentopCardText"),
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontFamily: 'Questv',
                                            color: Colors.white),
                                      ),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      FlatButton(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        onPressed: () => Navigator.pushNamed(
                                            context, '/explain'),
                                        child: Text(
                                          getTranslated(
                                              context, "HomeScreentopCardBtn"),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontFamily: 'Questv',
                                              fontSize: 18),
                                        ),
                                        color: Colors.white,
                                        textColor: Colors.deepOrange,
                                        padding:
                                            EdgeInsets.only(top: 6, bottom: 6),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Flexible(
                                flex: 5,
                                child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 250,
                                    child: Stack(
                                      overflow: Overflow.visible,
                                      children: <Widget>[
                                        Positioned(
                                            top: -109,
                                            left: 5,
                                            child: Lottie.asset(
                                              'assets/doctor3.json',
                                              width: 150,
                                              height: 439,
                                            ))
                                      ],
                                    )),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(
                          height: 40,
                        ),

                        // MiddleCard
                        MiddleCard(),

                        SizedBox(
                          height: 25,
                        ),

                        // BottomCard
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
