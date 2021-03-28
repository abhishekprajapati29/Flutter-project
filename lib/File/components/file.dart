import 'dart:io';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fproject/Auth/login/fabeanimation.dart';
import 'package:fproject/gettoken.dart';
import 'package:dio/dio.dart';
import 'package:filesize/filesize.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
import 'api_response.dart';
import 'package:permission_handler/permission_handler.dart';
import 'model.dart';

class Files extends StatefulWidget {
  List<FileModel> data;
  List<FileModel> searchData;
  Function moveIndex;
  bool filter;
  bool search;
  Function updateAllData;
  Function updateDeleteAndData;
  bool loading;
  Files(
      {Key key,
      this.search,
      this.filter,
      this.data,
      this.searchData,
      this.loading,
      this.moveIndex,
      this.updateDeleteAndData,
      this.updateAllData})
      : super(key: key);

  @override
  _FilesState createState() => _FilesState();
}

class _FilesState extends State<Files> {
  FileModel moreOption;
  int dropdownValue = 0;
  int startSliceValue = 0;
  int endSliceValue = 0;
  bool loading = false;
  String filenamedownload = '';
  int sliceValue = 0;
  bool search = false;
  bool showPagination = false;
  bool downloading = false;
  var progressString = "";
  int totalprogressString = 0;
  int runningprogressString = 0;
  String location = '';

