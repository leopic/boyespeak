import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(BoyeSpeakApp());

class BoyeSpeakApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'b o y e  s p e a k',
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
      ),
      home: BoyeSpeak(title: 'b o y e  s p e a k ', context: context),
    );
  }
}

class BoyeSpeak extends StatefulWidget {
  BoyeSpeak({Key key, this.title, this.context}) : super(key: key);

  final String title;
  BuildContext context;

  @override
  _BoyeSpeakState createState() => _BoyeSpeakState();
}

class _BoyeSpeakState extends State<BoyeSpeak> {
  String _pasteBoard = '';
  final textEditingController = TextEditingController();

  void _translate(BuildContext context) {
    setState(() {
      var out = '';

      textEditingController.text.runes.forEach((int rune) {
        out += '${new String.fromCharCode(rune)} ';
      });

      _pasteBoard = out.trim();

      Clipboard.setData(new ClipboardData(text: _pasteBoard));

      if (_pasteBoard.length > 0) {
        final snackBar = SnackBar(
          content: Text('Text copied to clipboard'),
          duration: Duration(seconds: 2));

        Scaffold.of(context).showSnackBar(snackBar);
      }
    });
  }

  void _clear(BuildContext context) {
    setState(() {
      if (_pasteBoard.length == 0) {
        return;
      }

      _pasteBoard = '';
      textEditingController.clear();
      Clipboard.setData(new ClipboardData(text: _pasteBoard));

      final snackBar = SnackBar(
        content: Text('Clipboard has been cleared'),
        duration: Duration(seconds: 2));
      Scaffold.of(context).showSnackBar(snackBar);
    });
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Clipboard.getData('text/plain').then((data) => _pasteBoard = data.text);

    var body = Builder(
      builder: (BuildContext context) {
        return Center(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: TextField(
                    controller: textEditingController,
                    onEditingComplete: () {
                      _translate(context);
                    },
                    textAlign: TextAlign.center,
                    autofocus: true,
                    autocorrect: false,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    RaisedButton(
                      color: ThemeData.light().buttonColor,
                      onPressed: () {
                        _clear(context);
                      },
                      child: Text('CLEAR'),
                    ),
                    RaisedButton(
                      elevation: 10,
                      color: ThemeData.light().primaryColor,
                      textColor: ThemeData.light().primaryColorLight,
                      onPressed: () {
                        _translate(context);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[Text('TRANSLATE')],
                      )),
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                  child: Text(
                    '$_pasteBoard',
                    style: Theme.of(context).primaryTextTheme.headline,
                    textAlign: TextAlign.center,
                  ),
                ),
              ]),
          ),
        );
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: body,
    );
  }
}
