import 'package:flutter/material.dart';
import 'package:http/http.dart' as http ;
import 'config.dart';
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
  _LandingScreen(int userId) {
    this._userId =userId;
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: Text('โชว์ห่วย 2019'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => ProductSaveScreen(_userId)));
          },
          child: Icon(Icons.add),
        ));
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

  _ProductSaveScreen(int userId) {
    this._userId = userId;
  }
  void onSave() {
    print(this._userId);
    Map<String, dynamic> param = Map();
    param['name'] = _name.text;
    param['description'] = _detail.text;
    param['price'] = _price.text;
    param['userId'] = '${this._userId}';
    http.post('${Config.api_url}/product/save',body: param).then((response){
      print(response.body);
    }
    );
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('บันทึกสินค้า'),
      ),
      body: ListView(
        children: <Widget>[
          TextField(
            controller: _name,
          ),
          TextField(
            controller: _detail,
          ),
          TextField(
            controller: _price,
          ),
          RaisedButton(
            onPressed: onSave,
            child: Text('บันทึก'),
          )
        ],
      ),
    );
  }
}
