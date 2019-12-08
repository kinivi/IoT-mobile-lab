import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_ios_app/api/api.dart';
import 'package:my_ios_app/api/worker.dart';
import 'package:my_ios_app/strings.dart';
import 'package:my_ios_app/styles.dart';

class AddPage extends StatefulWidget {
  AddPage({Key key, this.api}) : super(key: key);
  Api api;

  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final _formKey = new GlobalKey<FormState>();
  Worker _newWorker = new Worker();
  String _defaultImgLink =
      "https://firebasestorage.googleapis.com/v0/b/mobile-lab-9a057.appspot.com/o/transport-images%2Fkamaz.jpg?alt=media&token=80eaa9e1-df99-4db3-9a4d-035cd0360f31";

  TextEditingController _mineIdController;
  TextEditingController _nameController;
  bool _isLoading = false;

  Future<void> _saveNewWorker(Worker newWorker) async {
    //Change to loading state
    setState(() {
      _isLoading = true;
    });

    //Generate ID and post new worker
    newWorker.id = Random().nextInt(10000);
    int code = await widget.api.postTransport(newWorker);

    //Back to previous screen and send results of saving
    Navigator.pop(context, {"result_code": code});
  }

  bool _validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  @override
  void initState() {
    super.initState();
    print(widget.api);
    _newWorker.imageLink = _defaultImgLink;
    _newWorker.transportId = Random().nextInt(999);
    _newWorker.mineId = Random().nextInt(10);
    _newWorker.transportName = "";
    _newWorker.startTs = new DateTime.now().second;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text(Strings.addPageTitle),
      ),
      body: new Container(
          child: new Form(
        key: _formKey,
        child: new ListView(
          padding: Styles.cardPadding,
          shrinkWrap: true,
          children: _isLoading
              ? <Widget>[_showLoadingCircle()]
              : <Widget>[_showNameInput(), _showMineIdInput(), _showButton()],
        ),
      )),
    );
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
                    hintText: "Transport name",
                    icon: new Icon(
                      Icons.people,
                      color: Colors.grey,
                    )),
                onSaved: (value) => _newWorker.transportName = value.trim(),
              ),
            )
          ],
        ));
  }

  Widget _showMineIdInput() {
    return Padding(
        padding: Styles.inputFormPadding,
        child: Row(
          children: <Widget>[
            Expanded(
              child: new TextFormField(
                maxLines: 1,
                obscureText: false,
                autofocus: false,
                controller: _mineIdController,
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  WhitelistingTextInputFormatter.digitsOnly
                ],
                decoration: new InputDecoration(
                    hintText: "Mine id",
                    icon: new Icon(
                      Icons.people,
                      color: Colors.grey,
                    )),
                onSaved: (value) => _newWorker.mineId = int.parse(value.trim()),
              ),
            )
          ],
        ));
  }

  Widget _showButton() {
    return MaterialButton(
        child: Text("Save"),
        color: Colors.green,
        onPressed: () {
          if (_validateAndSave()) {
            _saveNewWorker(_newWorker);
          }
        });
  }

  Widget _showLoadingCircle() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return Container(
      height: 0.0,
      width: 0.0,
    );
  }
}
