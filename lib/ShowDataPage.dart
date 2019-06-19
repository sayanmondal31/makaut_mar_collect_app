import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:makaut_points/myData.dart';

class ShowDataPage extends StatefulWidget {
  @override
  _ShowDataPageState createState() => _ShowDataPageState();
}

class _ShowDataPageState extends State<ShowDataPage> {
  List<myData> allData = [];

  @override
  void initState() {
    DatabaseReference ref = FirebaseDatabase.instance.reference();
    ref.child('node-name').once().then((DataSnapshot snap) {
      var keys = snap.value.keys;
      var data = snap.value;
      allData.clear();
      for (var key in keys) {
        myData d = new myData(
          data[key]['name'],
          data[key]['points'],
          data[key]['semester'],
        );
        allData.add(d);
      }
      setState(() {
        print('Length : ${allData.length}');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text('points data'),
      ),
      body: new Container(
          child: allData.length == 0
              ? new Text(' No Data is Available')
              : new ListView.builder(
                  itemCount: allData.length,
                  itemBuilder: (_, index) {
                    return UI(
                      allData[index].name,
                      allData[index].semester,
                      allData[index].points,
                    );
                  },
                )),
    );
  }

  Widget UI(String name, String semester, String points) {
    return new Card(
      elevation: 10.0,
      child: new Container(
        padding: new EdgeInsets.all(20.0),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Text('Name : $name',style: Theme.of(context).textTheme.title,),
            new Text('semester : $semester'),
            new Text('points : $points'),
          ],
        ),
      ),
    );
  }
}
