import 'package:flutter/material.dart';
import 'package:fproject/DashBoard/Drawer.dart';
import 'package:fproject/Team/api_response.dart' as team;
import 'package:fproject/Team/model.dart';
import 'package:fproject/chat/components/models.dart';
import 'package:fproject/gettoken.dart';
import 'components/api_response.dart';
import 'components/chat.dart';

class Chat extends StatefulWidget {
  Chat({Key key}) : super(key: key);

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  String token = '';
  List<UserModel> allUsers;
  bool loading = false;
  UserModel currentUserData;
  List<MessageModel> messages;
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
    this.setState(() {
      token = token;
    });
    await team.getCurrentUser(token).then((value) async {
      this.setState(() {
        currentUserData = value;
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

  updateMessage(MessageModel data) {
    this.setState(() {
      messages = [data, ...messages];
    });
  }

  @override
  Widget build(BuildContext context) {
    //print('message = ${messages.length}');
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            canvasColor: Colors.transparent,
            accentColor: Colors.blue,
            fontFamily: 'NotoEmoji'),
        routes: MyRoute,
        home: Scaffold(
          backgroundColor: Colors.white,
          drawer: MyDrawer(),
          appBar: AppBar(
            brightness: Brightness.dark,
            elevation: 8,
            title: Text(
              'Inbox',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.search),
                color: Colors.white,
                onPressed: () {},
              ),
            ],
          ),
          body: !loading
              ? ListView.builder(
                  itemCount: allUsers.length,
                  itemBuilder: (BuildContext context, int index) {
                    final UserModel chat = allUsers[index];
                    return GestureDetector(
                      // onTap: () => Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (_) => ChatScreen(
                      //       user: chat.username,
                      //     ),
                      //   ),
                      // ),
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                        child: Row(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.all(2),
                              decoration: true
                                  ? BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(40)),
                                      border: Border.all(
                                        width: 2,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      // shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 2,
                                          blurRadius: 5,
                                        ),
                                      ],
                                    )
                                  : BoxDecoration(
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
                                radius: 35,
                                backgroundImage: NetworkImage(chat.image.image),
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.64,
                              padding: EdgeInsets.only(
                                left: 20,
                              ),
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Text(
                                            chat.username.substring(0, 5),
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          true
                                              ? Container(
                                                  margin: const EdgeInsets.only(
                                                      left: 5),
                                                  width: 7,
                                                  height: 7,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                  ),
                                                )
                                              : Container(
                                                  child: null,
                                                ),
                                        ],
                                      ),
                                      Text(
                                        '12:30 PM',
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w300,
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      chat.profile.aboutMe,
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.black54,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                )
              : Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.white,
                    ),
                  ),
                ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return ChatMessage(
                      messages: messages,
                      teamName: currentUserData.profile.teamName,
                      updateMessage: updateMessage,
                      token: token);
                },
              ));
            },
            child: Icon(Icons.message),
          ),
        ));
  }
}
