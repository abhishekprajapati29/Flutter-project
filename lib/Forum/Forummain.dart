import 'dart:io';
import 'package:dio/dio.dart';
import 'package:emoji_picker/emoji_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fproject/DashBoard/Drawer.dart';
import 'package:fproject/Team/api_response.dart' as team;
import 'package:fproject/Team/model.dart';
import 'package:fproject/Forum/components/models.dart';
import 'package:fproject/gettoken.dart';
import 'package:fproject/project/components/MemberForum/components/showimage.dart';
import 'package:photo_view/photo_view.dart';
import 'components/api_response.dart';

class Forum extends StatefulWidget {
  Forum({Key key}) : super(key: key);

  @override
  _ForumState createState() => _ForumState();
}

class _ForumState extends State<Forum> {
  bool showSelectedImage = false;
  bool loading = false;
  UserModel currentUserData;
  List<UserModel> allUsers;
  List<MessageModel> messages;
  String username = '';
  TextEditingController send = TextEditingController();
  bool isShowSticker = false;
  String teamName = '';
  bool sendLoading = false;
  String token = '';
  List<File> data;
  String _fileName = "";
  String _path;
  File _file;
  Map<String, String> _paths;
  String _extension;
  bool _switchValue = false;
  bool _multiPick = false;
  bool _hasValidMime = false;
  bool downloading = false;
  var progressString = "";
  int totalprogressString = 0;
  int totaldownloadprogress = 0;
  int runningdownloadprogress = 0;
  var downloadprogress = '';
  int downloadIndex = 0;
  int runningprogressString = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.setState(() {
      loading = true;
    });
    getTokenPreferences().then(_updateToken);
  }

  _updateToken(String token) async {
    setState(() {
      token = token;
    });
    await team.getCurrentUser(token).then((value) async {
      setState(() {
        currentUserData = value;
        username = value.username;
        teamName = value.profile.teamName;
      });
      await getAllUsersData(token).then((value1) {
        this.setState(() {
          allUsers = value1
              .where((element) =>
                  element.profile.teamName == value.profile.teamName)
              .toList();
        });
      });
      await getAllMessageData(token, value.profile.teamName).then((value1) {
        this.setState(() {
          messages = value1..sort((a, b) => b.id.compareTo(a.id));
          loading = false;
        });
      });
    });
  }

  updateTextMessage() {
    setState(() {
      send.text = '';
    });
  }

  void _openFileExplorer() async {
    try {
      if (_multiPick) {
        _path = null;
      } else {
        _paths = null;
        _file = await FilePicker.getFile(
            type: FileType.custom, allowedExtensions: ['png', 'jpg', 'jpeg']);
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

  Future<MessageModel> sendTeamForums(String content, String token,
      String username, String path, String teamName) async {
    MessageModel finaldata;
    FormData formData;
    var dio = new Dio();
    dio.options.headers[HttpHeaders.authorizationHeader] = "Token " + token;
    if (path != null) {
      formData = FormData.fromMap({
        "message": content,
        "files":
            await MultipartFile.fromFile(path, filename: path.split('/').last),
        'teamName': teamName,
        'user': username,
      });
    } else {
      formData = FormData.fromMap({
        "message": content,
        'teamName': teamName,
        'user': username,
      });
    }

    await dio.post(
      "http://abhishekpraja.pythonanywhere.com/comment/",
      data: formData,
      onSendProgress: (rec, total) {
        print("Rec: $rec , Total: $total");

        setState(() {
          totalprogressString = total;
          runningprogressString = rec;
          progressString = ((rec / total) * 100).toStringAsFixed(0) + "%";
        });
      },
    ).then((value) async {
      final item = value.data;
      finaldata = MessageModel(
          id: item['id'],
          message: item['message'],
          files: item['files'],
          teamName: item['teamName'],
          timestamp: item['timestamp'],
          user: item['user']);
    }).catchError((error) => print(error.response.toString()));
    return finaldata;
  }

  updateMessage(MessageModel data) {
    this.setState(() {
      messages = [data, ...messages];
    });
  }

  Widget buildSticker() {
    return EmojiPicker(
      rows: 3,
      columns: 7,
      buttonMode: ButtonMode.MATERIAL,
      recommendKeywords: ["racing", "horse"],
      numRecommended: 10,
      onEmojiSelected: (emoji, category) {
        send.text = send.text + emoji.emoji;
      },
    );
  }

  _chatBubble(
      MessageModel message, bool isMe, bool isSameUser, UserModel userImage) {
    if (isMe) {
      return Column(
        children: <Widget>[
          Container(
            alignment: Alignment.topRight,
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.80,
              ),
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: Colors.teal,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: message.files != null
                  ? Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                return TeamForumImageView(data: message);
                              },
                            ));
                          },
                          child: Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: NetworkImage(message.files))),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        RichText(text: TextSpan(text: message.message)),
                      ],
                    )
                  : RichText(text: TextSpan(text: message.message)),
            ),
          ),
          !isSameUser
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      message.user,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black45,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 15,
                        backgroundColor: Colors.teal,
                        backgroundImage: NetworkImage(userImage.image.image),
                        // backgroundImage: AssetImage(message.sender.imageUrl),
                      ),
                    ),
                  ],
                )
              : Container(
                  child: null,
                ),
        ],
      );
    } else {
      return Column(
        children: <Widget>[
          Container(
            alignment: Alignment.topLeft,
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.80,
              ),
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: message.files != null
                  ? Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(
                              builder: (context) {
                                return TeamForumImageView(data: message);
                              },
                            ));
                          },
                          child: Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: NetworkImage(message.files))),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        RichText(
                            text: TextSpan(
                                text: message.message,
                                style: TextStyle(color: Colors.black))),
                      ],
                    )
                  : RichText(
                      text: TextSpan(
                          text: message.message,
                          style: TextStyle(color: Colors.black))),
            ),
          ),
          !isSameUser
              ? Row(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 15,
                        backgroundColor: Colors.teal,
                        backgroundImage: NetworkImage(userImage.image.image),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      message.user,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black45,
                      ),
                    ),
                  ],
                )
              : Container(
                  child: null,
                ),
        ],
      );
    }
  }

  _sendMessageArea() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8),
      height: 70,
      color: Colors.white,
      child: Row(
        children: <Widget>[
          IconButton(
            icon: Icon(
              Icons.image,
              color: Colors.teal,
            ),
            iconSize: 25,
            color: Theme.of(context).primaryColor,
            onPressed: () {
              _openFileExplorer();
              showSelectedImage = !showSelectedImage;
            },
          ),
          IconButton(
            icon: Icon(
              Icons.face,
              color: Colors.teal,
            ),
            iconSize: 25,
            color: Theme.of(context).primaryColor,
            onPressed: () {
              this.setState(() {
                isShowSticker = !isShowSticker;
              });
            },
          ),
          Expanded(
            child: TextField(
              controller: send,
              decoration: InputDecoration.collapsed(
                hintText: 'Share your ideas ...',
              ),
              textCapitalization: TextCapitalization.sentences,
            ),
          ),
          !sendLoading
              ? IconButton(
                  icon: Icon(
                    Icons.send,
                    color: Colors.teal,
                  ),
                  iconSize: 25,
                  color: Theme.of(context).primaryColor,
                  onPressed: () {
                    setState(() {
                      sendLoading = true;
                    });
                    getTokenPreferences().then((token) async {
                      await sendTeamForums(
                              send.text, token, username, _path, teamName)
                          .then((value) {
                        updateMessage(value);
                        setState(() {
                          sendLoading = false;
                          send.text = '';
                          _file = null;
                          showSelectedImage = false;
                        });
                      });
                    });
                  },
                )
              : CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.teal),
                  backgroundColor: Colors.white,
                ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    //print('message = ${messages.length}');
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            canvasColor: Colors.transparent,
            accentColor: Colors.teal,
            fontFamily: 'CrimsonTextRegular'),
        routes: MyRoute,
        home: Scaffold(
          backgroundColor: Color(0xFFF6F6F6),
          drawer: MyDrawer(),
          appBar: AppBar(
            brightness: Brightness.dark,
            backgroundColor: Colors.teal,
            centerTitle: true,
            title: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  TextSpan(
                      text: "Team Idea's",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      )),
                ],
              ),
            ),
            actions: showSelectedImage
                ? [
                    IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            showSelectedImage = false;
                            _file = null;
                            _path = "";
                          });
                        })
                  ]
                : [],
          ),
          body: !loading
              ? WillPopScope(
                  onWillPop: onWillPop,
                  child: Column(
                    children: <Widget>[
                      !showSelectedImage
                          ? Expanded(
                              child: ListView.builder(
                              reverse: true,
                              padding: EdgeInsets.all(20),
                              itemCount: messages.length,
                              itemBuilder: (BuildContext context, int index) {
                                final MessageModel message = messages[index];
                                final bool isMe = message.user == username;
                                final bool isSameUser =
                                    message.user == username;
                                final UserModel userImage = allUsers
                                    .where((element) =>
                                        element.username ==
                                        messages[index].user)
                                    .toList()[0];
                                return _chatBubble(
                                    message, isMe, isSameUser, userImage);
                              },
                            ))
                          : ShowImage(
                              image: _file.path,
                            ),
                      isShowSticker ? buildSticker() : Container(),
                      _sendMessageArea(),
                    ],
                  ),
                )
              : Center(
                  child: SpinKitFoldingCube(color: Colors.teal),
                ),
        ));
  }
}

class TeamForumImageView extends StatefulWidget {
  MessageModel data;
  TeamForumImageView({Key key, this.data}) : super(key: key);

  @override
  _TeamForumImageViewState createState() => _TeamForumImageViewState();
}

class _TeamForumImageViewState extends State<TeamForumImageView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: SingleChildScrollView(
            scrollDirection: Axis.horizontal, child: Text(widget.data.message)),
      ),
      body: PhotoView(
        imageProvider: NetworkImage(widget.data.files),
      ),
    );
  }
}
