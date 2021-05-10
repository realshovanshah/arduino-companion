import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_dustbin/bloc/dustbin_bloc.dart';
import 'package:smart_dustbin/utilities/utils.dart';

class UploadScreen extends StatefulWidget {
  UploadScreen({Key key, this.text}) : super(key: key);
  final String text;

  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  static final formKey = GlobalKey<FormState>();

  bool uploading = false;
  final picker = ImagePicker();
  List<File> _images = [];

  String _did;

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (BuildContext context) {
        final imageBloc = BlocProvider.of<ImageBloc>(context);
        String text;
        return Scaffold(
            appBar: AppBar(
              title: Text(widget.text),
              actions: [
                FlatButton(
                    onPressed: () {
                      setState(() {
                        uploading = true;
                      });
                      (widget.text == 'Add a Dustbin!')
                          ? imageBloc.add(ImageAddedEvent(_images))
                          : imageBloc.add(ImageUpdatedEvent(
                              _images,
                              ModalRoute.of(context).settings.arguments
                                  as List<String>));
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Upload',
                      style: TextStyle(fontSize: 15, color: Colors.white),
                    ))
              ],
            ),
            body: Stack(
              children: [
                Container(
                  padding: EdgeInsets.all(24),
                  child: GridView.builder(
                      shrinkWrap: true,
                      itemCount: _images.length + 1,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3),
                      itemBuilder: (context, index) {
                        return index == 0
                            ? Container(
                                margin: EdgeInsets.all(8),
                                color: Colors.blueAccent,
                                child: Center(
                                  child: Builder(
                                    builder: (BuildContext context) {
                                      return IconButton(
                                          icon: Icon(Icons.add),
                                          onPressed: () => !uploading
                                              ? chooseImage()
                                              : null);
                                    },
                                  ),
                                ),
                              )
                            : Container(
                                margin: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: FileImage(_images[index - 1]),
                                        fit: BoxFit.cover)),
                              );
                      }),
                ),
                uploading ? ProgressBarWidget() : Container(),
              ],
            ));
      },
    );
  }

  chooseImage() async {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: SizedBox(
            height: 300,
            child: AlertDialog(
              content: Center(
                child: Form(
                  key: formKey,
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Padding(
                        padding:
                            EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Text(
                                  'Dustbin Id',
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        )),
                    Padding(
                      padding:
                          EdgeInsets.only(left: 25.0, right: 25.0, top: 2.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Flexible(
                            child: TextFormField(
                              onChanged: (value) => _did = value,
                              validator: (val) =>
                                  val.isEmpty ? 'Id can\'t be empty.' : null,
                              decoration: const InputDecoration(
                                hintText: "Enter your dustbin Id",
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        FlatButton(
                            child: const Text('CANCEL'),
                            onPressed: () {
                              Navigator.pop(context);
                            }),
                        FlatButton(
                            child: const Text('DONE'),
                            onPressed: () {
                              if (validateAndSave()) {
                                SharedPreferences.getInstance().then(
                                  (value) => {
                                    value.setString('dustbinId', _did),
                                    print(value.getString('dustbinId')),
                                  },
                                );

                                getImage()
                                    .then((value) => {Navigator.pop(context)});
                              }
                            }),
                      ],
                    ),
                  ]),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future getImage() async {
    await Permission.storage.request();

    var permissionStatus = await Permission.storage.status;

    if (permissionStatus.isGranted) {
      print(permissionStatus.isGranted);
      final pickedFile = await picker.getImage(source: ImageSource.gallery);
      setState(() {
        _images.add(File(pickedFile?.path));
      });
    } else {
      print("not granted permissions");
    }
  }

  bool validateAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }
}

class ProgressBarWidget extends StatelessWidget {
  const ProgressBarWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(),
          SizedBox(
            height: 16,
          ),
          Text(" Uploading..."),
        ],
      )),
    );
  }
}
