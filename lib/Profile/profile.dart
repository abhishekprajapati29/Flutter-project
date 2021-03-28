import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fproject/Album/components/model.dart';
import 'package:fproject/Team/api_response.dart';
import 'package:fproject/Team/model.dart';
import 'package:fproject/gettoken.dart';
import 'package:photo_view/photo_view.dart';

class User extends StatefulWidget {
  User({Key key}) : super(key: key);

  @override
  _UserState createState() => _UserState();
}

class _UserState extends State<User> {
  UserModel currentUser;
  List<Imagelist> userImage;
  bool loading = false;
  int allCount = 0;
  String token = "";
  var progressString = "";
  var userImages = <Imagelist>[];
  int totalprogressString = 0;
  int runningprogressString = 0;
  String _fileName = "";
  String _path;
  File _file;
  Map<String, String> _paths;
  List<File> _files;
  bool _hasValidMime = false;
  FileType _pickingType;
  bool loadingImagesAll = false;
  bool invoiceLoading = false;
  bool exists = false;

  updateCurrentUser(UserModel data) {
    this.setState(() {
      currentUser = data;
    });
  }

  Future<UserModel> updateImage(String token, int id, data) async {
    UserModel finaldata;
    var dio = new Dio();
    dio.options.headers["Content-Type"] = "multipart/form-data";
    dio.options.headers[HttpHeaders.authorizationHeader] = "Token " + token;
    FormData formData = FormData.fromMap({
      "background_image": await MultipartFile.fromFile(data['filepath'],
          filename: data['filename']),
    });
    await dio.patch(
      "http://abhishekpraja.pythonanywhere.com/userprofile/${currentUser.profile.id}/",
      data: formData,
      onSendProgress: (count, total) {
        this.setState(() {
          totalprogressString = total;
          runningprogressString = count;
          progressString = ((count / total) * 100).toStringAsFixed(0) + "%";
        });
      },
    ).then((value) async {
      await getCurrentUser(token).then((value1) {
        updateCurrentUser(value1);
      });
    }).catchError((error) => print(error.response.toString()));
    return finaldata;
  }

