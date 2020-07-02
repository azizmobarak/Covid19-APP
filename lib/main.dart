import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:sensibilisation/classes/language.dart';
import 'package:sensibilisation/screens/animation.dart';
import 'package:sensibilisation/screens/chooseLanguage.dart';
import 'package:sensibilisation/screens/notification-guid.dart';
import 'package:sensibilisation/screens/settings.dart';
import 'package:sensibilisation/widgets/text.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:url_launcher/url_launcher.dart';
import 'theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/subjects.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui';
import './localization/localization_constants.dart';
import './localization/demo_localization.dart';
import './screens/sos.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import './screens/home_page.dart';
import './screens/explain.dart';

class ReceivedNotification {
  final int id;
  final String title;
  final String body;
  final String payload;

  ReceivedNotification({
    @required this.id,
    @required this.title,
    @required this.body,
    @required this.payload,
  });
}

String $payload = "";

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =
    BehaviorSubject<ReceivedNotification>();

final BehaviorSubject<String> selectNotificationSubject =
    BehaviorSubject<String>();

NotificationAppLaunchDetails notificationAppLaunchDetails;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

  var initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  var initializationSettingsIOS = IOSInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
      onDidReceiveLocalNotification:
          (int id, String title, String body, String payload) async {
        didReceiveLocalNotificationSubject.add(ReceivedNotification(
            id: id, title: title, body: body, payload: payload));
      });
  var initializationSettings = InitializationSettings(
      initializationSettingsAndroid, initializationSettingsIOS);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
    selectNotificationSubject.add(payload);
  });
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  static void setLocale(BuildContext context, Locale locale) {
    _MyAppState state = context.findAncestorStateOfType<_MyAppState>();
    state.setLocale(locale);
  }

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale;
  void setLocale(Locale locale) {
    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        _locale = locale;
      });
    });
  }

  @override
  void didChangeDependencies() {
    getLocale().then((locale) => {
          setState(() {
            this._locale = locale;
          })
        });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return ChangeNotifierProvider(
        create: (_) => ThemeNotifier(),
        child: _locale == null
            ? CircularProgressIndicator()
            : MaterialAppWdg(_locale));
  }
}

class MaterialAppWdg extends StatefulWidget {
  Locale locale2;

  MaterialAppWdg(this.locale2);

  @override
  _MaterialAppWdgState createState() => _MaterialAppWdgState();
}

class _MaterialAppWdgState extends State<MaterialAppWdg> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, ThemeNotifier notifier, child) {
        return MaterialApp(
          supportedLocales: [
            Locale('ar', 'MA'), // Arabic
            Locale('fr', 'FR'),
            Locale('en', 'EN') // English
          ],
          locale: widget.locale2,
          localizationsDelegates: [
            DemoLocalizations.delegate,
            // ... app-specific localization delegate[s] here
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          debugShowCheckedModeBanner: false,
          theme: notifier.isDark ? darkMode : lightMode,
          //    initialRoute: '/home',
          localeResolutionCallback: (deviceLocale, supportedLocales) {
            for (var locale in supportedLocales) {
              if (locale.languageCode == deviceLocale.languageCode &&
                  locale.countryCode == deviceLocale.countryCode) {
                return deviceLocale;
              }
            }
            return supportedLocales.first;
          },
          home: Splash(),
          routes: {
            'secondscreen': (context) => SecondScreen($payload),
            '/animation': (context) => MyAnimation(),
            '/notification': (context) => Notificationsettings(),
            '/settings': (context) => AppSettings(),
            '/sos': (context) => Sos(),
            '/home': (context) => HomeScreen(),
            '/explain': (context) => Explain(),
            '/chooselanguage': (context) => ChooseLanguage()
          },
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Covid 19'),
      ),
      body: Center(child: Text("main")),
    );
  }
}

class Notificationsettings extends StatefulWidget {
  @override
  _NotificationsettingsState createState() => _NotificationsettingsState();
}

class _NotificationsettingsState extends State<Notificationsettings> {
  // void _changeLanguage(Language language) async {
  //   Locale _temp = await setLocale(language.languageCode);
  //   MyApp.setLocale(context, _temp);
  // }

  final MethodChannel platform =
      MethodChannel('crossingthestreams.io/resourceResolver');

  @override
  void initState() {
    super.initState();
    _requestIOSPermissions();
    _configureDidReceiveLocalNotificationSubjectclean();
    _configureSelectNotificationSubjectclean();
  }

