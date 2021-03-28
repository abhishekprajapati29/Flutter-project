import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fproject/Album/components/model.dart';
import 'package:photo_view/photo_view.dart';

import 'api_response.dart';
import 'model.dart' as model;

class ProfileView extends StatefulWidget {
  model.UserModel data;
  List<model.InoviceModel> invoiceData1;
  Function updateInvoice1;
  Function updateInvoice12;
  Function updateInvoice2;
  String token;
  Function updateInvoice;
  List<model.InoviceModel> invoiceData;
  model.UserModel profileData;
  model.UserModel currentUserData;
  Function updateCurrentUser;
  List<model.UserModel> allUsersData;
  ProfileView(
      {Key key,
      this.data,
      this.updateInvoice2,
      this.invoiceData,
      this.token,
      this.updateInvoice1,
      this.updateInvoice,
      this.allUsersData,
      this.invoiceData1,
      this.currentUserData,
      this.profileData,
      this.updateCurrentUser})
      : super(key: key);

  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  var progressString = "";
  var userImages = <Imagelist>[];
  int totalprogressString = 0;
  int runningprogressString = 0;
  bool loading = false;
  String _fileName = "";
  String _path;
  File _file;
  Map<String, String> _paths;
  List<File> _files;
  bool _hasValidMime = false;
  FileType _pickingType;
  bool loadingImagesAll = false;
  int allCount = 0;
  bool invoiceLoading = false;
  bool exists = false;

  Future<model.UserModel> updateImage(String token, int id, data) async {
    model.UserModel finaldata;
    var dio = new Dio();
    dio.options.headers["Content-Type"] = "multipart/form-data";
    dio.options.headers[HttpHeaders.authorizationHeader] = "Token " + token;
    FormData formData = FormData.fromMap({
      "background_image": await MultipartFile.fromFile(data['filepath'],
          filename: data['filename']),
    });
    await dio.patch(
      "http://abhishekpraja.pythonanywhere.com/userprofile/${widget.currentUserData.profile.id}/",
      data: formData,
      onSendProgress: (count, total) {
        this.setState(() {
          totalprogressString = total;
          runningprogressString = count;
          progressString = ((count / total) * 100).toStringAsFixed(0) + "%";
        });
      },
    ).then((value) async {
      await getCurrentUser(widget.token).then((value1) {
        widget.updateCurrentUser(value1);
      });
    }).catchError((error) => print(error.response.toString()));
    return finaldata;
  }

  Future<model.UserModel> updateProfileImage(String token, int id, data) async {
    model.UserModel finaldata;
    var dio = new Dio();
    dio.options.headers["Content-Type"] = "multipart/form-data";
    dio.options.headers[HttpHeaders.authorizationHeader] = "Token " + token;
    FormData formData = FormData.fromMap({
      "image": await MultipartFile.fromFile(data['filepath'],
          filename: data['filename']),
    });
    await dio.patch(
      "http://abhishekpraja.pythonanywhere.com/userprofile_image/${widget.currentUserData.image.id}/",
      data: formData,
      onSendProgress: (count, total) {
        this.setState(() {
          totalprogressString = total;
          runningprogressString = count;
          progressString = ((count / total) * 100).toStringAsFixed(0) + "%";
        });
      },
    ).then((value) async {
      await getCurrentUser(widget.token).then((value1) {
        widget.updateCurrentUser(value1);
      });
    }).catchError((error) => print(error.response.toString()));
    return finaldata;
  }

