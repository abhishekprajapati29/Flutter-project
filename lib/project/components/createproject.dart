import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:filesize/filesize.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fproject/gettoken.dart';
import 'package:html_editor/html_editor.dart';
import 'package:intl/intl.dart';

import 'api_response.dart';

enum SingingCharacter { Team, Private }

class CreateProject extends StatefulWidget {
  Function handleProject;
  CreateProject({Key key, this.handleProject}) : super(key: key);

  @override
  _CreateProjectState createState() => _CreateProjectState();
}

class _CreateProjectState extends State<CreateProject> {
  DateTime startDate;
  DateTime endDate;
  List<String> tags = [];
  TextEditingController projectName = new TextEditingController();
  TextEditingController applicationName = new TextEditingController();
  TextEditingController tag = new TextEditingController();
  TextEditingController storage = new TextEditingController();
  int tab = 0;
  GlobalKey<HtmlEditorState> keyEditor = GlobalKey();
  String result = "";
  String size = 'KB';
  SingingCharacter choice = SingingCharacter.Team;
  bool loading = false;
  String _fileName = "";
  String _path;
  File _file;
  bool showContent = false;
  bool loadingcreate = false;

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
        title: tab == 0
            ? Text(
                'Create Project',
                textAlign: TextAlign.center,
              )
            : tab == 1
                ? Text(
                    'Upload File',
                    textAlign: TextAlign.center,
                  )
                : tab == 2
                    ? Text(
                        'Description',
                        textAlign: TextAlign.center,
                      )
                    : tab == 3
                        ? Text(
                            'Storage & Preference',
                            textAlign: TextAlign.center,
                          )
                        : null,
        backgroundColor: Colors.teal,
        actions: tab == 2
            ? !showContent
                ? [
                    IconButton(
                      icon: Icon(Icons.check),
                      onPressed: () async {
                        final txt = await keyEditor.currentState.getText();
                        setState(() {
                          result = txt;
                          showContent = !showContent;
                        });
                      },
                    )
                  ]
                : [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () async {
                        setState(() {
                          showContent = !showContent;
                        });
                      },
                    )
                  ]
            : [],
      ),
      backgroundColor: Colors.grey[200],
      body: !loadingcreate
          ? tab == 0
              ? Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 15.0,
                          ),
                          TextField(
                            controller: projectName,
                            keyboardType: TextInputType.text,
                            cursorColor: Colors.black,
                            style: TextStyle(color: Colors.black),
                            decoration: new InputDecoration(
                              border: new OutlineInputBorder(
                                  borderSide:
                                      new BorderSide(color: Colors.black)),
                              labelText: 'Project Name',
                            ),
                          ),
                          SizedBox(
                            height: 15.0,
                          ),
                          TextField(
                            controller: applicationName,
                            keyboardType: TextInputType.text,
                            cursorColor: Colors.black,
                            style: TextStyle(color: Colors.black),
                            decoration: new InputDecoration(
                              border: new OutlineInputBorder(
                                  borderSide:
                                      new BorderSide(color: Colors.black)),
                              labelText: 'Application Name',
                            ),
                          ),
                          SizedBox(
                            height: 15.0,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: tag,
                                  decoration: new InputDecoration(
                                    border: new OutlineInputBorder(
                                        borderSide: new BorderSide(
                                            color: Colors.black)),
                                    labelText: 'Add Tags',
                                  ),
                                  textCapitalization:
                                      TextCapitalization.sentences,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Colors.teal,
                                  ),
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.add,
                                      color: Colors.white,
                                    ),
                                    iconSize: 25,
                                    color: Theme.of(context).primaryColor,
                                    onPressed: () {
                                      setState(() {
                                        tags = [...tags, tag.text];
                                        tag.text = '';
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 15.0,
                          ),
                          Text(
                            'Tags',
                            style: TextStyle(fontSize: 18),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          tags.length > 0
                              ? SingleChildScrollView(
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Container(
                                        child: Wrap(
                                      spacing: 5.0,
                                      runSpacing: 3.0,
                                      children: tags
                                          .map(
                                            (title) => FilterChip(
                                              label: Text(title),
                                              labelStyle: TextStyle(
                                                  color: Color(0xff6200ee),
                                                  fontSize: 16.0,
                                                  fontWeight: FontWeight.bold),
                                              selected: true,
                                              onSelected: (value) {},
                                              backgroundColor:
                                                  Color(0xffededed),
                                              selectedColor: Color(0xffeadffd),
                                            ),
                                          )
                                          .toList(),
                                    )),
                                  ),
                                )
                              : Container(
                                  width: MediaQuery.of(context).size.width,
                                  child: Center(
                                      child: Text(
                                    'No Tags Added',
                                    style: TextStyle(color: Colors.blue),
                                  ))),
                          SizedBox(
                            height: 15.0,
                          ),
                          Row(
                            children: [
                              Text(
                                'Start Date',
                                style: TextStyle(fontSize: 25),
                              ),
                              Spacer(),
                              Text(
                                startDate == null
                                    ? DateFormat('yyyy/MM/dd').format(
                                        DateTime.parse(
                                            DateTime.now().toString()))
                                    : DateFormat('yyyy/MM/dd').format(
                                        DateTime.parse(startDate.toString())),
                                style: TextStyle(fontSize: 20),
                              ),
                              IconButton(
                                  icon: Icon(
                                    Icons.edit,
                                    color: Colors.teal,
                                  ),
                                  onPressed: () {
                                    showDatePicker(
                                            context: context,
                                            initialDate: startDate == null
                                                ? DateTime.now()
                                                : startDate,
                                            firstDate: DateTime(2010),
                                            lastDate: DateTime(2021))
                                        .then((date) {
                                      setState(() {
                                        startDate = date;
                                      });
                                    });
                                  }),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                'End Date',
                                style: TextStyle(fontSize: 25),
                              ),
                              Spacer(),
                              Text(
                                endDate == null
                                    ? DateFormat('yyyy/MM/dd').format(
                                        DateTime.parse(
                                            DateTime.now().toString()))
                                    : DateFormat('yyyy/MM/dd').format(
                                        DateTime.parse(endDate.toString())),
                                style: TextStyle(fontSize: 20),
                              ),
                              IconButton(
                                  icon: Icon(
                                    Icons.edit,
                                    color: Colors.teal,
                                  ),
                                  onPressed: () {
                                    showDatePicker(
                                            context: context,
                                            initialDate: endDate == null
                                                ? DateTime.now()
                                                : endDate,
                                            firstDate: DateTime(2010),
                                            lastDate: DateTime(2021))
                                        .then((date) {
                                      setState(() {
                                        endDate = date;
                                      });
                                    });
                                  }),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : tab == 1
                  ? Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.35,
                          ),
                          RaisedButton.icon(
                            icon: Icon(
                              Icons.cloud_upload,
                              color: Colors.white,
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            color: Colors.teal,
                            onPressed: () {
                              _openFileExplorer();
                            },
                            label: Text(
                              'Upload',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          SizedBox(
                            height: 20,
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
                        ],
                      ),
                    )
                  : tab == 2
                      ? Container(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  !showContent
                                      ? HtmlEditor(
                                          hint: "Your text here...",
                                          key: keyEditor,
                                          height: MediaQuery.of(context)
                                              .size
                                              .height,
                                        )
                                      : Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: SingleChildScrollView(
                                            child: Html(data: result),
                                          ),
                                        )
                                ],
                              ),
                            ),
                          ),
                        )
                      : tab == 3
                          ? Container(
                              height: MediaQuery.of(context).size.height,
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Text('Assign Project Storage',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold)),
                                  Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: TextField(
                                            controller: storage,
                                            keyboardType: TextInputType.number,
                                            decoration: new InputDecoration(
                                              labelText: 'Size',
                                            ),
                                            inputFormatters: <
                                                TextInputFormatter>[
                                              FilteringTextInputFormatter
                                                  .digitsOnly
                                            ],
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Column(
                                          children: [
                                            SizedBox(
                                              height: 30,
                                            ),
                                            DropdownButton<String>(
                                              value: size,
                                              icon: Icon(Icons.arrow_downward),
                                              iconSize: 24,
                                              elevation: 16,
                                              style: TextStyle(
                                                  color: Colors.deepPurple),
                                              underline: Container(
                                                height: 5,
                                                color: Colors.deepPurpleAccent,
                                              ),
                                              onChanged: (String newValue) {
                                                setState(() {
                                                  size = newValue;
                                                });
                                              },
                                              items: <String>[
                                                'KB',
                                                'MB',
                                                'GB',
                                              ].map<DropdownMenuItem<String>>(
                                                  (String value) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Text(value),
                                                );
                                              }).toList(),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Text('Project Preference',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold)),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Container(
                                    child: Column(
                                      children: [
                                        ListTile(
                                          title: const Text('Team'),
                                          leading: Radio(
                                            value: SingingCharacter.Team,
                                            groupValue: choice,
                                            onChanged:
                                                (SingingCharacter value) {
                                              setState(() {
                                                choice = value;
                                              });
                                            },
                                          ),
                                        ),
                                        ListTile(
                                          title: const Text('Private'),
                                          leading: Radio(
                                            value: SingingCharacter.Private,
                                            groupValue: choice,
                                            onChanged:
                                                (SingingCharacter value) {
                                              setState(() {
                                                choice = value;
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Container()
          : Center(child: SpinKitFoldingCube(color: Colors.teal)),
      bottomNavigationBar: Container(
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Spacer(),
              Padding(
                padding: const EdgeInsets.only(right: 7),
                child: tab != 0
                    ? OutlineButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        color: Colors.teal,
                        borderSide: BorderSide(
                            color: Colors.teal, style: BorderStyle.solid),
                        onPressed: () {
                          if (tab != 0) {
                            setState(() {
                              tab = tab - 1;
                            });
                          }
                        },
                        child: Text(
                          'back',
                          style: TextStyle(color: Colors.teal),
                        ),
                      )
                    : null,
              ),
              tab != 3
                  ? RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      color: Colors.teal,
                      onPressed: () {
                        if (tab <= 2) {
                          setState(() {
                            tab = tab + 1;
                          });
                        }
                      },
                      child: Text(
                        'next',
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  : RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      color: Colors.teal,
                      onPressed: () async {
                        setState(() {
                          loadingcreate = true;
                        });
                        getTokenPreferences().then((token) async {
                          await createProject(token, {
                            'projectName': projectName.text,
                            'application': applicationName.text,
                            'tags': tags,
                            'startDate':
                                DateFormat('yyyy-MM-dd').format(startDate),
                            'endDate': DateFormat('yyyy-MM-dd').format(endDate),
                            'filename': _fileName,
                            'filepath': _file.path,
                            'filelength':
                                _file != null ? _file.lengthSync() : null,
                            'description': result,
                            'storage': size == 'KB'
                                ? int.parse(storage.text) * 1024
                                : size == 'MB'
                                    ? int.parse(storage.text) * 1024 * 1024
                                    : int.parse(storage.text) *
                                        1024 *
                                        1024 *
                                        1024,
                            'preferences': choice.toString().split('.').last
                          }).then((value) {
                            print(value.id);
                            setState(() {
                              loadingcreate = false;
                            });
                            widget.handleProject(value);
                          });
                        });
                        print('submit');
                        print(projectName.text);
                        print(applicationName.text);
                        for (var item in tags) {
                          print(item);
                        }
                        print(startDate);
                        print(endDate);
                        print(result);
                        print(_fileName);
                        if (size == 'KB') {
                          print(int.parse(storage.text) * 1024);
                        } else if (size == 'MB') {
                          print(int.parse(storage.text) * 1024 * 1024);
                        } else {
                          print(int.parse(storage.text) * 1024 * 1024 * 1024);
                        }
                        print(choice.toString().split('.').last);
                      },
                      child: Text(
                        'Submit',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
