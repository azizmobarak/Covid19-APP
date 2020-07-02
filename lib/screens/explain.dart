import 'package:flutter/material.dart';
import 'package:sensibilisation/localization/localization_constants.dart';

class Explain extends StatefulWidget {
  @override
  _ExplainState createState() => _ExplainState();
}

class _ExplainState extends State<Explain> {
  Future<bool> circ() async {
    while (true) {
      // await Future.delayed(Duration(seconds: 1));
      return false;
    }
  }

  List<String> getImages() {
    List<String> allImages = [
      getTranslated(context, "img1"),
      getTranslated(context, "img2"),
      getTranslated(context, "img3")
    ];
    return allImages;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          centerTitle: true,
          iconTheme: IconThemeData(color: Theme.of(context).accentColor),
          elevation: 1,
          leading: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Icon(Icons.arrow_back_ios)),
          title: Center(
              child: Text(
            getTranslated(context, "HomeScreentopCardText"),
            style:
                TextStyle(fontSize: 18, color: Theme.of(context).accentColor),
          )),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.all(11.0),
              child: Icon(Icons.refresh),
            )
          ],
        ),
        body: Container(
          padding: EdgeInsets.all(18),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                QuestionWdg('Qs1', "Ans1"),
                QuestionWdg('Qs2', "Ans2"),
                QuestionWdg('Qs3', "Ans3"),
                Image.asset(getImages()[0]),
                Image.asset(getImages()[1]),
                Image.asset(getImages()[2]),
                QuestionWdg('Qs4', "Ans4"),
                QuestionWdg('Qs5', "Ans5"),
                QuestionWdg('Qs6', "Ans6"),
              ],
            ),
          ),
        ));
  }
}

class QuestionWdg extends StatelessWidget {
  final String qs;
  final String ans;
  final double sizedbox;
  QuestionWdg(this.ans, this.qs, {this.sizedbox = 16});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          getTranslated(context, ans),
          style: TextStyle(fontSize: 22),
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: 16,
        ),
        Text(
          getTranslated(context, qs),
        ),
        SizedBox(
          height: 29,
        )
      ],
    );
  }
}