  _updateBackgroundImage() async {
    try {
      _file = await FilePicker.getFile(type: FileType.image);
      _path = _file.path;
      setState(() {
        _file = _file;
        _path = _path;
      });
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

  loadingchange() {
    this.setState(() {
      loading = !loading;
    });
  }

  checkExists(invoiceData, profileData, currentUserData) {
    final data = invoiceData
        .where((element) =>
            element.user == profileData.id &&
            element.requestedBy == currentUserData.id)
        .toList()
        .length;
    if (data > 0) {
      this.setState(() {
        exists = true;
      });
    } else {
      this.setState(() {
        exists = false;
      });
    }
  }

  checkExists1(invoiceData1, profileData, currentUserData) {
    final data = invoiceData1
        .where((element) => element.user == profileData.id)
        .toList()
        .length;
    if (data > 0) {
      this.setState(() {
        exists = true;
      });
    } else {
      this.setState(() {
        exists = false;
      });
    }
  }

  updateInvoice(model.InoviceModel data) {
    this.setState(() {
      invoiceData1 = [...invoiceData1, data];
    });
  }

  List<model.InoviceModel> invoiceData1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.setState(() {
      loadingImagesAll = true;
    });
    print('id = ${widget.profileData.id}');
    if (widget.currentUserData.profile.teamName == 'default_team_name') {
      checkExists1(
          widget.invoiceData1, widget.profileData, widget.currentUserData);
    } else {
      checkExists(
          widget.invoiceData, widget.profileData, widget.currentUserData);
    }

    this.setState(() {
      allCount = widget.allUsersData
          .where((element) =>
              element.profile.teamName == widget.profileData.profile.teamName)
          .toList()
          .length;
    });
    if (widget.currentUserData.username == widget.profileData.username) {
      getUserImages(widget.token).then((value) {
        this.setState(() {
          userImages = value;
          loadingImagesAll = false;
        });
      });
    } else {
      getUserImages1(widget.token, widget.profileData.username).then((value) {
        this.setState(() {
          userImages = value;
          loadingImagesAll = false;
        });
      });
    }
  }

  _handleAlert(invoiceData, profileData, currentUserData) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text("Send Invite To ${widget.profileData.username}"),
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
                  Navigator.pop(context);
                  this.setState(() {
                    invoiceLoading = true;
                  });
                  await addMemberInvoice(profileData, currentUserData)
                      .then((value) async {
                    await widget.updateInvoice(value);
                    await widget.updateInvoice1(value);
                    await checkExists(widget.invoiceData, widget.profileData,
                        widget.currentUserData);
                    this.setState(() {
                      exists = true;
                    });
                  });
                  this.setState(() {
                    invoiceLoading = false;
                  });
                },
              ),
            ],
          );
        });
  }

  _handleAlert1(invoiceData, profileData, currentUserData) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text("Send Request To ${widget.profileData.username}"),
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
                  Navigator.pop(context);
                  this.setState(() {
                    invoiceLoading = true;
                  });
                  print(profileData.username);
                  print(currentUserData.username);
                  await addMemberInvoice1(profileData, currentUserData)
                      .then((value) async {
                    await widget.updateInvoice2(value);
                    this.setState(() {
                      exists = true;
                    });
                    invoiceLoading = false;
                  });
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                      height: MediaQuery.of(context).size.height * 0.3,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          image: DecorationImage(
                            image: NetworkImage(
                                widget.profileData.profile.backgroundImage),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20)))),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.3,
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(15, 30, 0, 0),
                      child: Container(
                          alignment: Alignment.topLeft,
                          child: ClipOval(
                            child: Material(
                              color: Colors.blueGrey, // button color
                              child: InkWell(
                                splashColor: Colors.blue, // inkwell color
                                child: SizedBox(
                                    width: 40,
                                    height: 40,
                                    child: Icon(
                                      Icons.arrow_back,
                                      color: Colors.white,
                                    )),
                                onTap: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                          )),
                    ),
                  ),
                  widget.currentUserData.username == widget.profileData.username
                      ? Container(
                          height: MediaQuery.of(context).size.height * 0.3,
                          width: MediaQuery.of(context).size.width,
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Container(
                                alignment: Alignment.bottomRight,
                                child: ClipOval(
                                  child: Material(
                                    color: Colors.white, // button color
                                    child: InkWell(
                                      splashColor: Colors.blue, // inkwell color
                                      child: SizedBox(
                                          width: 40,
                                          height: 40,
                                          child: Icon(Icons.edit)),
                                      onTap: () async {
                                        await _updateBackgroundImage();
                                        updateImage(widget.token,
                                            widget.profileData.profile.id, {
                                          'filepath': _file.path,
                                          'filename': _fileName,
                                        });
                                      },
                                    ),
                                  ),
                                )),
                          ),
                        )
                      : Container(),
                  Center(
                    child: Container(
                      margin: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.2),
                      width: 150,
                      height: 150,
                      child: Material(
                        elevation: 4.0,
                        shape: CircleBorder(),
                        clipBehavior: Clip.hardEdge,
                        color: Colors.transparent,
                        child: Ink.image(
                          image: NetworkImage(widget.profileData.image.image),
                          fit: BoxFit.cover,
                          width: 120.0,
                          height: 120.0,
                          child: InkWell(
                            onTap: () async {
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) {
                                  return ProfileImageView(
                                      data: widget.profileData,
                                      token: widget.token,
                                      updateCurrentUser:
                                          widget.updateCurrentUser,
                                      currentUserData: widget.currentUserData,
                                      allCount: allCount);
                                },
                              ));
                            },
                          ),
                        ),
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        border: Border.all(width: 5, color: Colors.white70),
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                  )
                ],
              ),
              Container(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Text(
                        widget.profileData.username,
                        style: TextStyle(
                            fontSize: 26, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Text(
                        widget.profileData.profile.aboutMe,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.normal),
                      ),
                    ),
                    widget.profileData.profile.teamName != 'default_team_name'
                        ? Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Row(
                              children: [
                                Spacer(),
                                Column(
                                  children: [
                                    FlatButton.icon(
                                        onPressed: () {},
                                        icon: Icon(FontAwesomeIcons.users),
                                        label: Text('Team')),
                                    Text(widget.profileData.profile.teamName
                                        .toUpperCase())
                                  ],
                                ),
                                Spacer(),
                                Column(
                                  children: [
                                    FlatButton.icon(
                                        onPressed: () {},
                                        icon: Icon(FontAwesomeIcons.users),
                                        label: Text('Members')),
                                    Text(allCount.toString())
                                  ],
                                ),
                                Spacer(),
                              ],
                            ))
                        : !exists
                            ? Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Row(
                                  children: [
                                    Spacer(),
                                    RaisedButton.icon(
                                      color: Colors.grey,
                                      onPressed: !invoiceLoading
                                          ? () async {
                                              _handleAlert(
                                                  widget.invoiceData,
                                                  widget.profileData,
                                                  widget.currentUserData);
                                            }
                                          : null,
                                      icon: Icon(FontAwesomeIcons.userAlt),
                                      label: !invoiceLoading
                                          ? Text(
                                              'Add User',
                                              style: TextStyle(
                                                fontSize: 20,
                                              ),
                                            )
                                          : CircularProgressIndicator(
                                              valueColor:
                                                  AlwaysStoppedAnimation(
                                                      Colors.white),
                                              backgroundColor: Colors.teal),
                                    ),
                                    Spacer(),
                                  ],
                                ))
                            : Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Row(
                                  children: [
                                    Spacer(),
                                    FlatButton.icon(
                                      color: Colors.grey,
                                      onPressed: null,
                                      icon: Icon(FontAwesomeIcons.userAlt),
                                      label: Text(
                                        'Requested',
                                        style: TextStyle(
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                    Spacer(),
                                  ],
                                )),
                    !loadingImagesAll
                        ? Container(
                            height: MediaQuery.of(context).size.height * 0.8,
                            child: StaggeredGridView.countBuilder(
                              crossAxisCount: 4,
                              itemCount: userImages.length,
                              itemBuilder: (BuildContext context, int index) =>
                                  GestureDetector(
                                onTap: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return ImageViewAll(
                                      data: userImages[index],
                                    );
                                  }));
                                },
                                child: new Container(
                                    decoration: new BoxDecoration(
                                        image: new DecorationImage(
                                            image: new NetworkImage(
                                                userImages[index].src),
                                            fit: BoxFit.cover))),
                              ),
                              staggeredTileBuilder: (int index) =>
                                  new StaggeredTile.count(
                                      2, index.isEven ? 2 : 1),
                              mainAxisSpacing: 4.0,
                              crossAxisSpacing: 4.0,
                            ),
                          )
                        : SpinKitFoldingCube(color: Colors.teal)
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: widget.currentUserData.profile.teamName ==
              'default_team_name'
          ? BottomAppBar(
              elevation: 5,
              color: Colors.teal,
              child: Container(
                height: 50,
                child: Row(
                  children: [
                    Spacer(),
                    !invoiceLoading
                        ? FlatButton.icon(
                            icon: Icon(Icons.add),
                            label: !exists
                                ? Text('Send Request')
                                : Text("Requested"),
                            onPressed: !exists
                                ? () async {
                                    _handleAlert1(
                                        widget.invoiceData,
                                        widget.profileData,
                                        widget.currentUserData);
                                  }
                                : null)
                        : CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(Colors.white),
                            backgroundColor: Colors.teal),
                    Spacer(),
                  ],
                ),
              ),
            )
          : null,
    );
  }
}

