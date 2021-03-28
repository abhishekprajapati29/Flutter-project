import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:filesize/filesize.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'model.dart';

class AddFile extends StatefulWidget {
  String token;
  Function addCreatedFileData;
  AddFile({Key key, this.token, this.addCreatedFileData}) : super(key: key);

  @override
  _AddFileState createState() => _AddFileState();
}

class _AddFileState extends State<AddFile> {
  TextEditingController fileNameText = new TextEditingController();
  bool loading = false;
  String _fileName = "";
  String _path;
  File _file;
  Map<String, String> _paths;
  List<File> _files;
  String _extension;
  bool _switchValue = false;
  bool _multiPick = false;
  bool _hasValidMime = false;
  FileType _pickingType;
  TextEditingController _controller = new TextEditingController();
  bool downloading = false;
  var progressString = "";
  int totalprogressString = 0;
  int runningprogressString = 0;
  @override
  void initState() {
    super.initState();
    _controller.addListener(() => _extension = _controller.text);
  }

  void _openFileExplorer() async {
    try {
      if (_multiPick) {
        _path = null;
        _files = null;
      } else {
        _paths = null;
        _file = await FilePicker.getFile(
            type: FileType.custom, allowedExtensions: ['exe', 'pdf', 'zip']);
        _path = _file.path;
        setState(() {
          _file = _file;
          _path = _path;
        });
      }
    } on PlatformException catch (e) {
      print("Unsupported operation" + e.toString());
    }
    if (!mounted) return;

    setState(() {
      _fileName = _path != null
          ? _path.split('/').last
          : _paths != null ? _paths.keys.toString() : '...';
    });
  }

  Future<FileModel> createFile(
      String token, data, Function loadingChange) async {
    loadingChange();
    FileModel finaldata;
    var dio = new Dio();
    dio.options.headers[HttpHeaders.authorizationHeader] = "Token " + token;
    FormData formData = FormData.fromMap({
      "title": "${data['name']}.${data['type']}",
      "file": await MultipartFile.fromFile(data['filepath'],
          filename: data['filename']),
      'type': data['type'],
      'size': data['length'],
      "favourite": data['favourite'],
      "selected": true
    });
    await dio.post(
      "http://abhishekpraja.pythonanywhere.com/file/",
      data: formData,
      onSendProgress: (rec, total) {
        print("Rec: $rec , Total: $total");

        setState(() {
          downloading = true;
          totalprogressString = total;
          runningprogressString = rec;
          progressString = ((rec / total) * 100).toStringAsFixed(0) + "%";
        });
      },
    ).then((value) async {
      final item = value.data;
      finaldata = FileModel(
          id: item['id'],
          user: item['user'],
          title: item['title'],
          file: item['file'],
          type: item['type'],
          size: item['size'],
          selected: item['selected'],
          timestamp: item['timestamp'],
          favourite: item['favourite']);
    }).catchError((error) => print(error.response.toString()));
    loadingChange();
    setState(() {
      downloading = false;
      progressString = "Completed";
    });
    return finaldata;
  }

  loadingchange() {
    this.setState(() {
      loading = !loading;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: !downloading
          ? SingleChildScrollView(
              child: Container(
                //color: Colors.white,
                child: new Theme(
                  data: new ThemeData(
                    primaryColor: Colors.black,
                    primaryColorDark: Colors.black,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SingleChildScrollView(
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
                                    top: Radius.circular(10),
                                    bottom: Radius.circular(10)),
                              ),
                              child: Icon(
                                FontAwesomeIcons.solidFilePdf,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          TextField(
                            controller: fileNameText,
                            keyboardType: TextInputType.text,
                            cursorColor: Colors.white,
                            style: TextStyle(color: Colors.black),
                            decoration: new InputDecoration(
                              fillColor: Colors.white,
                              border: new OutlineInputBorder(
                                  borderSide:
                                      new BorderSide(color: Colors.white)),
                              hintText: 'file Name',
                              labelText: 'File ',
                            ),
                          ),
                          new Padding(
                            padding:
                                const EdgeInsets.only(top: 10.0, bottom: 20.0),
                            child: new RaisedButton.icon(
                              icon: Icon(FontAwesomeIcons.solidFilePdf),
                              color: Colors.white,
                              onPressed: () => _openFileExplorer(),
                              label: new Text(
                                "Select File",
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ),
                          Container(
                              child: _fileName != null
                                  ? Text(_fileName)
                                  : Container()),
                          Container(
                              child: _file != null
                                  ? Text(
                                      filesize(_file.lengthSync().toString()))
                                  : Container()),
                          SizedBox(
                            height: 20.0,
                          ),
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: SwitchListTile(
                              activeColor: Colors.red,
                              title: const Text('Favourite'),
                              value: _switchValue,
                              onChanged: (bool value) {
                                setState(() {
                                  _switchValue = value;
                                });
                              },
                              secondary: const Icon(
                                FontAwesomeIcons.heart,
                                color: Colors.red,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 60.0,
                          ),
                          RaisedButton.icon(
                            color: Colors.teal,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            icon: Icon(Icons.cloud_upload, color: Colors.white),
                            onPressed: !loading
                                ? () {
                                    createFile(
                                            widget.token,
                                            {
                                              'name': fileNameText.text,
                                              'file': _file,
                                              'length': _file.lengthSync(),
                                              'filepath': _file.path,
                                              'filename': _fileName,
                                              'favourite': _switchValue,
                                              'type': _fileName.split('.').last
                                            },
                                            loadingchange)
                                        .then((value) {
                                      widget.addCreatedFileData(value);
                                    });
                                  }
                                : null,
                            label: !loading
                                ? Text(
                                    'Upload',
                                    style: TextStyle(color: Colors.white),
                                  )
                                : CircularProgressIndicator(
                                    valueColor:
                                        AlwaysStoppedAnimation(Colors.white),
                                    backgroundColor: Colors.teal,
                                  ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )
          : Container(
              child: new Stack(
                children: <Widget>[
                  new Container(
                    alignment: AlignmentDirectional.center,
                    decoration: new BoxDecoration(
                      color: Colors.white70,
                    ),
                    child: new Container(
                      decoration: new BoxDecoration(
                          color: Colors.blue[200],
                          borderRadius: new BorderRadius.circular(10.0)),
                      width: 300.0,
                      height: 200.0,
                      alignment: AlignmentDirectional.center,
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          new Center(
                            child: new SizedBox(
                              height: 50.0,
                              width: 50.0,
                              child: new CircularProgressIndicator(
                                value: null,
                                strokeWidth: 7.0,
                              ),
                            ),
                          ),
                          new Container(
                            margin: const EdgeInsets.only(top: 25.0),
                            child: new Center(
                                child: Column(
                              children: [
                                new Text(
                                  'Uploaded:- $progressString',
                                  style: new TextStyle(color: Colors.white),
                                ),
                                new Text(
                                  filesize(runningprogressString)
                                          .toString()
                                          .toString() +
                                      ' / ' +
                                      filesize(totalprogressString).toString(),
                                  style: new TextStyle(color: Colors.white),
                                ),
                              ],
                            )),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
