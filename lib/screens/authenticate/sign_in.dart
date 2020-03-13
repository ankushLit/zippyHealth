import 'package:flutter/material.dart';
import 'package:zippyhealth/services/auth.dart';
import 'package:zippyhealth/shared/constants.dart';
import 'package:zippyhealth/shared/loading.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;
  SignIn({this.toggleView});
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;
  // text field state
  String _email = '';
  String _password = '';
  String _errorMsg = '';
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
                          'Sign In',
                          style: TextStyle(
                            color: const Color(0xffD1F2EB),
                          ),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            print(_email);
                            print(_password);
                            setState(() {
                              _loading = true;
                            });
                            dynamic result = await _auth
                                .signInWithEmailAndPassword(_email, _password);
                            if (result == null) {
                              setState(() {
                                _loading = false;
                                _errorMsg =
                                    'Could not sign-in with those credentials';
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
                          'Don\'t have an account yet? Register',
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