  void _requestIOSPermissions() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  void dispose() {
    didReceiveLocalNotificationSubject.close();
    selectNotificationSubject.close();
    super.dispose();
  }

  void _configureDidReceiveLocalNotificationSubjectclean() {
    didReceiveLocalNotificationSubject.stream
        .listen((ReceivedNotification receivedNotification) async {
      await showDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: receivedNotification.title != "this is some title"
              ? Text(receivedNotification.title)
              : null,
          content: receivedNotification.body != null
              ? Text(receivedNotification.body)
              : null,
          actions: [
            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text('Ok'),
              onPressed: () async {
                Navigator.of(context, rootNavigator: true).pop();
                await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            SecondScreen($payload)));
              },
            )
          ],
        ),
      );
    });
  }

  void _configureSelectNotificationSubjectclean() {
    selectNotificationSubject.stream.listen((String payload) async {
      await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => SecondScreen(payload)));
    });
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
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "توعية",
            style: TextStyle(fontSize: 28),
          ),
          actions: <Widget>[],
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Center(
          child: SingleChildScrollView(
            child: Stack(children: <Widget>[
              Container(
                  padding: EdgeInsets.all(23),
                  child: Column(children: <Widget>[
                    Row(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            getTranslated(context, 'topText'),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 25,
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.notifications_active,
                            color: Theme.of(context).accentColor, size: 44),
                      ],
                    ),
                    Divider(color: Colors.white, height: 60),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          SizedBox(
                            width: 280,
                            child: Texts().text(
                                //   'التذكير  بالحفاظ على النظافة',
                                getTranslated(context, 'firstNotification'),
                                20,
                                Theme.of(context).accentColor),
                          ),
                          buildedswitch("clean", "clean", 1),
                        ]),
                    Divider(),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          SizedBox(
                            width: 280,
                            child: Texts().text(
                                //     'التذكير بالتدابير الوقائية عند الخروج من البيت',
                                getTranslated(context, 'secondNotification'),
                                20,
                                Theme.of(context).accentColor),
                          ),
                          buildedswitch('getout', 'getout', 2),
                        ]),
                    Divider(),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          SizedBox(
                            width: 280,
                            child: Texts().text(
                                getTranslated(context, 'thirdNotification'),
                                20,
                                Theme.of(context).accentColor),
                          ),
                          buildedswitch("eat", "eat", 3),
                        ]),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          SizedBox(
                            width: 280,
                            child: Texts().text(
                                getTranslated(context, 'fifthNotification'),
                                20,
                                Theme.of(context).accentColor),
                          ),
                          buildedswitch("sport", "sport", 4),
                        ]),
                    Divider(color: Colors.white, height: 30),
                    Padding(
                      padding: const EdgeInsets.all(0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                              width: MediaQuery.of(context).size.width / 2.5,
                              child: RaisedButton(
                                padding: EdgeInsets.all(15),
                                onPressed: () => stopallnotifications(),
                                child: Text(
                                  getTranslated(
                                      context, "notificationStopAllButton"),
                                  style: TextStyle(fontSize: 15),
                                ),
                              ),
                            ),
                            Container(
                              height: 58,
                              width: MediaQuery.of(context).size.width / 2.5,
                              child: RaisedButton(
                                padding: EdgeInsets.all(15),
                                color: Colors.green,
                                child: Text(
                                  getTranslated(context, "notificationGuide"),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 15),
                                ),
                                onPressed: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (
                                      BuildContext context,
                                    ) =>
                                            Guide())),
                              ),
                            ),
                          ]),
                    ),
                  ])),
            ]),
          ),
        ));
  }

  FutureBuilder buildedswitch(key, channel, id) {
    return FutureBuilder(
        future: getShared(key),
        initialData: false,
        builder: (context, snapshot) {
          return Switch(
            value: snapshot.data,
            onChanged: (value) {
              putShared(key, value);
              setState(() {
                if (id > 0) {
                  var message, title;
                  if (value == true) {
                    if (channel == "clean") {
                      message =
                          "لاتنسى الحفاظ على النظافة والالتزام بغسل اليدين كل 15 دقيقة";
                      title = "من الضروري غسل اليدين";
                      cleanNotification(1, channel, channel, title, message);
                    }
                    if (channel == "eat") {
                      message = "لاتاكل قبل غسل يديك و التاكد من سلامة الطعام";
                      title = "انتبه فالفيروسات قد تتسلل مع الطعام";
                      dailyNotification1(
                          3, channel, channel, title, message, 12, 24);
                      dailyNotification1(
                          33, channel, channel, title, message, 20, 40);
                    }
                    if (channel == "getout") {
                      message =
                          "قبل الخروج من البيت تاكد من وضعك الكمامة واحترام مسافة الامان وعدم الاختلاط بالاخرين";
                      title =
                          "اتخد جميع التدابير اللازمة قبل خروجك من البيت وحافظ على سلامة مجتمعك";
                      getoutNotification(2, channel, channel, title, message);
                    }
                    if (channel == "sport") {
                      message =
                          "حافظ على ممارستك لنشاطك الرياضي من البيت ولاتعرض نفسك والاخرين للخطر";
                      title =
                          "الرياضة اخلاق طبقها اليوم وتمرن في البيت باي وسيلة واحمي غيرك";
                      dailyNotification2(
                          4, channel, channel, title, message, 10, 33);
                      dailyNotification2(
                          44, channel, channel, title, message, 18, 50);
                    }
                  }
                }
              });
            },
            activeTrackColor: Colors.lightGreenAccent,
            activeColor: Colors.green,
          );
        });
  }

  void putShared(String key, bool val) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if ((key == "clean")) {
      if (val == true) {
        prefs.setBool('getout', false);
        flutterLocalNotificationsPlugin.cancel(2);
      } else {
        flutterLocalNotificationsPlugin.cancel(1);
      }
    }
    if ((key == "eat" && val == false)) {
      flutterLocalNotificationsPlugin.cancel(3);
      flutterLocalNotificationsPlugin.cancel(33);
    }
    if ((key == "getout")) {
      if (val == true) {
        prefs.setBool('clean', false);
        flutterLocalNotificationsPlugin.cancel(1);
      } else {
        flutterLocalNotificationsPlugin.cancel(2);
      }
    }
    if ((key == "sport" && val == false)) {
      flutterLocalNotificationsPlugin.cancel(4);
      flutterLocalNotificationsPlugin.cancel(44);
    }
    prefs.setBool(key, val);
  }

  Future getShared(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool val = prefs.getBool(key) == null ? false : (prefs.getBool(key));
    return val;
  }

  stopallnotifications() {
    setState(() {
      _cancelallNotifications(1, 2, 3);
      _cancelallNotifications(4, 33, 44);
      putShared('clean', false);
      putShared('getout', false);
      putShared('eat', false);
      putShared('sport', false);
    });
  }

  Future<void> _cancelallNotifications(id1, id2, id3) async {
    await flutterLocalNotificationsPlugin.cancel(id1);
    await flutterLocalNotificationsPlugin.cancel(id2);
    await flutterLocalNotificationsPlugin.cancel(id3);
  }

  Future<void> cleanNotification(id, channel, idchannel, title, message) async {
    var vibrationPattern = Int64List(4);
    vibrationPattern[0] = 0;
    vibrationPattern[1] = 1000;
    vibrationPattern[2] = 5000;
    vibrationPattern[3] = 2000;

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        "clean", "channelclean", "this channel is for clean notifications",
        icon: '@mipmap/ic_launcher',
        importance: Importance.High,
        priority: Priority.High,
        ongoing: true,
        autoCancel: false,
        sound: RawResourceAndroidNotificationSound(channel),
        largeIcon: DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
        vibrationPattern: vibrationPattern,
        enableLights: true,
        color: const Color.fromARGB(255, 255, 0, 0),
        ledColor: const Color.fromARGB(255, 255, 0, 0),
        ledOnMs: 1000,
        ledOffMs: 500,
        timeoutAfter: 30000);
    var iOSPlatformChannelSpecifics =
        IOSNotificationDetails(sound: channel + ".wav");
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.periodicallyShow(
        id, title, message, RepeatInterval.Hourly, platformChannelSpecifics,
        payload: channel);

    setState(() {
      $payload = channel + "15";
    });
  }

  Future<void> getoutNotification(
      id, channel, idchannel, title, message) async {
    print('getout start');

    var vibrationPattern = Int64List(4);
    vibrationPattern[0] = 0;
    vibrationPattern[1] = 1000;
    vibrationPattern[2] = 5000;
    vibrationPattern[3] = 2000;

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        "getout", "channelgetout", "this is a getout notification",
        icon: '@mipmap/ic_launcher',
        importance: Importance.High,
        priority: Priority.High,
        ongoing: true,
        autoCancel: false,
        sound: RawResourceAndroidNotificationSound(channel),
        largeIcon: DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
        vibrationPattern: vibrationPattern,
        enableLights: true,
        color: const Color.fromARGB(255, 255, 0, 0),
        ledColor: const Color.fromARGB(255, 255, 0, 0),
        ledOnMs: 1000,
        ledOffMs: 500,
        timeoutAfter: 30000);
    var iOSPlatformChannelSpecifics =
        IOSNotificationDetails(sound: channel + ".wav");
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.periodicallyShow(
        id, title, message, RepeatInterval.Hourly, platformChannelSpecifics,
        payload: channel);

    setState(() {
      $payload = channel;
    });
  }

  Future<void> dailyNotification1(
      id, channel, idchannel, title, message, hour, minute) async {
    print(channel + 'start');
    var vibrationPattern = Int64List(4);
    vibrationPattern[0] = 0;
    vibrationPattern[1] = 1000;
    vibrationPattern[2] = 5000;
    vibrationPattern[3] = 2000;

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'idis' + id.toString(),
        'channel' + id.toString(),
        'this channel for daily reminder',
        icon: '@mipmap/ic_launcher',
        importance: Importance.High,
        priority: Priority.High,
        ongoing: true,
        autoCancel: false,
        sound: RawResourceAndroidNotificationSound(channel),
        largeIcon: DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
        vibrationPattern: vibrationPattern,
        enableLights: true,
        color: const Color.fromARGB(255, 255, 0, 0),
        ledColor: const Color.fromARGB(255, 255, 0, 0),
        ledOnMs: 1000,
        ledOffMs: 500,
        timeoutAfter: 20000);
    var iOSPlatformChannelSpecifics =
        IOSNotificationDetails(sound: channel + ".wav");
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.showDailyAtTime(
        id, title, message, Time(hour, minute, 0), platformChannelSpecifics,
        payload: channel);

    setState(() {
      $payload = channel;
    });
  }

  Future<void> dailyNotification2(
      id, channel, idchannel, title, message, hour, minute) async {
    print(channel + 'start');
    var vibrationPattern = Int64List(4);
    vibrationPattern[0] = 0;
    vibrationPattern[1] = 1000;
    vibrationPattern[2] = 5000;
    vibrationPattern[3] = 2000;

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'idis' + id.toString(),
        'channel' + id.toString(),
        'this channel for daily reminder',
        icon: '@mipmap/ic_launcher',
        importance: Importance.High,
        priority: Priority.High,
        ongoing: true,
        autoCancel: false,
        sound: RawResourceAndroidNotificationSound(channel),
        largeIcon: DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
        vibrationPattern: vibrationPattern,
        enableLights: true,
        color: const Color.fromARGB(255, 255, 0, 0),
        ledColor: const Color.fromARGB(255, 255, 0, 0),
        ledOnMs: 1000,
        ledOffMs: 500,
        timeoutAfter: 20000);
    var iOSPlatformChannelSpecifics =
        IOSNotificationDetails(sound: channel + ".wav");
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.showDailyAtTime(
        id, title, message, Time(hour, minute, 0), platformChannelSpecifics,
        payload: channel);

    setState(() {
      $payload = channel;
    });
  }
}

class SecondScreen extends StatefulWidget {
  SecondScreen(this.payload);

  final String payload;

  @override
  State<StatefulWidget> createState() => SecondScreenState();
}

class SecondScreenState extends State<SecondScreen> {
  String _payload;
  int count = 0;
  @override
  void initState() {
    super.initState();
    _payload = widget.payload;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0XFF243953),
      body: Container(),
    );
  }

  void navigation(name) {
    if (name == "back") {
      setState(() {
        --count;
        if (count < 0) {
          count = 3;
        }
      });
    }
    if (name == "next") {
      setState(() {
        ++count;
        if (count > 3) {
          count = 0;
        }
      });
    }

    setState(() {
      if (count == 0) {
        _payload = "clean15";
      }
      if (count == 1) {
        _payload = "eat";
      }
      if (count == 2) {
        _payload = "getout";
      }
      if (count == 3) {
        _payload = "sport";
      }
    });
  }
}
