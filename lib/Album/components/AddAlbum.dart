import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:filesize/filesize.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fproject/Album/components/api_response.dart';

class AddAlbum extends StatefulWidget {
  String token;
  Function addCreatedAlbumData;
  AddAlbum({Key key, this.token, this.addCreatedAlbumData}) : super(key: key);

  @override
  _AddAlbumState createState() => _AddAlbumState();
}

class _AddAlbumState extends State<AddAlbum> {
  TextEditingController albumName = new TextEditingController();
  bool loading = false;
  String _fileName = "";
  String _path;
  File _file;
  bool _switchValue = false;

  @override
  void initState() {
    super.initState();
  }

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
        body: SingleChildScrollView(
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
                        FontAwesomeIcons.images,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  TextField(
                    controller: albumName,
                    keyboardType: TextInputType.text,
                    cursorColor: Colors.white,
                    style: TextStyle(color: Colors.black),
                    decoration: new InputDecoration(
                      fillColor: Colors.white,
                      border: new OutlineInputBorder(
                          borderSide: new BorderSide(color: Colors.white)),
                      hintText: 'Album Name',
                      labelText: 'Album ',
                    ),
                  ),
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
                      child: _fileName != null ? Text(_fileName) : Container()),
                  Container(
                      child: _file != null
                          ? Text(filesize(_file.lengthSync().toString()))
                          : Container()),
                  SizedBox(
                    height: 20.0,
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: SwitchListTile(
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
                      icon: Icon(Icons.cloud_upload, color: Colors.white),
                      color: Colors.teal,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      onPressed: !loading
                          ? () {
                              print(albumName.text);
                              print(_file.path);
                              createAlbum(
                                      widget.token,
                                      {
                                        'name': albumName.text,
                                        'file': _file,
                                        'length': _file.lengthSync(),
                                        'filepath': _file.path,
                                        'filename': _fileName,
                                        'favourite': _switchValue
                                      },
                                      loadingchange)
                                  .then((value) {
                                widget.addCreatedAlbumData(value);
                              });
                            }
                          : null,
                      label: !loading
                          ? Text(
                              'Upload',
                              style: TextStyle(color: Colors.white),
                            )
                          : CircularProgressIndicator(
                              backgroundColor: Colors.white,
                              valueColor: AlwaysStoppedAnimation(Colors.teal),
                            )),
                ],
              ),
            ),
          ),
        ),
      ),
    ));
  }
}
