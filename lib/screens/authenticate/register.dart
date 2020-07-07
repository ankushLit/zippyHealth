import 'package:flutter/material.dart';
import 'package:zippyhealth/services/auth.dart';
import 'package:zippyhealth/shared/constants.dart';
import 'package:zippyhealth/shared/loading.dart';

class Register extends StatefulWidget {
  final Function toggleView;
  Register({this.toggleView});
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;
  // text field state
  String _email = '';
  String _password = '';
  String _errorMsg = '';
  String _name = '';
  String _age = '';
  String _mobile = '';
  @override
  Widget build(BuildContext context) {
    return _loading
        ? Loading()
        : Scaffold(
            backgroundColor: const Color(0xff17A589),
            body: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 100.0),
                      TextFormField(
                        decoration:
                            textInputDecorection.copyWith(hintText: 'Name'),
                        validator: (val) =>
                            val.isEmpty ? 'Enter your name' : null,
                        onChanged: (val) {
                          setState(() {
                            _name = val;
                          });
                        },
                      ),
                      SizedBox(height: 20.0),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        decoration:
                            textInputDecorection.copyWith(hintText: 'Age'),
                        validator: (val) =>
                            val.isEmpty ? 'Enter your age' : null,
                        onChanged: (val) {
                          setState(() {
                            _age = val;
                          });
                        },
                      ),
                      SizedBox(height: 20.0),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: textInputDecorection.copyWith(
                            hintText: 'Mobile Number'),
                        validator: (val) => val.isEmpty
                            ? 'Enter your Mobile Number'
                            : val.length < 10
                                ? 'Enter valid mobile number'
                                : null,
                        onChanged: (val) {
                          setState(() {
                            _mobile = val;
                          });
                        },
                      ),
                      SizedBox(height: 20.0),
                      TextFormField(
                        decoration:
                            textInputDecorection.copyWith(hintText: 'Email'),
                        validator: (val) =>
                            val.isEmpty ? 'Enter an email' : null,
                        onChanged: (val) {
                          setState(() {
                            _email = val;
                          });
                        },
                      ),
                      SizedBox(height: 20.0),
                      TextFormField(
                        decoration:
                            textInputDecorection.copyWith(hintText: 'Password'),
                        validator: (val) => val.length < 6
                            ? 'Enter the password 6+ chars long'
                            : null,
                        obscureText: true,
                        onChanged: (val) {
                          setState(() {
                            _password = val;
                          });
                        },
                      ),
                      SizedBox(height: 20.0),
                      RaisedButton(
                        color: const Color(0xff117864),
                        child: Text(
                          'Register',
                          style: TextStyle(
                            color: const Color(0xffD1F2EB),
                          ),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            setState(() {
                              _loading = true;
                            });
                            print(_email);
                            print(_password);
                            dynamic result =
                                await _auth.registerWithEmailAndPassword(
                                    _email, _password, _name, _age, _mobile);
                            if (result == null) {
                              setState(() {
                                _loading = false;
                                _errorMsg = 'Please supply a valid email';
                              });
                            }
                          }
                        },
                      ),
                      SizedBox(height: 20.0),
                      FlatButton(
                        onPressed: () {
                          widget.toggleView();
                        },
                        child: Text(
                          'Already have an account? Sign In',
                          style: TextStyle(color: const Color(0xff117864)),
                        ),
                      ),
                      SizedBox(height: 12.0),
                      Text(
                        _errorMsg,
                        style: TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
