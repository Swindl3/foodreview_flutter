import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'config.dart';
import 'dart:convert';
import 'foodstuff.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

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
    print("OnlOgin");
    Map<String, dynamic> param = Map();
    param['username'] = _userName.text;
    param['password'] = _passWord.text;
    http
        .post('${Config.api_url}/userprofile/login', body: param)
        .then((response) {
      Map resMap = jsonDecode(response.body) as Map;
      print(response.body);
      if (resMap['status'] == 0) {
        int userId = resMap['data'];
        print('user id ${userId}');
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => LandingScreen(userId)));
      } else {
        print(resMap['data']);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Signup or Sign In'),
      ),
      body: ListView(
        children: <Widget>[
          TextField(
            decoration: InputDecoration(hintText: "Username"),
            controller: _userName,
          ),
          TextField(
            decoration: InputDecoration(hintText: "Password"),
            obscureText: true,
            controller: _passWord,
          ),
          new Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              new RaisedButton(
                onPressed: onLogin,
                padding: const EdgeInsets.all(8.0),
                textColor: Colors.white,
                color: Colors.green,
                child: new Text("Sign in"),
              ),
              new RaisedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext) => RegisterScreen()));
                },
                textColor: Colors.white,
                color: Colors.blue,
                padding: const EdgeInsets.all(8.0),
                child: new Text(
                  "Sign up",
                ),
              )
            ],
          ),
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
      print(params);
      http
          .post('${Config.api_url}/userprofile/registor', body: params)
          .then((response) {
        print(response.body);
        Map resMap = jsonDecode(response.body) as Map;
        int status = resMap['status'];
        if (status == 1) {
          setState(() {
            _isError = true;
            _msg = resMap['message'];
            print(_msg);
          });
        } else {
          _showDialog();
        }
      });
    }

    setState(() {});
  }

  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("ลงทะเบียนสำเร็จ"),
          content: new Text("โปรดล็อคอินเพื่อนเข้าใช้งาน"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("ตกลง"),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => ECPApp()));
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
        backgroundColor: Colors.black,
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
