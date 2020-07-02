import 'package:flutter/material.dart';
import 'package:sensibilisation/localization/localization_constants.dart';
import 'package:url_launcher/url_launcher.dart';

class Sos extends StatefulWidget {
  @override
  _SosState createState() => _SosState();
}

class _SosState extends State<Sos> {
  List<Color> firstCard = [Color(0xffCF5AEF), Color(0xffFE3258)];
  List<Color> secondCard = [Color(0xff56AB2F), Color(0xffA8E063)];
  List<Color> thirdard = [Color(0xff0CDAE4), Color(0xff1A41FD)];
  List<Color> fourthCard = [Color(0xffFD3755), Color(0xff0099F7)];
  List<Color> fifthCard = [Color(0xffFD3755), Color(0xffFE965C)];
  List<Color> sixthCard = [Color(0xff273EFD), Color(0xff9930FE)];
  List<String> textNumber = ["141", "0801004747", "300"];
  @override
  Widget build(BuildContext context) {
    List<String> textTitle = [
      getTranslated(context, "allosamu"),
      getTranslated(context, "alloyakada"),
      getTranslated(context, "wizarat"),
    ];
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
        iconTheme: IconThemeData(color: Theme.of(context).accentColor),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 1,
        title: Text(
          getTranslated(context, "emergency"),
          style: TextStyle(fontSize: 18, color: Theme.of(context).accentColor),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.all(15),
        color: Theme.of(context).scaffoldBackgroundColor,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 150,
              ),
              Center(child: Image.asset('assets/images/soslogo.png')),
              SizedBox(
                height: 30,
              ),
              SosCard(textTitle[0], textNumber[0], Colors.green, firstCard),
              SosCard(textTitle[1], textNumber[1], Colors.yellow, secondCard),
              SosCard(textTitle[2], textNumber[2], Colors.cyan, thirdard),
            ],
          ),
        ),
      ),
    );
  }
}

class SosCard extends StatelessWidget {
  final Color containerColor;
  List<Color> colors = [];
  final String textTitle;
  final String textNumber;
  SosCard(this.textTitle, this.textNumber, this.containerColor, this.colors);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: containerColor,
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.topLeft,
              colors: colors,
              //     //  stops: stops,
            )),
        child: ListTile(
          contentPadding:
              EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 15),
          title: Text(
            textTitle,
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
            ),
          ),
          subtitle: Text(
            textNumber,
            style: TextStyle(
              fontSize: 18,
              fontFamily: 'RalewayMedium',
              color: Colors.white,
            ),
          ),
          trailing: Container(
            width: 55,
            height: 55,
            child: FlatButton(
              onPressed: () {
                launch("tel:$textNumber");
              },
              child: Icon(
                Icons.phone,
                size: 32,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
