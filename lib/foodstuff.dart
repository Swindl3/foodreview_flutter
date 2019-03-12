import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'config.dart';
import 'dart:convert';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class LandingScreen extends StatefulWidget {
  int _userId;
  LandingScreen(int userId) {
    this._userId = userId;
  }
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _LandingScreen(this._userId);
  }
}

class _LandingScreen extends State {
  int _userId;
  List<Widget> lstData = List();
  _LandingScreen(int userId) {
    this._userId = userId;
  }
  @override
  void initState() {
    // double rating = 5;
    super.initState();
    http.post("${Config.api_url}/foodstuff/list").then((response) {
      Map ret = jsonDecode(response.body) as Map;
      List jsonData = ret["data"];
      for (int i = 0; i < jsonData.length; i++) {
        Map dataMap = jsonData[i];
        Card card = Card(
          child: Column(
            children: <Widget>[
              new Row(
                children: <Widget>[
                  Text("ภาพประกอบ : "),
                  Icon(
                    Icons.ac_unit,
                    size: 30,
                  ),
                ],
              ),
              new Row(
                children: <Widget>[
                  Text("ระดับความอร่อย : "),
                  SmoothStarRating(
                    allowHalfRating: false,
                    onRatingChanged: (v) {
                      dataMap["rating"] = v;
                      setState(() {});
                    },
                    starCount: 5,
                    rating: dataMap["rating"],
                    size: 30.0,
                    color: Colors.green,
                    borderColor: Colors.green,
                  )
                ],
              ),
              new Row(
                children: <Widget>[
                  Text("ชื่อของกิน : "),
                  Text(dataMap["name"]),
                ],
              ),
              new Row(
                children: <Widget>[
                  Text("คำอธิบาย : "),
                  Text(dataMap["description"]),
                ],
              ),
              new Row(
                children: <Widget>[
                  Text("ราคา : "),
                  Text(dataMap["price"].toString()),
                  Text(" บาท"),
                ],
              )
            ],
          ),
        );
        lstData.add(card);
      }

      setState(() {});
    });
  }

  Widget getItem(BuildContext context, int index) {
    return lstData[index];
  }

  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('ของกินอร่อย 2019'),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => ProductSaveScreen(_userId)));
        },
        child: Icon(Icons.add),
      ),
      body: ListView.builder(
        itemBuilder: getItem,
        itemCount: lstData.length,
      ),
    );
  }
}

class ProductSaveScreen extends StatefulWidget {
  int _userId;
  ProductSaveScreen(int userId) {
    this._userId = userId;
  }
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ProductSaveScreen(this._userId);
  }
}

class _ProductSaveScreen extends State {
  int _userId;
  TextEditingController _name = TextEditingController();
  TextEditingController _detail = TextEditingController();
  TextEditingController _price = TextEditingController();
  TextEditingController _rating = TextEditingController();

  _ProductSaveScreen(int userId) {
    this._userId = userId;
  }
  void onSave() {
    print(this._userId);
    Map<String, dynamic> param = Map();
    param['name'] = _name.text;
    param['description'] = _detail.text;
    param['price'] = _price.text;
    param['rating'] = _rating.text;
    param['userId'] = '${this._userId}';
    http.post('${Config.api_url}/foodstuff/save', body: param).then((response) {
      print(response.body);
      Map resMap = jsonDecode(response.body) as Map;
      int status = resMap['status'];
      if (status == 0) {
        setState(() {
          _showDialog();
        });
      } else {}
    });
  }

  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("ลงทะเบียนสำเร็จ"),
          content: new Text("ไอควย"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("ตกลง"),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => LandingScreen(_userId)));
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('เพิ่มรายการของกิน'),
        backgroundColor: Colors.black,
      ),
      body: ListView(
        children: <Widget>[
          TextField(
            controller: _name,
            decoration: InputDecoration(hintText: 'ชื่อของกิน'),
          ),
          TextField(
            controller: _detail,
            decoration: InputDecoration(hintText: 'รายละเอียด'),
          ),
          TextField(
            controller: _price,
            decoration: InputDecoration(hintText: 'ราคา'),
          ),
          TextField(
            controller: _rating,
            decoration: InputDecoration(hintText: 'ระดับความอร่อย (1-5)'),
          ),
          RaisedButton(
            onPressed: onSave,
            color: Colors.green,
            child: Text('บันทึก'),
          )
        ],
      ),
    );
  }
}
