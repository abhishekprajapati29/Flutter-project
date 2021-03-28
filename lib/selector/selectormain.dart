import 'package:filesize/filesize.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fproject/Album/components/model.dart';
import 'package:fproject/DashBoard/Drawer.dart';
import 'package:fproject/File/components/model.dart';
import 'package:fproject/Video/components/model.dart';
import 'package:fproject/gettoken.dart';
import 'package:fproject/paytm/PaymentScreen.dart';
import 'package:fproject/project/components/api_response.dart';
import 'package:fproject/project/components/models.dart';
import 'package:fproject/selector/components/albumselector.dart';
import 'package:fproject/selector/components/fileselector.dart';
import 'package:fproject/selector/components/projectselector.dart';
import 'package:fproject/selector/components/videoselector.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'components/api_response.dart';

class SelectorMain extends StatefulWidget {
  SelectorMain({Key key}) : super(key: key);

  @override
  _SelectorMainState createState() => _SelectorMainState();
}

class _SelectorMainState extends State<SelectorMain> {
  int tab = 0;
  bool initLoading = false;
  List<AlbumModel> albums;
  List<FileModel> files;
  List<ProjectModel> projects;
  List<VideoModel> videos;
  int selectedSpace = 0;
  int unselectedSpace = 0;
  int totalspace = 0;
  bool selected = false;
  bool loadingsubmit = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      initLoading = true;
    });
    getUserPreferences().then((user) {
      if (user.selected == true) {
        setState(() {
          totalspace = user.cloudStorage;
          selected = user.selected;
        });
        getTokenPreferences().then((token) async {
          await getUserAlbum(token).then((value) {
            setState(() {
              albums = value;
            });
            for (var item in value) {
              if (item.selected == true && item.imagelistsize != null) {
                setState(() {
                  selectedSpace = selectedSpace + item.imagelistsize;
                });
              }
            }
          });
          await getUserFile(token).then((value) {
            setState(() {
              files = value;
            });
            for (var item in value) {
              if (item.selected == true && item.size != null) {
                setState(() {
                  selectedSpace = selectedSpace + item.size;
                });
              }
            }
          });
          await getUserProject(token).then((value) {
            setState(() {
              projects = value..sort((a, b) => b.id.compareTo(a.id));
            });
            for (var item in value) {
              if (item.selected == true && item.projectSize != null) {
                setState(() {
                  selectedSpace = selectedSpace + item.projectSize;
                });
              }
            }
          });
          await getUserVideo(token).then((value) {
            setState(() {
              videos = value;
              initLoading = false;
            });
            for (var item in value) {
              if (item.selected == true && item.size != null) {
                setState(() {
                  selectedSpace = selectedSpace + item.size;
                });
              }
            }
          });
        });
      } else {
        setState(() {
          totalspace = user.cloudStorage;
          selected = user.selected;
        });
        getTokenPreferences().then((token) async {
          await getUserAlbum(token).then((value) {
            setState(() {
              albums =
                  value.where((element) => element.selected == false).toList();
            });
            for (var item in value) {
              if (item.selected == false && item.imagelistsize != null) {
                setState(() {
                  unselectedSpace = unselectedSpace + item.imagelistsize;
                });
              }
            }
          });
          await getUserFile(token).then((value) {
            setState(() {
              files =
                  value.where((element) => element.selected == false).toList();
            });
            for (var item in value) {
              if (item.selected == false && item.size != null) {
                setState(() {
                  unselectedSpace = unselectedSpace + item.size;
                });
              }
            }
          });
          await getUserProject(token).then((value) {
            setState(() {
              projects =
                  value.where((element) => element.selected == false).toList();
            });
            for (var item in value) {
              if (item.selected == false && item.projectSize != null) {
                setState(() {
                  unselectedSpace = unselectedSpace + item.projectSize;
                });
              }
            }
          });
          await getUserVideo(token).then((value) {
            setState(() {
              videos =
                  value.where((element) => element.selected == false).toList();
              initLoading = false;
            });
            for (var item in value) {
              if (item.selected == false && item.size != null) {
                setState(() {
                  unselectedSpace = unselectedSpace + item.size;
                });
              }
            }
          });
        });
      }
    });
  }

  _handlesubmit(count) {
    return totalspace >= selectedSpace
        ? showDialog(
            context: context,
            builder: (BuildContext context) {
              return CupertinoAlertDialog(
                title: Text("Submit"),
                content: Text("After submit you cannot change it?"),
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
                      this.setState(() {
                        loadingsubmit = true;
                      });

                      await getTokenPreferences().then((token) async {
                        await handleSubmitFinal(token);
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        prefs.setInt('projectCount', count);
                        Navigator.pop(context);
                        Navigator.popAndPushNamed(context, '/dashboard');
                        this.setState(() {
                          loadingsubmit = false;
                        });
                      });
                    },
                  ),
                ],
              );
            })
        : showDialog(
            context: context,
            builder: (BuildContext context) {
              return CupertinoAlertDialog(
                title: Text("Storage exceed"),
                content: Text(
                    "Select content's whose size not exceeds total space?"),
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

  handleIncrementspace(int data) {
    this.setState(() {
      selectedSpace = selectedSpace + data;
    });
  }

  handleDecrementspace(int data) {
    this.setState(() {
      selectedSpace = selectedSpace - data;
    });
  }

  handlealbum(data) {
    this.setState(() {
      albums = data;
    });
  }

  handlevideo(data) {
    this.setState(() {
      videos = data;
    });
  }

  handlefile(data) {
    this.setState(() {
      files = data;
    });
  }

  handleproject(data) {
    this.setState(() {
      projects = data;
    });
  }

  _handleAlertProject() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text("Alert"),
            content: Text("Project count Excced."),
            actions: [
              CupertinoDialogAction(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  _handleSelectorBuy() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text("Buy Selector Option"),
            content: Text("Click 'Yes' to go to Payment Potal."),
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
                  getTokenPreferences().then((token) {
                    getUserPreferences().then((user) {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return PaymentScreen(
                            amount: '30',
                            username: user.username,
                            token: token,
                          );
                        },
                      ));
                    });
                  });
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          accentColor: Colors.teal,
          canvasColor: Colors.transparent,
          fontFamily: 'CrimsonTextRegular'),
      routes: MyRoute,
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: tab == 0
              ? Text("Select Album's")
              : tab == 1
                  ? Text("Select Video's")
                  : tab == 2
                      ? Text("Select File's")
                      : tab == 3 ? Text("Select Project's") : null,
          centerTitle: true,
          backgroundColor: Colors.teal,
          actions: !selected
              ? [
                  IconButton(
                      icon: Icon(FontAwesomeIcons.shoppingCart),
                      onPressed: () {
                        _handleSelectorBuy();
                      })
                ]
              : [],
        ),
        drawer: MyDrawer(),
        body: WillPopScope(
            onWillPop: onWillPop,
            child: tab == 0
                ? AlbumSelector(
                    albums: albums,
                    initLoading: initLoading,
                    handleIncrementspace: handleIncrementspace,
                    handleDecrementspace: handleDecrementspace,
                    selected: selected,
                    handlealbum: handlealbum)
                : tab == 1
                    ? VideoSelector(
                        videos: videos,
                        initLoading: initLoading,
                        handleIncrementspace: handleIncrementspace,
                        handleDecrementspace: handleDecrementspace,
                        selected: selected,
                        handlevideo: handlevideo)
                    : tab == 2
                        ? FileSelector(
                            files: files,
                            initLoading: initLoading,
                            handleIncrementspace: handleIncrementspace,
                            handleDecrementspace: handleDecrementspace,
                            selected: selected,
                            handlefile: handlefile)
                        : tab == 3
                            ? ProjectSelector(
                                projects: projects,
                                initLoading: initLoading,
                                handleIncrementspace: handleIncrementspace,
                                handleDecrementspace: handleDecrementspace,
                                selected: selected,
                                handleproject: handleproject)
                            : null),
        bottomNavigationBar: Container(
          width: MediaQuery.of(context).size.width,
          child: selected
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text(
                          'Selected Space:- ${filesize(selectedSpace)} \nTotal Space:- ${filesize(totalspace)}'),
                      Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(right: 7),
                        child: tab != 0
                            ? OutlineButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                color: Colors.teal,
                                borderSide: BorderSide(
                                    color: Colors.teal,
                                    style: BorderStyle.solid),
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
                              onPressed: !loadingsubmit
                                  ? () async {
                                      await getUserPreferences()
                                          .then((user) async {
                                        await getTokenPreferences()
                                            .then((token) async {
                                          await getCurrentUserProjects(token)
                                              .then((project) {
                                            if (project.length <=
                                                user.noOfProject) {
                                              _handlesubmit(project.length);
                                            } else {
                                              _handleAlertProject();
                                            }
                                          });
                                        });
                                      });
                                    }
                                  : null,
                              child: !loadingsubmit
                                  ? Text(
                                      'Submit',
                                      style: TextStyle(color: Colors.white),
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: CircularProgressIndicator(
                                        backgroundColor: Colors.teal,
                                        valueColor: AlwaysStoppedAnimation(
                                          Colors.white,
                                        ),
                                      )),
                            ),
                    ],
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text(
                          'Unselected Size:- ${filesize(unselectedSpace)} \nTotal Space:- ${filesize(totalspace - (totalspace - unselectedSpace))}'),
                      Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(right: 7),
                        child: tab != 0
                            ? OutlineButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                color: Colors.teal,
                                borderSide: BorderSide(
                                    color: Colors.teal,
                                    style: BorderStyle.solid),
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
                              color: Colors.red,
                              onPressed: () {
                                _handleSelectorBuy();
                              },
                              child: Text(
                                'BUY',
                                style: TextStyle(color: Colors.white),
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
