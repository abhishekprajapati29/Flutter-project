import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:filesize/filesize.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fproject/Album/components/api_response.dart';

class AddImages extends StatefulWidget {
  String token;
  int albumId;
  Function completeDeleteProcess;
  AddImages({Key key, this.albumId, this.token, this.completeDeleteProcess})
      : super(key: key);

  @override
  _AddImagesState createState() => _AddImagesState();
}

class _AddImagesState extends State<AddImages> {
  var progressString = "";
  int totalprogressString = 0;
  int runningprogressString = 0;
  TextEditingController albumName = new TextEditingController();
  bool imageLoading = false;
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

  @override
  void initState() {
    super.initState();
    _controller.addListener(() => _extension = _controller.text);
  }

  Future<int> uploadImages(token, albumid, data) async {
    var dio = new Dio();
    dio.options.headers[HttpHeaders.authorizationHeader] = "Token " + token;
    FormData formData = FormData.fromMap({
      "album_id": albumid,
      "src": await MultipartFile.fromFile(data['filepath'],
          filename: data['filename']),
      "size": data['length'],
      "selected": true,
      "caption": data['filename'],
      'thumbnail': await MultipartFile.fromFile(data['filepath'],
          filename: data['filename']),
    });
    await dio.post(
      "http://abhishekpraja.pythonanywhere.com/imagelist/",
      data: formData,
      onSendProgress: (count, total) {
        this.setState(() {
          totalprogressString = total;
          runningprogressString = count;
          progressString = ((count / total) * 100).toStringAsFixed(0) + "%";
        });
      },
    ).then((value) {
      var jsonData = value.data;
    }).catchError((error) => print(error.response.toString()));

    return albumid;
  }

  void _openFileExplorer() async {
    if (_pickingType != FileType.custom || _hasValidMime) {
      try {
        if (_multiPick) {
          _path = null;
          _files = await FilePicker.getMultiFile(type: _pickingType);
        } else {
          _paths = null;
          _file = await FilePicker.getFile(type: FileType.image);
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text('Add Images'),
      ),
      body: !imageLoading
          ? Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: Colors.grey,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    new Padding(
                      padding: const EdgeInsets.only(top: 10.0, bottom: 20.0),
                      child: new RaisedButton.icon(
                        icon: Icon(Icons.image),
                        color: Colors.white,
                        onPressed: () => _openFileExplorer(),
                        label: new Text(
                          "Selected Image for Album",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                                child: _fileName != null
                                    ? Text(_fileName)
                                    : Container()),
                            Container(
                                child: _file != null
                                    ? Text(_file.lengthSync().toString())
                                    : Container()),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                    ),
                    _file != null
                        ? new Padding(
                            padding:
                                const EdgeInsets.only(top: 10.0, bottom: 20.0),
                            child: new RaisedButton.icon(
                              icon: Icon(Icons.file_upload),
                              color: Colors.white,
                              onPressed: () {
                                this.setState(() {
                                  imageLoading = !imageLoading;
                                });
                                uploadImages(widget.token, widget.albumId, {
                                  'file': _file,
                                  'length': _file.lengthSync(),
                                  'filepath': _file.path,
                                  'filename': _fileName,
                                }).then((value) async {
                                  await widget
                                      .completeDeleteProcess(widget.albumId);
                                  this.setState(() {
                                    imageLoading = !imageLoading;
                                  });
                                  Navigator.pop(context);
                                });

                                //
                              },
                              label: new Text(
                                "Upload",
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          )
                        : Container(),
                  ],
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
                                  'Downloaded:- $progressString',
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
