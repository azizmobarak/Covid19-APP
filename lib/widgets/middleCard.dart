import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:sensibilisation/localization/localization_constants.dart';
import 'package:url_launcher/url_launcher.dart';
import 'raisedButton.dart';

class MiddleCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Color> firstCard = [Color(0xffCF5AEF), Color(0xffFE3258)];
    List<Color> secondCard = [Color(0xff56AB2F), Color(0xffA8E063)];
    List<Color> thirdard = [Color(0xff0CDAE4), Color(0xff1A41FD)];
    List<Color> fourthCard = [Color(0xffFD3755), Color(0xff0099F7)];
    List<Color> fifthCard = [Color(0xffFD3755), Color(0xffFE965C)];
    List<Color> sixthCard = [Color(0xff273EFD), Color(0xff9930FE)];
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

    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Wrap(
              spacing: 10.0, // gap between adjacent chips
              runSpacing: 20, // gap between lines
              direction: Axis.horizontal, // main axis (rows or columns)
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width * 0.44,
                  height: 138,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    elevation: 0.0,
                    padding: EdgeInsets.only(
                        top: 15, bottom: 15, right: 11, left: 8),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Image.asset('assets/images/tadamon.png', scale: 3),
                          Text(
                            getTranslated(context, "tadamon"),
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 19,
                                fontFamily: 'Questv'),
                          )
                        ],
                      ),
                    ),
                    color: Color(0xff264772),
                    onPressed: () {
                      Alert(
                        style: alertStyle,
                        context: context,
                        type: AlertType.info,
                        title: getTranslated(context, "tadamonAppBarTitle"),
                        desc: getTranslated(context, "tadamonCard2"),
                        buttons: [
                          DialogButton(
                            child: Text(
                              getTranslated(context, "sendMsgBtn"),
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                            color: Colors.blueGrey,
                            onPressed: () => launch('sms:1919'),
                            width: 120,
                          )
                        ],
                      ).show();
                    },
                  ),
                ),
                RaisedButtonHome(
                  getTranslated(context, "tadabirwika"),
                  'wikaya',
                  '/explain',
                ),
              ],
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Wrap(
              spacing: 10, // gap between adjacent chips
              runSpacing: 20, // gap between lines
              direction: Axis.horizontal, // main axis (rows or columns)
              children: <Widget>[
                RaisedButtonHome(getTranslated(context, "tanbih"), 'tanbih',
                    '/notification'),
                RaisedButtonHome(
                    getTranslated(context, "emergency"), 'tawari', '/sos'),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
