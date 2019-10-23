import 'package:flutter/material.dart';
import 'authentication.dart';
import 'package:my_ios_app/styles.dart';

// ENUM for togling form mode
enum FormMode { LOGIN, SIGNUP }

class LoginSignUpPage extends StatefulWidget {
  LoginSignUpPage({this.auth, this.onSignedIn});
  final Auth auth;
  final VoidCallback onSignedIn;

  @override
  _LoginSignUpPageState createState() => _LoginSignUpPageState();
}

class _LoginSignUpPageState extends State<LoginSignUpPage> {
  //Init key for working with form
  final _formKey = new GlobalKey<FormState>();

  String _email;
  String _password;
  String _errorMessage;

  // Initial form is login form
  FormMode _formMode = FormMode.LOGIN;
  bool _isIos;
  bool _isLoading;

  void _changeFormToSignUp() {
    _formKey.currentState.reset();
    _errorMessage = "";
    setState(() {
      _formMode = FormMode.SIGNUP;
    });
  }

  void _changeFormToLogin() {
    _formKey.currentState.reset();
    _errorMessage = "";
    setState(() {
      _formMode = FormMode.LOGIN;
    });
  }

// Check if form is valid
  bool _validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  // Get user ID depending on Form type
  Future<String> _getUserId() async {
    String userId = "";
    if (_formMode == FormMode.LOGIN) {
      userId = await widget.auth.signIn(_email, _password);
      print('Signed in: $userId');
    } else {
      userId = await widget.auth.signUp(_email, _password);
      print('Signed up user: $userId');
    }
    setState(() {
      _isLoading = false;
    });

    if (userId.length > 0 && userId != null && _formMode == FormMode.LOGIN) {
      widget.onSignedIn();
    }

    return userId;
  }

  // Perform login or signup
  void _validateAndSubmit() async {
    setState(() {
      _errorMessage = "";
      _isLoading = true;
    });
    if (_validateAndSave()) {
      String userId = "";
      try {
        userId = await _getUserId();
      } catch (e) {
        print('Error: $e');
        setState(() {
          _isLoading = false;
          _errorMessage = e.message;
        });
      }
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Inital state
  @override
  void initState() {
    _errorMessage = "";
    _isLoading = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //Get appropriate platform
    //_isIos = Theme.of(context).platform == TargetPlatform.iOS;

    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Flutter login demo"),
      ),
      body: new Stack(
        children: <Widget>[
          _showBody(),
          _showCircularProgress(),
        ],
      ),
    );
  }

  Widget _showBody() {
    return new Container(
        padding: EdgeInsets.all(16.0),
        child: new Form(
          key: _formKey,
          child: new ListView(
            shrinkWrap: true,
            children: <Widget>[
              _showLogo(),
              _formMode == FormMode.SIGNUP
                  ? _showNameInput()
                  : SizedBox.shrink(),
              _formMode == FormMode.SIGNUP
                  ? _showPhoneInput()
                  : SizedBox.shrink(),
              _showEmailInput(),
              _showPasswordInput(),
              _showPrimaryButton(),
              _showSecondaryButton(),
              _showErrorMessage(),
            ],
          ),
        ));
  }

  Widget _showCircularProgress() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return Container(
      height: 0.0,
      width: 0.0,
    );
  }

  Widget _showLogo() {
    return new Hero(
      tag: 'hero',
      child: Padding(
        padding: EdgeInsets.fromLTRB(0.0, 70.0, 0.0, 50.0),
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 48.0,
          child: Image.asset('assets/iot.png'),
        ),
      ),
    );
  }

  Widget _showEmailInput() {
    return Padding(
      padding: Styles.inputFormPadding,
      child: new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'Email',
            icon: new Icon(
              Icons.mail,
              color: Colors.grey,
            )),
        validator: (value) => value.isEmpty ? 'Email can\'t be empty' : null,
        onSaved: (value) => _email = value.trim(),
      ),
    );
  }

  Widget _showPasswordInput() {
    return Padding(
      padding: Styles.inputFormPadding,
      child: new TextFormField(
        maxLines: 1,
        obscureText: true,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'Password',
            icon: new Icon(
              Icons.lock,
              color: Colors.grey,
            )),
        validator: (value) {
          if (value.isEmpty) return 'Password can\'t be empty';
          if (value.length < 8) return 'Password is too short';
          return null;
        },
        onSaved: (value) => _password = value.trim(),
      ),
    );
  }

  Widget _showNameInput() {
    return Padding(
      padding: Styles.inputFormPadding,
      child: new TextFormField(
        maxLines: 1,
        obscureText: false,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'Name',
            icon: new Icon(
              Icons.people,
              color: Colors.grey,
            )),
        validator: (value) {
          if (value.isEmpty) return 'Name can\'t be empty';
          if (value.length < 1) return 'Name is too short';
          return null;
        },
        onSaved: (value) => _password = value.trim(),
      ),
    );
  }

  Widget _showPhoneInput() {
    return Padding(
      padding: Styles.inputFormPadding,
      child: new TextFormField(
        maxLines: 1,
        obscureText: false,
        autofocus: false,
        keyboardType: TextInputType.phone,
        decoration: new InputDecoration(
            hintText: 'Phone',
            icon: new Icon(
              Icons.phone,
              color: Colors.grey,
            )),
        validator: (value) {
          if (value.isEmpty) return 'Phone can\'t be empty';
          return null;
        },
        onSaved: (value) => _password = value.trim(),
      ),
    );
  }

  Widget _showPrimaryButton() {
    return new Padding(
        padding: Styles.primaryButtonPadding,
        child: new MaterialButton(
          elevation: 5.0,
          minWidth: 200.0,
          height: 42.0,
          color: Colors.blue,
          child: _formMode == FormMode.LOGIN
              ? new Text('Login', style: Styles.primaryText)
              : new Text('Create account', style: Styles.primaryText),
          onPressed: _validateAndSubmit,
        ));
  }

  Widget _showSecondaryButton() {
    return new FlatButton(
      child: _formMode == FormMode.LOGIN
          ? new Text('Create an account', style: Styles.secondaryText)
          : new Text('Have an account? Sign in', style: Styles.secondaryText),
      onPressed: _formMode == FormMode.LOGIN
          ? _changeFormToSignUp
          : _changeFormToLogin,
    );
  }

  Widget _showErrorMessage() {
    if (_errorMessage.length > 0 && _errorMessage != null) {
      return new Text(_errorMessage, style: Styles.errorText);
    } else {
      return new Container(
        height: 0.0,
      );
    }
  }
}
