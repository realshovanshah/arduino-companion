import 'package:flutter/material.dart';
import 'package:smart_dustbin/models/user_model.dart';
import 'package:smart_dustbin/services/auth_service.dart';

import '../../utilities/primary_button.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key key, this.title, this.auth, this.onSignIn})
      : super(key: key);

  final String title;
  final BaseAuth auth;
  final ValueSetter<String> onSignIn;

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

enum FormType { login, register }

class _LoginScreenState extends State<LoginScreen> {
  static final formKey = GlobalKey<FormState>();

  String _email;
  String _password;
  String _dustbinId;
  String _contact;
  String _address;
  FormType _formType = FormType.login;
  String _authHint = '';

  String _name;

  bool validateAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void validateAndSubmit() async {
    if (validateAndSave()) {
      UserModel userModel = UserModel(
        email: _email,
        address: _address,
        contact: _contact,
        name: _name,
        password: _password,
      );
      try {
        if (_dustbinId == '2389') {
          String userId = _formType == FormType.login
              ? await widget.auth.signIn(userModel.email, userModel.password)
              : await widget.auth.createUser(userModel);
          setState(() {
            _authHint = 'Signed In\n\nUser id: $userId';
          });
          widget.onSignIn(userId);
        } else {
          setState(() {
            _authHint = 'No dustbin with id $_dustbinId found';
          });
        }
      } catch (e) {
        setState(() {
          _authHint = 'Sign In Error\n\n${e.toString()}';
        });
        print(e);
      }
    } else {
      setState(() {
        _authHint = '';
      });
    }
  }

  void moveToRegister() {
    formKey.currentState.reset();
    setState(() {
      _formType = FormType.register;
      _authHint = '';
    });
  }

  void moveToLogin() {
    formKey.currentState.reset();
    setState(() {
      _formType = FormType.login;
      _authHint = '';
    });
  }

  List<Widget> usernameAndPassword() {
    return [
      padded(
          child: TextFormField(
        key: Key('email'),
        decoration: InputDecoration(labelText: 'Email'),
        autocorrect: false,
        validator: (val) => val.isEmpty ? 'Email can\'t be empty.' : null,
        onSaved: (val) => _email = val,
      )),
      padded(
          child: TextFormField(
        key: Key('password'),
        decoration: InputDecoration(labelText: 'Password'),
        obscureText: true,
        autocorrect: false,
        validator: (val) => val.isEmpty ? 'Password can\'t be empty.' : null,
        onSaved: (val) => _password = val,
      )),
    ];
  }

  List<Widget> dustbinIdWidget() {
    return [
      padded(
          child: TextFormField(
        key: Key('dustbinId'),
        decoration: InputDecoration(labelText: 'Dustbin Id'),
        autocorrect: false,
        onSaved: (val) => _dustbinId = val,
      )),
    ];
  }

  List<Widget> addressWidget() {
    return [
      padded(
          child: TextFormField(
        key: Key('address'),
        decoration: InputDecoration(labelText: 'Address'),
        autocorrect: false,
        onSaved: (val) => _address = val,
      )),
    ];
  }

  List<Widget> contactWidget() {
    return [
      padded(
          child: TextFormField(
        key: Key('contact'),
        decoration: InputDecoration(labelText: 'Contact'),
        autocorrect: false,
        onSaved: (val) => _contact = val,
      )),
    ];
  }

  List<Widget> nameWidget() {
    return [
      padded(
          child: TextFormField(
        key: Key('name'),
        decoration: InputDecoration(labelText: 'Name'),
        autocorrect: false,
        onSaved: (val) => _name = val,
      )),
    ];
  }

  List<Widget> submitWidgets() {
    switch (_formType) {
      case FormType.login:
        return [
          PrimaryButton(
              key: Key('login'),
              text: 'Login',
              height: 44.0,
              onPressed: validateAndSubmit),
          FlatButton(
              key: Key('need-account'),
              child: Text("Need an account? Register"),
              onPressed: moveToRegister),
        ];
      case FormType.register:
        return [
          PrimaryButton(
              key: Key('register'),
              text: 'Create an account',
              height: 44.0,
              onPressed: validateAndSubmit),
          FlatButton(
              key: Key('need-login'),
              child: Text("Have an account? Login"),
              onPressed: moveToLogin),
        ];
    }
    return null;
  }

  Widget hintText() {
    return Container(
        //height: 80.0,
        padding: const EdgeInsets.all(32.0),
        child: Text(_authHint,
            key: Key('hint'),
            style: TextStyle(fontSize: 18.0, color: Colors.grey),
            textAlign: TextAlign.center));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: (_formType == FormType.login)
              ? Text('Login')
              : Text('Register (with dustbin)')),
      backgroundColor: Colors.grey[300],
      body: SingleChildScrollView(
          child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: 100),
            Card(
              child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                Container(
                    padding: const EdgeInsets.all(16.0),
                    child: Form(
                      key: formKey,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: (_formType == FormType.login)
                              ? usernameAndPassword() + submitWidgets()
                              : nameWidget() +
                                  usernameAndPassword() +
                                  dustbinIdWidget() +
                                  addressWidget() +
                                  contactWidget() +
                                  submitWidgets()),
                    )),
              ]),
            ),
            hintText()
          ],
        ),
      )),
    );
  }

  Widget padded({Widget child}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: child,
    );
  }
}
