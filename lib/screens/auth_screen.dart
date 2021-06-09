import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/auth.dart';
import 'package:shop/models/http_exception.dart';

enum AuthMode { Signup, Login }

class AuthScreen extends StatelessWidget {
  static const routeName = '/auth';

  @override
  Widget build(BuildContext context) {
    var _width = MediaQuery.of(context).size.width;
    var _height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              height: _height,
              width: _width,
              child: Column(
                children: [
                  Flexible(
                    child: AuthCard(),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.Login;
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };

  var _isLoading = false;
  final _passwordController = TextEditingController();

  void _showErrorDialog(String message) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text('An error occured'),
              content: Text(message),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(ctx);
                    },
                    child: Text('OK')),
              ],
            ));
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });

    try {
      if (_authMode == AuthMode.Login) {
        //login
        await Provider.of<Auth>(context, listen: false).login(
            _authData['email'].toString(), _authData['password'].toString());
      } else {
        //signup
        await Provider.of<Auth>(context, listen: false).signup(
            _authData['email'].toString(), _authData['password'].toString());
      }
    } on HttpException catch (e) {
      var errorMessage = "Authentication failed";
      if (e.toString().contains('EMAIL_EXISTS')) {
        errorMessage = "This email address is already in use";
      } else if (e.toString().contains('INVALID_EMAIL')) {
        errorMessage = "This is not a valid email";
      } else if (e.toString().contains('WEAK_PASWORD')) {
        errorMessage = "This password is too weak";
      } else if (e.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = "Could not find a user with that email";
      } else if (e.toString().contains('INVALID_PASSWORD')) {
        errorMessage = "Invalid Password";
      }
      _showErrorDialog(errorMessage);
    } catch (error) {
      const errorMessage = "Could not authenticate you. Please try again later";
      _showErrorDialog(errorMessage);
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
      });
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
    }
  }

  final ButtonStyle _elevatedBtnStyle = ElevatedButton.styleFrom(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 8),
    textStyle: TextStyle(color: Colors.white),
  );

  final ButtonStyle _textBtnStyle = TextButton.styleFrom(
    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 4),
    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    textStyle: TextStyle(color: Colors.white),
  );

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Center(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 8,
        child: Container(
          height: _authMode == AuthMode.Signup ? 320 : 260,
          constraints: BoxConstraints(
              minHeight: _authMode == AuthMode.Signup ? 320 : 260),
          width: deviceSize.width * 0.75,
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  //email field
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Email'),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value!.isEmpty || !value.contains('@')) {
                        return 'Invalid email';
                      }
                    },
                    onSaved: (value) {
                      _authData['email'] = value.toString();
                    },
                  ),

                  //password field
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    controller: _passwordController,
                    keyboardType: TextInputType.visiblePassword,
                    validator: (value) {
                      if (value!.isEmpty || value.length < 5) {
                        return 'Password is too short';
                      }
                    },
                    onSaved: (value) {
                      _authData['password'] = value.toString();
                    },
                  ),

                  //confirm password
                  if (_authMode == AuthMode.Signup)
                    TextFormField(
                      enabled: _authMode == AuthMode.Signup,
                      decoration:
                          InputDecoration(labelText: "Confirm-Password"),
                      obscureText: true,
                      validator: _authMode == AuthMode.Signup
                          ? (value) {
                              if (value != _passwordController.text) {
                                return 'Password do not match';
                              }
                            }
                          : null,
                    ),

                  SizedBox(
                    height: 20,
                  ),

                  if (_isLoading)
                    CircularProgressIndicator()
                  else
                    ElevatedButton(
                      child: Text(
                          _authMode == AuthMode.Login ? 'Login' : 'Sign Up'),
                      onPressed: _submit,
                      style: _elevatedBtnStyle,
                    ),

                  TextButton(
                    onPressed: _switchAuthMode,
                    child: Text(
                        "${_authMode == AuthMode.Login ? 'Sign up' : 'Login'} Instead"),
                    style: _textBtnStyle,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
