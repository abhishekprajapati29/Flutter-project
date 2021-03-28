import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:filesize/filesize.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'model.dart';

class AddVideo extends StatefulWidget {
  String token;
  Function addCreatedVideoData;
  AddVideo({Key key, this.token, this.addCreatedVideoData}) : super(key: key);

  @override
  _AddVideoState createState() => _AddVideoState();
}

class _AddVideoState extends State<AddVideo> {
  TextEditingController videoNameText = new TextEditingController();
  bool loading = false;
  String _videoName = "";
  String _path;
  File _video;
  Map<String, String> _paths;
  List<File> _videos;
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
        _videos = null;
      } else {
        _paths = null;
        _video = await FilePicker.getFile(type: FileType.video);
        _path = _video.path;
        setState(() {
          _video = _video;
          _path = _path;
        });
      }
    } on PlatformException catch (e) {
      print("Unsupported operation" + e.toString());
    }
    if (!mounted) return;

    setState(() {
      _videoName = _path != null
          ? _path.split('/').last
          : _paths != null ? _paths.keys.toString() : '...';
    });
  }

  Future<VideoModel> createVideo(
      String token, data, Function loadingChange) async {
    loadingChange();
    VideoModel finaldata;
    var dio = new Dio();
    print("${data['name']}.${data['type']}");
    dio.options.headers[HttpHeaders.authorizationHeader] = "Token " + token;
    FormData formData = FormData.fromMap({
      "title": "${data['name']}.${data['type']}",
      "Video": await MultipartFile.fromFile(data['videopath'],
          filename: data['videoname']),
      'type': data['type'],
      'size': data['length'],
      "favourite": data['favourite'],
      "selected": true
    });
    await dio.post(
      "http://abhishekpraja.pythonanywhere.com/video/",
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
      print(item);
      print(item['title']);
      finaldata = VideoModel(
          id: item['id'],
          user: item['user'],
          title: item['title'],
          video: item['Video'],
          type: item['type'],
          size: item['size'],
          selected: item['selected'],
          timestamp: item['timestamp'],
          favourite: item['favourite']);
    }).catchError((error) => print(error));
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
                              child: Icon(FontAwesomeIcons.video,
                                  color: Colors.white),
                            ),
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          TextField(
                            controller: videoNameText,
                            keyboardType: TextInputType.text,
                            cursorColor: Colors.white,
                            style: TextStyle(color: Colors.black),
                            decoration: new InputDecoration(
                              fillColor: Colors.white,
                              border: new OutlineInputBorder(
                                  borderSide:
                                      new BorderSide(color: Colors.white)),
                              hintText: 'Video Name',
                              labelText: 'Video ',
                            ),
                          ),
                          new Padding(
                            padding:
                                const EdgeInsets.only(top: 10.0, bottom: 20.0),
                            child: new RaisedButton.icon(
                              icon: Icon(FontAwesomeIcons.video),
                              color: Colors.white,
                              onPressed: () => _openFileExplorer(),
                              label: new Text(
                                "Select Video",
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ),
                          Container(
                              child: _videoName != null
                                  ? Text(_videoName)
                                  : Container()),
                          Container(
                              child: _video != null
                                  ? Text(
                                      filesize(_video.lengthSync().toString()))
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
                            icon: Icon(
                              Icons.cloud_upload,
                              color: Colors.white,
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            color: Colors.teal,
                            onPressed: !loading
                                ? () {
                                    createVideo(
                                            widget.token,
                                            {
                                              'name': videoNameText.text,
                                              'video': _video,
                                              'length': _video.lengthSync(),
                                              'videopath': _video.path,
                                              'videoname': _videoName,
                                              'favourite': _switchValue,
                                              'type': _videoName.split('.').last
                                            },
                                            loadingchange)
                                        .then((value) {
                                      print(value.title);
                                      widget.addCreatedVideoData(value);
                                    });
                                  }
                                : null,
                            label: !loading
                                ? Text('Upload',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ))
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
                                  'Upload:- $progressString',
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
