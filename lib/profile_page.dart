import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:my_ios_app/strings.dart';
import 'package:my_ios_app/styles.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'authentication.dart';

// ENUM for togling editing mode
enum EditStatus { Editing, Showing }

class ProfilePage extends StatefulWidget {
  ProfilePage({this.auth});

  final Auth auth;

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File _image;
  final _formKey = new GlobalKey<FormState>();
  bool _isEnabled = false;
  String _name = "";
  String _email = "";
  String _profileURL;
  String _stockURL = "https://images.unsplash.com/photo-1502164980785-f8aa41d53611?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60";

  TextEditingController _emailController;
  TextEditingController _nameController;

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _updateProfile();
  }

  Future<void> _updateProfile() async {
    FirebaseUser _user = await widget.auth.getCurrentUser();
    _emailController = new TextEditingController(text: _email);
    _nameController = new TextEditingController(text: _name);

    setState(() {
      _email = _user.email;
      _name = _user.displayName;
      _profileURL = _user.photoUrl;

      _emailController.text = _email;
      print(_emailController.text);
      _nameController.text = _name;
    });
  }

  @override
  Widget build(BuildContext context) {
    Future getImage() async {
      var image = await ImagePicker.pickImage(source: ImageSource.gallery);

      setState(() {
        _image = image;
        _isSaving = true;
        print('Image Path $_image');
      });
    }

    Future uploadPic(BuildContext context) async {
      String fileName = basename(_image.path);
      StorageReference firebaseStorageRef =
          FirebaseStorage.instance.ref().child(fileName);
      StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);
      StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
      String url = await taskSnapshot.ref.getDownloadURL();

      print(url);
      setState(() {
        _isSaving = false;
        _profileURL = url;

        //Saving uploaded avatar URL to Firebase profile
        widget.auth.updateProfileURL(_profileURL);
        Scaffold.of(context)
            .showSnackBar(SnackBar(content: Text('Profile Picture Uploaded')));
      });
    }

// Check if form is valid
    bool _validateAndSave() {
      final form = _formKey.currentState;
      if (form.validate()) {
        form.save();
        print(_email);
        return true;
      }
      return false;
    }

    void _validateAndSubmit() async {
      if (_validateAndSave()) {
        try {
          widget.auth.updateInfo(_email, _name);
        } catch (e) {
          print('Error: $e');
          setState(() {
            _isEnabled = false;
          });
        }
      } else {
        setState(() {
          _isEnabled = false;
        });
      }
    }

    Widget _showButtons() {
      return (_isEnabled
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                MaterialButton(
                  child: Text("Cancel"),
                  color: Colors.red,
                  onPressed: () {
                    setState(() {
                      _isEnabled = false;
                    });
                  },
                ),
                MaterialButton(
                  child: Text("Save"),
                  color: Colors.green,
                  onPressed: () {
                    setState(() {
                      _validateAndSubmit();
                      _isEnabled = false;
                    });
                  },
                )
              ],
            )
          : Container());
    }

    Widget _showAvatar() {
      return CircleAvatar(
        radius: Styles.avatarRadius,
        backgroundColor: Colors.black87,
        child: ClipOval(
          child: new SizedBox(
            width: Styles.clipAvatarSize,
            height: Styles.clipAvatarSize,
            child: (_image != null)
                ? Image.file(
                    _image,
                    fit: BoxFit.fill,
                  )
                : Image.network(
                    _profileURL != null
                        ? _profileURL
                        : _stockURL,
                    fit: BoxFit.fill,
                  ),
          ),
        ),
      );
    }

    Widget _showEmailInput() {
      return Padding(
          padding: Styles.inputFormPadding,
          child: Row(
            children: <Widget>[
              Expanded(
                child: new TextFormField(
                  maxLines: 1,
                  controller: _emailController,
                  enabled: _isEnabled,
                  keyboardType: TextInputType.emailAddress,
                  autofocus: false,
                  decoration: new InputDecoration(
                      hintText: Strings.hintEmail,
                      icon: new Icon(
                        Icons.mail,
                        color: Colors.grey,
                      )),
                  validator: (value) => value.isEmpty
                      ? Strings.errorEmptyEmail
                      : (RegExp(Strings.regexpEmail)
                              .hasMatch(value)
                          ? null
                          : Strings.errorFormat),
                  onSaved: (value) => _email = value.trim(),
                ),
              ),
              new IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    setState(() {
                      _isEnabled = true;
                    });
                  })
            ],
          ));
    }

    Widget _showNameInput() {
      return Padding(
          padding: Styles.inputFormPadding,
          child: Row(
            children: <Widget>[
              Expanded(
                child: new TextFormField(
                  maxLines: 1,
                  obscureText: false,
                  autofocus: false,
                  controller: _nameController,
                  decoration: new InputDecoration(
                      hintText: Strings.hintName,
                      icon: new Icon(
                        Icons.people,
                        color: Colors.grey,
                      )),
                  validator: (value) {
                    if (value.isEmpty) return Strings.errorEmptyName;
                    if (value.length < 1) return Strings.errorShortName;
                    return null;
                  },
                  onSaved: (value) => _name = value.trim(),
                ),
              ),
              new IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    setState(() {
                      _isEnabled = true;
                    });
                  })
            ],
          ));
    }

    Widget _showFloatingButton() {
      if (_isSaving) {
        return new FloatingActionButton(
          onPressed: () => uploadPic(context),
          child: Icon(Icons.check),
          backgroundColor: Colors.green,
        );
      } else {
        return new FloatingActionButton(
          onPressed: () => getImage(),
          child: Icon(Icons.camera),
          backgroundColor: Colors.blue,
        );
      }
    }

    return Scaffold(
        body: Container(
            padding: Styles.cardPadding,
            child: new Form(
              key: _formKey,
              child: new ListView(
                shrinkWrap: true,
                children: <Widget>[
                  _showAvatar(),
                  _showEmailInput(),
                  _showNameInput(),
                  _showButtons()
                ],
              ),
            )),
        floatingActionButton: _showFloatingButton());
  }
}
