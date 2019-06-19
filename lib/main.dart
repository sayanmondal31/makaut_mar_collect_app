import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:makaut_points/ShowDataPage.dart';

void main() => runApp(myApp());

class myApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:MyApp()
      
    );
  }
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  GlobalKey<FormState> _key = new GlobalKey();
  bool _autovalidate = false;
  String name, semester, points;
  List<DropdownMenuItem<String>> items = [
    new DropdownMenuItem(
      child: new Text('SEM-1'),
      value: 'SEM-1',
    ),
    new DropdownMenuItem(
      child: new Text('SEM-2'),
      value: 'SEM-2',
    ),
    new DropdownMenuItem(
      child: new Text('SEM-3'),
      value: 'SEM-3',
    ),
    new DropdownMenuItem(
      child: new Text('SEM-4'),
      value: 'SEM-4',
    ),
    new DropdownMenuItem(
      child: new Text('SEM-5'),
      value: 'SEM-6',
    ),
    new DropdownMenuItem(
      child: new Text('SEM-7'),
      value: 'SEM-7',
    ),
    new DropdownMenuItem(
      child: new Text('SEM-8'),
      value: 'SEM-8',
    ),
    
  ];

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('MAR POINTS'),
        ),
        body: new SingleChildScrollView(
          child: new Container(
            padding: new EdgeInsets.all(15.0),
            child: new Form(
              key: _key,
              autovalidate: _autovalidate,
              child: FormUI(),
            ),
          ),
        ),
    );
  }

  Widget FormUI() {
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        new Row(
          children: <Widget>[
            new Flexible(
              child: new TextFormField(
                decoration: new InputDecoration(hintText: 'Name'),
                validator: validateName,
                onSaved: (val) {
                  name = val;
                },
                maxLength: 32,
              ),
            ),
            new SizedBox(width: 10.0),
            new DropdownButtonHideUnderline(
                child: new DropdownButton(
              items: items,
              hint: new Text('semester'),
              value: semester,
              onChanged: (String val) {
                setState(() {
                  semester = val;
                });
              },
            ))
          ],
        ),
        new TextFormField(
          decoration: new InputDecoration(hintText: 'MAR POINTS'),
          onSaved: (val) {
            points = val;
          },
          validator: validateMessage,
          maxLines: 5,
          maxLength: 256,
        ),
        new RaisedButton(
          onPressed: _sendToServer,
          child: new Text('Send'),
        ),
        new SizedBox(height: 20.0),
        new RaisedButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => new ShowDataPage()));
          },
          child: new Text('Show Data'),
        )
      ],
    );
  }

  _sendToServer() {
    if (_key.currentState.validate()) {
      _key.currentState.save();
      DatabaseReference ref = FirebaseDatabase.instance.reference();
      var data = {
        "name": name,
        "semester": semester,
        "points": points,
      };
      ref.child('node-name').push().set(data).then((v) {
        _key.currentState.reset();
      });
    } else {
      setState(() {
        _autovalidate = true;
      });
    }
  }

  String validateName(String val) {
    return val.length == 0 ? "Enter Name First" : null;
  }

  String validateMessage(String val) {
    return val.length == 0 ? "Enter points First" : null;
  }
}