class ImageViewAll extends StatefulWidget {
  Imagelist data;
  int allCount;
  ImageViewAll({Key key, this.data, this.allCount}) : super(key: key);

  @override
  _ImageViewAllState createState() => _ImageViewAllState();
}

class _ImageViewAllState extends State<ImageViewAll> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(),
      body: PhotoView(
        imageProvider: NetworkImage(widget.data.src),
      ),
    );
  }
}

class ProfileImageView extends StatefulWidget {
  model.UserModel data;
  int allCount;
  String token;
  Function updateCurrentUser;
  model.UserModel currentUserData;
  ProfileImageView(
      {Key key,
      this.data,
      this.allCount,
      this.token,
      this.updateCurrentUser,
      this.currentUserData})
      : super(key: key);

  @override
  _ProfileImageViewState createState() => _ProfileImageViewState();
}

class _ProfileImageViewState extends State<ProfileImageView> {
  var progressString = "";
  int totalprogressString = 0;
  int runningprogressString = 0;
  bool loading = false;
  String _fileName = "";
  String _path;
  File _file;
  Map<String, String> _paths;
  List<File> _files;
  bool _hasValidMime = false;
  FileType _pickingType;

  Future<model.UserModel> updateProfileImage(String token, int id, data) async {
    model.UserModel finaldata;
    var dio = new Dio();
    dio.options.headers["Content-Type"] = "multipart/form-data";
    dio.options.headers[HttpHeaders.authorizationHeader] = "Token " + token;
    FormData formData = FormData.fromMap({
      "image": await MultipartFile.fromFile(data['filepath'],
          filename: data['filename']),
    });
    await dio.patch(
      "http://abhishekpraja.pythonanywhere.com/userprofile_image/${widget.data.image.id}/",
      data: formData,
      onSendProgress: (count, total) {
        this.setState(() {
          totalprogressString = total;
          runningprogressString = count;
          progressString = ((count / total) * 100).toStringAsFixed(0) + "%";
        });
      },
    ).then((value) async {
      await getCurrentUser(widget.token).then((value1) {
        widget.updateCurrentUser(value1);
      });
    }).catchError((error) => print(error.response.toString()));
    return finaldata;
  }

  _updateBackgroundImage() async {
    try {
      _file = await FilePicker.getFile(type: FileType.image);
      _path = _file.path;
      setState(() {
        _file = _file;
        _path = _path;
      });
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

  loadingchange() {
    this.setState(() {
      loading = !loading;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.data.username),
      ),
      body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Colors.grey,
          child: !loading
              ? PhotoView(
                  imageProvider: NetworkImage(widget.data.image.image),
                )
              : Center(
                  child: SpinKitFoldingCube(color: Colors.teal),
                )),
      bottomNavigationBar:
          widget.currentUserData.username == widget.data.username
              ? BottomAppBar(
                  elevation: 5,
                  color: Colors.teal,
                  child: Container(
                    height: 50,
                    child: Row(
                      children: [
                        Spacer(),
                        IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () async {
                              await _updateBackgroundImage();
                              updateProfileImage(
                                  widget.token, widget.data.image.id, {
                                'filepath': _file.path,
                                'filename': _fileName,
                              });
                            }),
                        Spacer(),
                      ],
                    ),
                  ),
                )
              : null,
    );
  }
}
