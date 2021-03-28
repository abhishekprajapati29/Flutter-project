import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:filesize/filesize.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fproject/gettoken.dart';

import 'api_response.dart';

class AddPosts extends StatefulWidget {
  Function handleAddPost;
  AddPosts({Key key, this.handleAddPost}) : super(key: key);

  @override
  _AddPostsState createState() => _AddPostsState();
}

class _AddPostsState extends State<AddPosts> {
  TextEditingController postName = new TextEditingController();
  bool loading = false;
  String _fileName = "";
  String _path;
  File _file;
  bool _switchValue = false;

  void _openFileExplorer() async {
    try {
      _file = await FilePicker.getFile(type: FileType.image);
      _path = _file.path;
      setState(() {
        _file = _file;
        _path = _path;
        _fileName = _path.split('/').last;
      });
    } on PlatformException catch (e) {
      print("Unsupported operation" + e.toString());
    }
    if (!mounted) return;
  }

  loadingchange() {
    this.setState(() {
      loading = !loading;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text('Add Post'),
        centerTitle: true,
      ),
      backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            SizedBox(
              height: 20.0,
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                height: 40.0,
                width: 40.0,
                decoration: BoxDecoration(
                  color: Colors.teal,
                  borderRadius: BorderRadius.vertical(
                      top: Radius.circular(10), bottom: Radius.circular(10)),
                ),
                child: Icon(
                  FontAwesomeIcons.envelopeOpenText,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Padding(
              padding: const EdgeInsets.all(13.0),
              child: TextField(
                controller: postName,
                keyboardType: TextInputType.text,
                cursorColor: Colors.black,
                style: TextStyle(color: Colors.black),
                decoration: new InputDecoration(
                  fillColor: Colors.white,
                  border: new OutlineInputBorder(
                      borderSide: new BorderSide(color: Colors.white)),
                  hintText: 'Post',
                  labelText: 'Posts Message',
                ),
              ),
            ),
            new Padding(
              padding: const EdgeInsets.only(top: 10.0, bottom: 20.0),
              child: new RaisedButton.icon(
                icon: Icon(Icons.image),
                color: Colors.white,
                onPressed: () => _openFileExplorer(),
                label: new Text(
                  "Selected Image for Post",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
            Container(child: _fileName != null ? Text(_fileName) : Container()),
            Container(
                child: _file != null
                    ? Text(filesize(_file.lengthSync().toString()))
                    : Container()),
            SizedBox(
              height: 60.0,
            ),
            RaisedButton.icon(
                elevation: 8,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                color: Colors.teal,
                onPressed: !loading
                    ? () {
                        postName.text == "" && _file == null
                            ? Fluttertoast.showToast(
                                msg: "Post and Image is Null!",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                webShowClose: true,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.black,
                                textColor: Colors.white,
                                fontSize: 16.0)
                            : getTokenPreferences().then((token) {
                                createAddPost(
                                        token,
                                        {
                                          'name': postName.text != ""
                                              ? postName.text
                                              : null,
                                          'file': _file != null ? _file : null,
                                          'filepath':
                                              _file != null ? _file.path : null,
                                          'filename':
                                              _file != null ? _fileName : null,
                                        },
                                        loadingchange)
                                    .then((value) {
                                  widget.handleAddPost(value);
                                });
                              });
                      }
                    : null,
                icon: Icon(
                  Icons.cloud,
                  color: Colors.white,
                ),
                label: !loading
                    ? Text(
                        'Upload',
                        style: TextStyle(color: Colors.white),
                      )
                    : CircularProgressIndicator(backgroundColor: Colors.white)),
            SizedBox(
              height: 20.0,
            )
          ],
        ),
      ),
    );
  }
}
