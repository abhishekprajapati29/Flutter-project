import 'package:dio/dio.dart';
import 'package:emoji_picker/emoji_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fproject/Forum/components/api_response.dart';
import 'package:fproject/Team/model.dart';
import 'package:fproject/gettoken.dart';
import 'package:fproject/project/components/MemberForum/components/ForumImageview.dart';
import 'package:fproject/project/components/api_response.dart';
import 'dart:io' as file;
import '../models.dart';
import 'components/showimage.dart';

class MemberForums extends StatefulWidget {
  List<Forums> data;
  List<UserModel> allUser;
  ProjectModel currentUserProjects;
  Function handleProjectData;
  Function handleProjectData1;
  MemberForums(
      {Key key,
      this.data,
      this.allUser,
      this.handleProjectData,
      this.handleProjectData1,
      this.currentUserProjects})
      : super(key: key);

  @override
  _MemberForumsState createState() => _MemberForumsState();
}

class _MemberForumsState extends State<MemberForums> {
  bool showSelectedImage = false;
  bool loading = false;
  UserModel currentUserData;
  List<UserModel> allUser;
  var messages = <Forums>[];
  String username = '';
  TextEditingController send = TextEditingController();
  bool isShowSticker = false;
  String teamName = '';
  String token = '';
  bool sendLoading = false;
  ProjectModel currentUserProjects;
  List<File> data;
  String _fileName = "";
  String _path;
  file.File _file;
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
      messages = widget.data..sort((a, b) => b.id.compareTo(a.id));
      allUser = widget.allUser;
      currentUserProjects = widget.currentUserProjects;
    });
    getTokenPreferences().then(_updateToken);
  }

  _updateToken(String token) async {
    setState(() {
      token = token;
    });
    await getUserPreferences().then((value) async {
      setState(() {
        username = value.username;
        teamName = value.teamName;
      });
    });
    try {
      await getCurrentProjectForum(token, widget.currentUserProjects.id)
          .then((value1) async {
        if (!mounted) return;
        setState(() {
          messages = value1.forums;
        });
        await widget.handleProjectData1(value1);
        await widget.handleProjectData(value1);
      });
    } on PlatformException catch (e) {
      print('exception' + e.toString());
    }
  }

  updateTextMessage() {
    setState(() {
      send.text = '';
    });
  }

  updateMessage(Forums data) {
    this.setState(() {
      messages = [data, ...messages]..sort((a, b) => b.id.compareTo(a.id));
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

  Future<ProjectModel> sendForums(String content, String token, String username,
      ProjectModel currentUserProjects, String path) async {
    ProjectModel finaldata;
    FormData formData;
    var dio = new Dio();
    dio.options.headers[file.HttpHeaders.authorizationHeader] =
        "Token " + token;
    if (path != null) {
      formData = FormData.fromMap({
        "content": content,
        "files":
            await MultipartFile.fromFile(path, filename: path.split('/').last),
        'requested_by': username,
        'project_id': currentUserProjects.id.toString()
      });
    } else {
      formData = FormData.fromMap({
        "content": content,
        'requested_by': username,
        'project_id': currentUserProjects.id.toString()
      });
    }

    await dio.post(
      "http://abhishekpraja.pythonanywhere.com/project-forum/",
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
      final json = value.data;
      var collection = <Forums>[];

      for (var item in currentUserProjects.forums) {
        collection.add(item);
      }
      final data = Forums(
        id: json['id'],
        files: json['files'],
        content: json['content'],
        timestamp: json['timestamp'],
        requestedBy: json['requested_by'],
        projectId: json['project_id'],
      );
      collection.add(data);

      finaldata = ProjectModel(
          id: currentUserProjects.id,
          userId: currentUserProjects.userId,
          username: currentUserProjects.username,
          projectName: currentUserProjects.projectName,
          mainApplication: currentUserProjects.mainApplication,
          startDate: currentUserProjects.startDate,
          endDate: currentUserProjects.endDate,
          projectSize: currentUserProjects.projectSize,
          projectDescription: currentUserProjects.projectDescription,
          preferenece: currentUserProjects.preferenece,
          status: currentUserProjects.status,
          selected: currentUserProjects.selected,
          promemCount: currentUserProjects.promemCount,
          selectedFileCount: currentUserProjects.selectedFileCount + 1,
          selectedFileSize: currentUserProjects.selectedFileCount,
          totalBugsCount: currentUserProjects.totalBugsCount,
          successBugsCount: currentUserProjects.successBugsCount,
          totalTaskCount: currentUserProjects.totalTaskCount,
          successTaskCount: currentUserProjects.successTaskCount,
          fileCount: currentUserProjects.fileCount,
          activityCount: currentUserProjects.activityCount,
          reportCount: currentUserProjects.reportCount,
          successReportCount: currentUserProjects.successReportCount,
          prochip: currentUserProjects.prochip,
          task: currentUserProjects.task,
          bugs: currentUserProjects.bugs,
          forums: collection,
          fileSize: currentUserProjects.fileSize,
          file: currentUserProjects.file,
          report: currentUserProjects.report,
          activity: currentUserProjects.activity,
          promem: currentUserProjects.promem,
          isExpanded: false);
    }).catchError((error) => print(error.response.toString()));
    return finaldata;
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

  _chatBubble(Forums message, bool isMe, bool isSameUser, UserModel userImage) {
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
                                return ForumImageView(data: message);
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
                        RichText(text: TextSpan(text: message.content)),
                      ],
                    )
                  : RichText(text: TextSpan(text: message.content)),
            ),
          ),
          !isSameUser
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      message.requestedBy,
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
                                return ForumImageView(data: message);
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
                                text: message.content,
                                style: TextStyle(color: Colors.black))),
                      ],
                    )
                  : RichText(
                      text: TextSpan(
                          text: message.content,
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
                      message.requestedBy,
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
                    getTokenPreferences().then((token) {
                      sendForums(send.text, token, username,
                              widget.currentUserProjects, _path)
                          .then((value) async {
                        await widget.handleProjectData1(value);
                        await widget.handleProjectData(value);
                        setState(() {
                          messages = value.forums
                            ..sort((a, b) => b.id.compareTo(a.id));
                          showSelectedImage = false;
                          send.text = '';
                          sendLoading = false;
                        });
                      });
                    });
                  },
                )
              : CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.teal),
                  backgroundColor: Colors.white),
        ],
      ),
    );
  }

  handleImageFiles() {
    setState(() {
      showSelectedImage = false;
      _file = null;
      _path = "";
    });
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
            appBar: AppBar(
              brightness: Brightness.dark,
              backgroundColor: Colors.teal,
              centerTitle: true,
              title: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    TextSpan(
                        text: "Member's Discussion's Forum",
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'CrimsonTextRegular',
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
              leading: IconButton(
                  icon: Icon(Icons.arrow_back_ios),
                  color: Colors.white,
                  onPressed: () {
                    Navigator.pop(context);
                  }),
            ),
            body: Column(
              children: <Widget>[
                !showSelectedImage
                    ? Expanded(
                        child: ListView.builder(
                        reverse: true,
                        padding: EdgeInsets.all(20),
                        itemCount: messages.length,
                        itemBuilder: (BuildContext context, int index) {
                          final Forums message = messages[index];
                          final bool isMe = message.requestedBy == username;
                          final bool isSameUser =
                              message.requestedBy == username;
                          final UserModel userImage = allUser
                              .where((element) =>
                                  element.username ==
                                  messages[index].requestedBy)
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
            )));
  }
}
