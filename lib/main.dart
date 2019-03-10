import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'config.dart';
import 'dart:convert';
import 'product.dart';

void main() {
  runApp(MaterialApp(
    home: ECPApp(),
  ));
}

class ECPApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ECPApp();
  }
}

class _ECPApp extends State {
  TextEditingController _userName = TextEditingController();
  TextEditingController _passWord = TextEditingController();
  void onLogin() {
    Map<String, dynamic> param = Map();
    param['userName'] = _userName.text;
    param['passWord'] = _passWord.text;
    http
        .post('${Config.api_url}/userprofile/login', body: param)
        .then((response) {
      Map resMap = jsonDecode(response.body) as Map;
      if (resMap['status'] == 0) {
        int userId = resMap['data'];
        print('user id ${userId}');
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => LandingScreen(userId)));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('ECP'),
      ),
      body: ListView(
        children: <Widget>[
          TextField(
            controller: _userName,
          ),
          TextField(
            controller: _passWord,
          ),
          FlatButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext) => RegisterScreen()));
            },
            child: Text('ลงทะเบียน'),
          ),
          RaisedButton(child: Text('ตกลง'), onPressed: onLogin)
        ],
      ),
    );
  }
}

class RegisterScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _RegisterScreen();
  }
}

class _RegisterScreen extends State {
  TextEditingController _username = TextEditingController();
  TextEditingController _password1 = TextEditingController();
  TextEditingController _password2 = TextEditingController();
  TextEditingController _firstname = TextEditingController();
  TextEditingController _lastname = TextEditingController();

  bool _isError = false;
  String _msg = null;
  void onReg() {
    if (_password1.text != _password2.text) {
      _isError = true;
      _msg = 'รหัสผ่านไม่ตรงกัน';
    } else {
      _isError = false;
      Map<String, String> params = Map();
      params['userName'] = _username.text;
      params['passWord'] = _password1.text;
      params['firstName'] = _firstname.text;
      params['lastName'] = _lastname.text;
      http
          .post('${Config.api_url}/userprofile/registor', body: params)
          .then((response) {
        Map resMap = jsonDecode(response.body) as Map;
        int status = resMap['status'];
        if (status == 1) {
          setState(() {
            _isError = true;
            _msg = resMap['message'];
          });
        } else {}
      });
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('ลงทะเบียน'),
      ),
      body: ListView(
        children: <Widget>[
          _isError
              ? Text(
                  _msg,
                  style: TextStyle(color: Colors.red),
                )
              : Padding(
                  padding: EdgeInsets.all(0.0),
                ),
          TextField(
            controller: _username,
            decoration: InputDecoration(hintText: 'UserName'),
          ),
          TextField(
            controller: _password1,
            decoration: InputDecoration(
              hintText: 'รหัสผ่าน',
            ),
            obscureText: true,
          ),
          TextField(
            controller: _password2,
            decoration: InputDecoration(
              hintText: 'รหัสผ่านอีกครั้ง',
            ),
            obscureText: true,
          ),
          TextField(
            controller: _firstname,
            decoration: InputDecoration(hintText: 'ชื่อ'),
          ),
          TextField(
            controller: _lastname,
            decoration: InputDecoration(hintText: 'นามสกุล'),
          ),
          RaisedButton(
            onPressed: onReg,
            child: Text('ตกลง'),
          )
        ],
      ),
    );
  }
}