  Future<UserModel> updateProfileImage(String token, int id, data) async {
    UserModel finaldata;
    var dio = new Dio();
    dio.options.headers["Content-Type"] = "multipart/form-data";
    dio.options.headers[HttpHeaders.authorizationHeader] = "Token " + token;
    FormData formData = FormData.fromMap({
      "image": await MultipartFile.fromFile(data['filepath'],
          filename: data['filename']),
    });
    await dio.patch(
      "http://abhishekpraja.pythonanywhere.com/userprofile_image/${currentUser.image.id}/",
      data: formData,
      onSendProgress: (count, total) {
        this.setState(() {
          totalprogressString = total;
          runningprogressString = count;
          progressString = ((count / total) * 100).toStringAsFixed(0) + "%";
        });
      },
    ).then((value) async {
      await getCurrentUser(token).then((value1) {
        updateCurrentUser(value1);
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
  void initState() {
    // TODO: implement initState
    super.initState();
    this.setState(() {
      loading = !loading;
    });
    getTokenPreferences().then((value) async {
      await getCurrentUser(value).then((value1) {
        this.setState(() {
          currentUser = value1;
          token = value;
        });
      });
      await getAllUsersData(value).then((value2) {
        this.setState(() {
          allCount = value2
              .where((element) =>
                  element.profile.teamName == currentUser.profile.teamName)
              .toList()
              .length;
        });
      });
      await getUserImages(value).then((value3) {
        this.setState(() {
          userImage = value3;
          loading = !loading;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: !loading
            ? WillPopScope(
                onWillPop: onWillPop,
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.3,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    image: DecorationImage(
                                      image: NetworkImage(
                                          currentUser.profile.backgroundImage),
                                      fit: BoxFit.cover,
                                    ),
                                    borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(20),
                                        bottomRight: Radius.circular(20)))),
                            Container(
                              height: MediaQuery.of(context).size.height * 0.3,
                              width: MediaQuery.of(context).size.width,
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(15, 30, 0, 0),
                                child: Container(
                                    alignment: Alignment.topLeft,
                                    child: ClipOval(
                                      child: Material(
                                        color: Colors.blueGrey, // button color
                                        child: InkWell(
                                          splashColor:
                                              Colors.blue, // inkwell color
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
                            Container(
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
                                          splashColor:
                                              Colors.blue, // inkwell color
                                          child: SizedBox(
                                              width: 40,
                                              height: 40,
                                              child: Icon(Icons.edit)),
                                          onTap: () async {
                                            await _updateBackgroundImage();
                                            updateImage(
                                                token, currentUser.profile.id, {
                                              'filepath': _file.path,
                                              'filename': _fileName,
                                            });
                                          },
                                        ),
                                      ),
                                    )),
                              ),
                            ),
                            Center(
                              child: Container(
                                margin: EdgeInsets.only(
                                    top: MediaQuery.of(context).size.height *
                                        0.2),
                                width: 150,
                                height: 150,
                                child: Material(
                                  elevation: 4.0,
                                  shape: CircleBorder(),
                                  clipBehavior: Clip.hardEdge,
                                  color: Colors.transparent,
                                  child: Ink.image(
                                    image:
                                        NetworkImage(currentUser.image.image),
                                    fit: BoxFit.cover,
                                    width: 120.0,
                                    height: 120.0,
                                    child: InkWell(
                                      onTap: () async {
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                          builder: (context) {
                                            return ProfileImageView1(
                                                data: currentUser,
                                                token: token,
                                                updateCurrentUser:
                                                    updateCurrentUser,
                                                allCount: allCount);
                                          },
                                        ));
                                      },
                                    ),
                                  ),
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  border: Border.all(
                                      width: 5, color: Colors.white70),
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
                                  currentUser.username,
                                  style: TextStyle(
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Text(
                                  currentUser.profile.aboutMe,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.normal),
                                ),
                              ),
                              currentUser.profile.teamName !=
                                      'default_team_name'
                                  ? Padding(
                                      padding: const EdgeInsets.all(6.0),
                                      child: Row(
                                        children: [
                                          Spacer(),
                                          Column(
                                            children: [
                                              FlatButton.icon(
                                                  onPressed: () {},
                                                  icon: Icon(
                                                      FontAwesomeIcons.users),
                                                  label: Text('Team')),
                                              Text(currentUser.profile.teamName
                                                  .toUpperCase())
                                            ],
                                          ),
                                          Spacer(),
                                          Column(
                                            children: [
                                              FlatButton.icon(
                                                  onPressed: () {},
                                                  icon: Icon(
                                                      FontAwesomeIcons.users),
                                                  label: Text('Members')),
                                              Text(allCount.toString())
                                            ],
                                          ),
                                          Spacer(),
                                        ],
                                      ))
                                  : Padding(
                                      padding: const EdgeInsets.all(6.0),
                                      child: Row(
                                        children: [
                                          Spacer(),
                                          Column(
                                            children: [
                                              FlatButton.icon(
                                                  onPressed: () {},
                                                  icon: Icon(
                                                      FontAwesomeIcons.users),
                                                  label: Text('Team')),
                                              Text('None'.toUpperCase())
                                            ],
                                          ),
                                          Spacer(),
                                          Column(
                                            children: [
                                              FlatButton.icon(
                                                  onPressed: () {},
                                                  icon: Icon(
                                                      FontAwesomeIcons.users),
                                                  label: Text('Members')),
                                              Text('0')
                                            ],
                                          ),
                                          Spacer(),
                                        ],
                                      )),
                              Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.8,
                                child: StaggeredGridView.countBuilder(
                                  crossAxisCount: 4,
                                  itemCount: userImage.length,
                                  itemBuilder:
                                      (BuildContext context, int index) =>
                                          GestureDetector(
                                    onTap: () {
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) {
                                        return ImageViewAll1(
                                          data: userImage[index],
                                        );
                                      }));
                                    },
                                    child: new Container(
                                        decoration: new BoxDecoration(
                                            image: new DecorationImage(
                                                image: new NetworkImage(
                                                    userImage[index].src),
                                                fit: BoxFit.cover))),
                                  ),
                                  staggeredTileBuilder: (int index) =>
                                      new StaggeredTile.count(
                                          2, index.isEven ? 2 : 1),
                                  mainAxisSpacing: 4.0,
                                  crossAxisSpacing: 4.0,
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )
            : Center(
                child: SpinKitFoldingCube(color: Colors.teal),
              ));
  }
}

class ImageViewAll1 extends StatefulWidget {
  Imagelist data;
  int allCount;
  ImageViewAll1({Key key, this.data, this.allCount}) : super(key: key);

  @override
  _ImageViewAll1State createState() => _ImageViewAll1State();
}

class _ImageViewAll1State extends State<ImageViewAll1> {
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

class ProfileImageView1 extends StatefulWidget {
  UserModel data;
  int allCount;
  String token;
  Function updateCurrentUser;
  ProfileImageView1({
    Key key,
    this.data,
    this.allCount,
    this.token,
    this.updateCurrentUser,
  }) : super(key: key);

  @override
  _ProfileImageView1State createState() => _ProfileImageView1State();
}

class _ProfileImageView1State extends State<ProfileImageView1> {
  var progressString = "";
  int totalprogressString = 0;
  int runningprogressString = 0;
  bool loading = false;
  bool editLoading = false;
  String _fileName = "";
  String _path;
  File _file;
  Map<String, String> _paths;
  List<File> _files;
  bool _hasValidMime = false;
  FileType _pickingType;
  UserModel data;

  Future<UserModel> updateProfileImage(String token, int id, data) async {
    UserModel finaldata;
    this.setState(() {
      editLoading = true;
    });
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
        this.setState(() {
          data = value1;
          editLoading = false;
        });
        Navigator.pop(context);
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
  void initState() {
    // TODO: implement initState
    super.initState();
    this.setState(() {
      data = widget.data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(data.username),
        ),
        body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: Colors.grey,
            child: !loading
                ? PhotoView(
                    imageProvider: NetworkImage(data.image.image),
                  )
                : Center(
                    child: SpinKitFoldingCube(color: Colors.teal),
                  )),
        bottomNavigationBar: BottomAppBar(
          elevation: 5,
          color: Colors.teal,
          child: Container(
            height: 50,
            child: Row(
              children: [
                Spacer(),
                !editLoading
                    ? IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: !editLoading
                            ? () async {
                                await _updateBackgroundImage();
                                updateProfileImage(
                                    widget.token, data.image.id, {
                                  'filepath': _file.path,
                                  'filename': _fileName,
                                });
                              }
                            : null)
                    : SpinKitFoldingCube(color: Colors.teal),
                Spacer(),
              ],
            ),
          ),
        ));
  }
}