  Future<void> downloadFile(String imgUrl, String name) async {
    var dio = Dio();
    Future<Directory> path;

    try {
      if (await Permission.storage.request().isGranted) {
        await Permission.storage.request();
        Directory appDocDir = await getExternalStorageDirectory();
        await dio.download(imgUrl, "${appDocDir.path}/$name",
            onReceiveProgress: (rec, total) {
          print("Rec: $rec , Total: $total");

          setState(() {
            downloading = true;
            filenamedownload = name;
            totalprogressString = total;
            runningprogressString = rec;
            progressString = ((rec / total) * 100).toStringAsFixed(0) + "%";
          });
        });
        Fluttertoast.showToast(
            msg: "Downloaded",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            webShowClose: true,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } catch (e) {
      print(e);
    }

    setState(() {
      downloading = false;
      progressString = "Completed";
    });
    print("Download completed");
  }

  handleFileLocation() async {
    Directory appDocDir = await getExternalStorageDirectory();
    setState(() {
      location = appDocDir.path;
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      loading = true;
      //widget.searchText.text = "";
    });
    handleFileLocation();
    if (widget.data.length >= 5 && widget.data.length != 0) {
      setState(() {
        this.dropdownValue = 5;
        this.endSliceValue = 5;
      });
    } else {
      setState(() {
        this.dropdownValue = widget.data.length;
        this.endSliceValue = widget.data.length;
      });
    }
    setState(() {
      loading = false;
    });
  }

  void _updateLoading() {
    setState(() {
      this.widget.loading = !widget.loading;
    });
  }

  _showModalBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 170,
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Center(
                child: GridView.count(
                  crossAxisCount: 3,
                  children: [
                    IconButton(
                        icon: Icon(
                          FontAwesomeIcons.heart,
                          color: moreOption.favourite == true
                              ? Colors.red
                              : Colors.white,
                          size: 80,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          _handleMarkedFavourite(moreOption);
                        }),
                    IconButton(
                        icon: Icon(
                          Icons.file_download,
                          color: Colors.grey,
                          size: 80,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          downloadFile(moreOption.file, moreOption.title);
                        }),
                    IconButton(
                        icon: Icon(
                          Icons.delete,
                          color: Colors.black,
                          size: 80,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          _handleDelete(moreOption);
                        }),
                  ],
                ),
              ),
            ),
            decoration: BoxDecoration(
                color: Colors.teal[200],
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20))),
          );
        });
  }

  _showModalBottomSheet1(BuildContext context, item) {
    setState(() {
      this.moreOption = item;
    });
    _showModalBottomSheet(context);
  }

  _handleDelete(moreOption) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text("Delete Album"),
            content: Text("Are you sure?"),
            actions: [
              CupertinoDialogAction(
                child: Text('No'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              CupertinoDialogAction(
                child: Text('Yes'),
                onPressed: () async {
                  _updateLoading();
                  Navigator.pop(context);
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  String token = prefs.getString("token");
                  deleteFile(moreOption.id, token).then((_) {
                    widget.updateDeleteAndData(moreOption);
                    _updateLoading();
                  });
                },
              ),
            ],
          );
        });
  }

  void _incrementData() {
    if (endSliceValue + dropdownValue <= widget.data.length) {
      this.setState(() {
        this.startSliceValue = endSliceValue;
        this.endSliceValue = dropdownValue + endSliceValue;
      });
    }
  }

  void _decrementData() {
    if (startSliceValue - dropdownValue >= 0) {
      setState(() {
        this.endSliceValue = endSliceValue - dropdownValue;
        this.startSliceValue = startSliceValue - dropdownValue;
      });
    }
  }

  void _decrementEndData() {
    int data = widget.data.length;
    while (data % dropdownValue != 0) {
      this.setState(() {
        data = data - 1;
      });
    }
    final int minusData = widget.data.length - data;
    setState(() {
      this.startSliceValue = endSliceValue - dropdownValue - minusData;
      this.endSliceValue = endSliceValue - minusData;
    });
  }

  void _incrementDateToItsEnd() {
    setState(() {
      this.startSliceValue = endSliceValue;
      this.endSliceValue = widget.data.length;
    });
  }

  _handleMarkedFavourite(item) {
    print('start0');
    print(item.id);
    print(moreOption.id);
    print('end');
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: !moreOption.favourite
                ? Text("Mark as Favourite")
                : Text("Mark as UnFavourite"),
            content: Text("Are you sure?"),
            actions: [
              CupertinoDialogAction(
                child: Text('No'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              CupertinoDialogAction(
                child: Text('Yes'),
                onPressed: () async {
                  _updateLoading();
                  Navigator.pop(context);
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  String token = prefs.getString("token");
                  markedFavourite(item.id, item.favourite, token).then((value) {
                    widget.updateAllData(value);
                    _updateLoading();
                    widget.moveIndex(2);
                  });
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return !loading
        ? Scaffold(
            body: widget.data.length > 0
                ? Stack(children: [
                    Container(
                      height: MediaQuery.of(context).size.height,
                      padding: EdgeInsets.only(bottom: 15.0),
                      child: Column(
                        children: [
                          Expanded(
                              child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height,
                            child: _buildPanel(),
                          )),
                          !widget.filter && !widget.search
                              ? widget.data.length >= 5
                                  ? showPagination
                                      ? FadeAnimation(
                                          0.5,
                                          Dismissible(
                                            key: Key('file'),
                                            onDismissed: (direction) {
                                              // Remove the item from the data source.
                                              setState(() {
                                                showPagination =
                                                    !showPagination;
                                              });
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 4.0,
                                                  right: 4.0,
                                                  top: 3.0),
                                              child: Container(
                                                alignment:
                                                    Alignment.bottomCenter,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                    color: Colors.teal),
                                                child: Row(
                                                  children: [
                                                    IconButton(
                                                        icon: Icon(Icons
                                                            .navigate_before),
                                                        onPressed: startSliceValue !=
                                                                    0 &&
                                                                endSliceValue !=
                                                                    dropdownValue
                                                            ? dropdownValue !=
                                                                    widget.data
                                                                        .length
                                                                ? endSliceValue !=
                                                                        widget
                                                                            .data
                                                                            .length
                                                                    ? () {
                                                                        _decrementData();
                                                                      }
                                                                    : () {
                                                                        _decrementEndData();
                                                                      }
                                                                : null
                                                            : null),
                                                    Spacer(),
                                                    Text('Rows : '),
                                                    widget.data.length > 0
                                                        ? DropdownButton<int>(
                                                            value:
                                                                dropdownValue,
                                                            icon: Icon(Icons
                                                                .arrow_downward),
                                                            iconSize: 24,
                                                            elevation: 16,
                                                            dropdownColor:
                                                                Colors.white,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black),
                                                            underline:
                                                                Container(
                                                              height: 2,
                                                              color: Colors
                                                                  .transparent,
                                                            ),
                                                            onChanged:
                                                                (int newValue) {
                                                              if (newValue <=
                                                                  widget.data
                                                                      .length) {
                                                                setState(() {
                                                                  dropdownValue =
                                                                      newValue;
                                                                  startSliceValue =
                                                                      0;
                                                                  endSliceValue =
                                                                      newValue;
                                                                });
                                                              }
                                                            },
                                                            items: widget.data.length > 0 &&
                                                                    widget.data.length !=
                                                                        5 &&
                                                                    widget.data.length !=
                                                                        10 &&
                                                                    widget.data.length !=
                                                                        15
                                                                ? <int>[
                                                                    5,
                                                                    10,
                                                                    15,
                                                                    widget.data
                                                                        .length
                                                                  ].map<DropdownMenuItem<int>>((int
                                                                    value) {
                                                                    return DropdownMenuItem<
                                                                        int>(
                                                                      value:
                                                                          value,
                                                                      child: Text(
                                                                          value
                                                                              .toString()),
                                                                    );
                                                                  }).toList()
                                                                : <int>[
                                                                    5,
                                                                    10,
                                                                    15
                                                                  ].map<DropdownMenuItem<int>>((int value) {
                                                                    return DropdownMenuItem<
                                                                        int>(
                                                                      value:
                                                                          value,
                                                                      child: Text(
                                                                          value
                                                                              .toString()),
                                                                    );
                                                                  }).toList(),
                                                          )
                                                        : Container(),
                                                    Text(' ( '),
                                                    Text(startSliceValue
                                                        .toString()),
                                                    Text(' to '),
                                                    Text(endSliceValue
                                                        .toString()),
                                                    Text(' out of '),
                                                    Text(widget.data.length
                                                        .toString()),
                                                    Text(' ) '),
                                                    Spacer(),
                                                    IconButton(
                                                        icon: Icon(Icons
                                                            .navigate_next),
                                                        onPressed: endSliceValue !=
                                                                widget
                                                                    .data.length
                                                            ? dropdownValue !=
                                                                    widget.data
                                                                        .length
                                                                ? endSliceValue +
                                                                            dropdownValue <=
                                                                        widget
                                                                            .data
                                                                            .length
                                                                    ? () {
                                                                        _incrementData();
                                                                        print(
                                                                            'da');
                                                                      }
                                                                    : () {
                                                                        _incrementDateToItsEnd();
                                                                        print(
                                                                            'da');
                                                                      }
                                                                : null
                                                            : null),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      : Container()
                                  : Container()
                              : Container()
                        ],
                      ),
                    ),
                    !widget.filter && !widget.search
                        ? !showPagination
                            ? widget.data.length >= 5
                                ? Positioned(
                                    child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            showPagination = !showPagination;
                                          });
                                        },
                                        child: Icon(
                                          FontAwesomeIcons.chevronCircleLeft,
                                          color: Colors.teal,
                                          size: 50,
                                        )),
                                    right: -20,
                                    top: MediaQuery.of(context).size.height *
                                        0.725,
                                  )
                                : Container()
                            : Container()
                        : Container()
                  ])
                : Center(
                    child: Text('No Documents'),
                  ),
          )
        : Container(
            height: MediaQuery.of(context).size.height,
            child: Center(
              child: SpinKitFoldingCube(color: Colors.teal),
            ),
          );
  }

  Widget _buildPanel() {
    return !downloading
        ? !widget.filter && !widget.search
            ? ListView.builder(
                itemCount: widget.data.length,
                itemBuilder: (context, index) {
                  return index + startSliceValue < endSliceValue
                      ? Container(
                          height: 80,
                          width: double.maxFinite,
                          child: Card(
                            color: Colors.white,
                            elevation: 5,
                            child: ListTile(
                              title: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Text(
                                    widget.data[index + startSliceValue].title
                                        .capitalize(),
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                              ),
                              subtitle: Text(DateFormat('yyyy/MM/dd').format(
                                  DateTime.parse(widget
                                      .data[index + startSliceValue]
                                      .timestamp))),
                              trailing: IconButton(
                                  icon: Icon(Icons.more_vert),
                                  onPressed: () {
                                    _showModalBottomSheet1(context,
                                        widget.data[index + startSliceValue]);
                                  }),
                            ),
                          ),
                        )
                      : null;
                })
            : ListView.builder(
                itemCount: widget.data.length,
                itemBuilder: (context, index) {
                  return Container(
                    height: 80,
                    width: double.maxFinite,
                    child: Card(
                      color: Colors.white,
                      elevation: 5,
                      child: ListTile(
                        title: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Text(widget.data[index].title.capitalize(),
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        subtitle: Text(DateFormat('yyyy/MM/dd').format(
                            DateTime.parse(widget.data[index].timestamp))),
                        trailing: IconButton(
                            icon: Icon(Icons.more_vert),
                            onPressed: () {
                              _showModalBottomSheet1(
                                  context, widget.data[index]);
                            }),
                      ),
                    ),
                  );
                })
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
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                child: new Text(
                                    'File:- $location $filenamedownload',
                                    style: new TextStyle(color: Colors.white)),
                              ),
                              SizedBox(
                                height: 10,
                              ),
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
          );
  }

  void _handleEdit(item) {
    //widget.editDataFunction(item);
    // widget.selectedIndex(1, 0);
  }
}
