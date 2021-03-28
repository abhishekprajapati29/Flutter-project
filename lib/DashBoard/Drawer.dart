import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fproject/DashBoard/api_response.dart';
import 'package:fproject/Profile/profile.dart';
import '../gettoken.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({Key key}) : super(key: key);

  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  String username;
  String email;
  String image;
  bool selected = false;
  String teamName;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserPreferences().then((value) {
      this.setState(() {
        username = value.username;
        teamName = value.teamName;
        email = value.email;
        image = value.userImage;
        selected = value.selected;
      });
    });
  }

  _handleLogout() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text(
              "Logout",
              style: TextStyle(
                  fontFamily: 'CrimsonTextRegular',
                  fontWeight: FontWeight.bold),
            ),
            content: Text("Are you sure?",
                style: TextStyle(
                    fontFamily: 'CrimsonTextRegular',
                    fontWeight: FontWeight.bold)),
            actions: [
              CupertinoDialogAction(
                child: Text('No',
                    style: TextStyle(
                        fontFamily: 'CrimsonTextRegular',
                        fontWeight: FontWeight.bold)),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              CupertinoDialogAction(
                child: Text('Yes',
                    style: TextStyle(
                        fontFamily: 'CrimsonTextRegular',
                        fontWeight: FontWeight.bold)),
                onPressed: () async {
                  await getTokenPreferences().then((token) async {
                    await logout(token);
                    Navigator.popAndPushNamed(context, '/login');
                  });
                },
              ),
            ],
          );
        });
  }

  _handleSelected() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text("Alert"),
            content: Text(
                "Until you select and submit the selected option you cannot access most of the content!.."),
            actions: [
              CupertinoDialogAction(
                child: Text('Back'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Drawer(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.teal[800],
                Colors.teal[600],
              ],
            ),
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 100,
                        height: 100,
                        child: Material(
                          elevation: 4.0,
                          shape: CircleBorder(),
                          clipBehavior: Clip.hardEdge,
                          color: Colors.transparent,
                          child: image != null
                              ? Ink.image(
                                  image: NetworkImage(image),
                                  fit: BoxFit.cover,
                                  width: 40.0,
                                  height: 40.0,
                                  child: InkWell(
                                    onTap: () async {
                                      Navigator.push(context, MaterialPageRoute(
                                        builder: (context) {
                                          return User();
                                        },
                                      ));
                                    },
                                  ),
                                )
                              : Ink(
                                  color: Colors.teal,
                                  width: 40.0,
                                  height: 40.0,
                                  child: InkWell(
                                    onTap: () async {
                                      Navigator.push(context, MaterialPageRoute(
                                        builder: (context) {
                                          return User();
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
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey[400],
                              blurRadius: 8.0, // soften the shadow
                              spreadRadius: 3.0,
                            )
                          ],
                        ),
                      ),
                    )),
                username != null
                    ? Text(username.capitalize(),
                        style: TextStyle(fontSize: 22, color: Colors.white))
                    : Container(),
                SizedBox(
                  height: 5,
                ),
                email != null
                    ? Text(email,
                        style: TextStyle(fontSize: 15, color: Colors.white))
                    : Container(),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: Divider(
                    color: Colors.white,
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Spacer(),
                    IconButton(
                        icon: Icon(
                          FontAwesomeIcons.envelopeOpenText,
                          color: Colors.white,
                          size: 20,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.of(context).pushNamed("/invite");
                        }),
                    Spacer(),
                    IconButton(
                        icon: Icon(
                          Icons.message,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.of(context).pushNamed("/message");
                        }),
                    Spacer(),
                    IconButton(
                        icon: Icon(
                          FontAwesomeIcons.bell,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.of(context).pushNamed("/notification");
                        }),
                    Spacer(),
                    IconButton(
                        icon: Icon(
                          FontAwesomeIcons.signOutAlt,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          _handleLogout();
                        }),
                    Spacer(),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: Divider(
                    color: Colors.white,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: ListTile(
                    leading: Icon(
                      Icons.dashboard,
                      color: Colors.white,
                    ),
                    title: Text('DashBoard',
                        style: TextStyle(color: Colors.white, fontSize: 20)),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.of(context).popAndPushNamed('/dashboard');
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: ListTile(
                    leading: Icon(
                      FontAwesomeIcons.tasks,
                      color: Colors.white,
                    ),
                    title: Text('To Do',
                        style: TextStyle(color: Colors.white, fontSize: 20)),
                    onTap: !selected
                        ? () {
                            Navigator.pop(context);
                            Navigator.of(context).popAndPushNamed('/todo');
                          }
                        : () {
                            _handleSelected();
                          },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: ListTile(
                    leading: Icon(
                      FontAwesomeIcons.stickyNote,
                      color: Colors.white,
                    ),
                    title: Text('Note',
                        style: TextStyle(color: Colors.white, fontSize: 20)),
                    onTap: !selected
                        ? () {
                            Navigator.pop(context);
                            Navigator.of(context).popAndPushNamed('/notes');
                          }
                        : () {
                            _handleSelected();
                          },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: ListTile(
                    leading: Icon(
                      FontAwesomeIcons.bookOpen,
                      color: Colors.white,
                    ),
                    title: Text('Diary',
                        style: TextStyle(color: Colors.white, fontSize: 20)),
                    onTap: !selected
                        ? () {
                            Navigator.pop(context);
                            Navigator.of(context).popAndPushNamed('/diarys');
                          }
                        : () {
                            _handleSelected();
                          },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: ListTile(
                    leading: Icon(
                      FontAwesomeIcons.images,
                      color: Colors.white,
                    ),
                    title: Text('Album',
                        style: TextStyle(color: Colors.white, fontSize: 20)),
                    onTap: !selected
                        ? () {
                            Navigator.pop(context);
                            Navigator.of(context).popAndPushNamed('/album');
                          }
                        : () {
                            _handleSelected();
                          },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: ListTile(
                    leading: Icon(
                      Icons.video_library,
                      color: Colors.white,
                    ),
                    title: Text('Video',
                        style: TextStyle(color: Colors.white, fontSize: 20)),
                    onTap: !selected
                        ? () {
                            Navigator.pop(context);
                            Navigator.of(context).popAndPushNamed('/video');
                          }
                        : () {
                            _handleSelected();
                          },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: ListTile(
                    leading: Icon(
                      FontAwesomeIcons.filePdf,
                      color: Colors.white,
                    ),
                    title: Text('Document',
                        style: TextStyle(color: Colors.white, fontSize: 20)),
                    onTap: !selected
                        ? () {
                            Navigator.pop(context);
                            Navigator.of(context).popAndPushNamed('/file');
                          }
                        : () {
                            _handleSelected();
                          },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: ListTile(
                    leading: Icon(
                      FontAwesomeIcons.users,
                      color: Colors.white,
                    ),
                    title: Text('Team',
                        style: TextStyle(color: Colors.white, fontSize: 20)),
                    onTap: !selected
                        ? () {
                            Navigator.pop(context);
                            Navigator.of(context).popAndPushNamed('/team');
                          }
                        : () {
                            _handleSelected();
                          },
                  ),
                ),
                teamName != 'default_team_name'
                    ? Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: ListTile(
                          leading: Icon(
                            Icons.chat,
                            color: Colors.white,
                          ),
                          title: Text('Team Forum',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20)),
                          onTap: !selected
                              ? () {
                                  Navigator.pop(context);
                                  Navigator.of(context)
                                      .popAndPushNamed('/forum');
                                }
                              : () {
                                  _handleSelected();
                                },
                        ),
                      )
                    : Container(),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: ListTile(
                    leading: Icon(
                      FontAwesomeIcons.userCircle,
                      color: Colors.white,
                    ),
                    title: Text('Profile',
                        style: TextStyle(color: Colors.white, fontSize: 20)),
                    onTap: !selected
                        ? () {
                            Navigator.of(context).popAndPushNamed('/user');
                          }
                        : () {
                            _handleSelected();
                          },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: ListTile(
                    leading: Icon(
                      FontAwesomeIcons.projectDiagram,
                      color: Colors.white,
                    ),
                    title: Text('Project',
                        style: TextStyle(color: Colors.white, fontSize: 20)),
                    onTap: !selected
                        ? () {
                            Navigator.pop(context);
                            Navigator.of(context).popAndPushNamed('/project');
                          }
                        : () {
                            _handleSelected();
                          },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: ListTile(
                    leading: Icon(
                      FontAwesomeIcons.solidCheckCircle,
                      color: Colors.white,
                    ),
                    title: Text('Selector',
                        style: TextStyle(color: Colors.white, fontSize: 20)),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.of(context).popAndPushNamed('/selector');
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: ListTile(
                    leading: Icon(
                      FontAwesomeIcons.slidersH,
                      color: Colors.white,
                    ),
                    title: Text('Setting',
                        style: TextStyle(color: Colors.white, fontSize: 20)),
                    onTap: !selected
                        ? () {
                            Navigator.pop(context);
                            Navigator.of(context).popAndPushNamed('/setting');
                          }
                        : () {
                            _handleSelected();
                          },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
