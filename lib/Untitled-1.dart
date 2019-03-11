FlatButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext) => RegisterScreen()));
            },
            child: Text('ลงทะเบียน'),
          ),
          RaisedButton(child: Text('ตกลง'), onPressed: onLogin)