import 'dart:convert';
import 'package:fproject/DashBoard/models.dart';
import 'package:fproject/DashBoard/postView.dart';
import 'package:fproject/project/components/api_response.dart';
import 'package:http/http.dart' as http;
import 'package:filesize/filesize.dart';
import 'package:flutter/material.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fproject/Album/components/model.dart';
import 'package:fproject/DashBoard/Drawer.dart';
import 'package:fproject/Team/model.dart';
import 'package:fproject/Forum/components/api_response.dart';
import 'package:fproject/gettoken.dart';
import 'package:fproject/project/components/Owner/members.dart';
import 'package:fproject/setting/components/plans.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'addpost.dart';
import 'api_response.dart';

class MenuDashboardPage extends StatefulWidget {
  MenuDashboardPage({Key key}) : super(key: key);

  @override
  _MenuDashboardPageState createState() => _MenuDashboardPageState();
}

class _MenuDashboardPageState extends State<MenuDashboardPage> {
  int seeMore = 0;
  String teamName = '';
  bool seeMoreShow = true;
  String username = '';
  bool loading = false;
  int totalstorage = 0;
  int cloudStorage = 0;
  double price = 0.0;
  String type = '';
  int noOfProject = 0;
  var posts = <PostModel>[];
  int projectCount = 0;
  List<UserModel> teamMembers;
  List<UserModel> allUsers;
  int $infin = 0x221E;
  var users = <String>[];
  bool addPost = false;
  String txnDate;
  String duration;
  bool selected = false;
  bool postLoading = false;
  bool memberLoading = false;

  void handlePost(PostModel data) {
    final update1 = posts.where((element) => element.id != data.id).toList();
    final update2 = [...update1, data]..sort((a, b) => b.id.compareTo(a.id));
    setState(() {
      posts = update2;
    });
  }

  void handlePost1(int id) {
    setState(() {
      posts = posts.where((element) => element.id != id).toList();
    });
    Navigator.pop(context);
  }

  void handleAddPost(PostModel value) {
    setState(() {
      posts = [...posts, value]..sort((a, b) => b.id.compareTo(a.id));
    });
    Navigator.pop(context);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.setState(() {
      loading = true;
      memberLoading = true;
      postLoading = true;
    });
    getUserPreferences().then((value) async {
      if (!mounted) return;
      this.setState(() {
        teamName = value.teamName;
        username = value.username;
        totalstorage = value.totalStorage;
        price = value.price;
        type = value.type;
        duration = value.duration;
        noOfProject = value.noOfProject;
        projectCount = value.projectCount;
        cloudStorage = value.cloudStorage;
        txnDate = value.txnDate;
        duration = value.duration;
        selected = value.selected;
        loading = false;
      });

      await getTokenPreferences().then((token) async {
        await getUserPreferences().then((users) async {
          if (users.projectCount > users.noOfProject) {
            await updateSelectorOn(token);
            if (!mounted) return;
            this.setState(() {
              selected = true;
            });
          }
        });

        await getCurrentUserProjects(token).then((project) async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setInt('projectCount', project.length);
        });
        final validity = (duration == 'Month'
            ? (29 - DateTime.now().difference(DateTime.parse(txnDate)).inDays)
            : (364 -
                DateTime.now().difference(DateTime.parse(txnDate)).inDays));
        if (selected == false && duration != 'Free' && validity <= -1) {
          // update the transaction subs plan
          await updateSubsPlan(token, username).then((value) async {
            if (!mounted) return;
            this.setState(() {
              duration = 'Free';
              price = 0;
              type = 'Free';
              txnDate = DateTime.now().toString();
              cloudStorage = 209715200;
              noOfProject = 1;
            });
            getUserPreferences().then((users) async {
              if (totalstorage > users.cloudStorage) {
                await updateSelectorOn(token);
                if (!mounted) return;
                this.setState(() {
                  selected = true;
                });
              }
            });
          });
        }

        await getAllUsersData(token).then((value1) {
          for (var item in value1) {
            if (item.profile.teamName == value.teamName) {
              if (users.indexOf(item.username) == -1) {
                users.add(item.username);
              }
            }
          }
          if (!mounted) return;
          setState(() {
            allUsers = value1;
            teamMembers = value1
                .where((element) => element.profile.teamName == value.teamName)
                .toList();
            memberLoading = false;
          });
        });
        await getPosts(token).then((value1) {
          final finaldata = value1
              .where((element) => users.indexOf(element.user) != -1)
              .toList()
                ..sort((a, b) => b.id.compareTo(a.id));
          if (finaldata.length <= 4) {
            if (!mounted) return;
            setState(() {
              seeMore = finaldata.length;
              seeMoreShow = false;
              posts = finaldata;
              postLoading = false;
            });
          } else {
            if (!mounted) return;
            setState(() {
              seeMore = 4;

              posts = finaldata;
              postLoading = false;
            });
          }
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double storage =
        ((totalstorage.toDouble() * 100) / cloudStorage.toDouble());
    double project = ((projectCount.toDouble() * 100) / noOfProject.toDouble());
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[
                Colors.teal[500],
                Colors.teal[800],
              ])),
        ),
        title: Text('DashBoard'),
      ),
      backgroundColor: Colors.white,
      drawer: Drawer(
        child: SingleChildScrollView(
            scrollDirection: Axis.horizontal, child: MyDrawer()),
      ),
      body: WillPopScope(
        onWillPop: onWillPop,
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Stack(children: [
                  Container(
                    height: 150,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.teal[500],
                          Colors.teal[800],
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.teal[100],
                            blurRadius: 20.0,
                            offset: Offset(0, 10))
                      ],
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(70),
                          bottomRight: Radius.elliptical(100, 10)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: ListTile(
                      title: !loading
                          ? Text(
                              type.capitalize(),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Pacifico',
                                  fontSize: 20),
                            )
                          : Text('loading'),
                    ),
                  ),
                  loading == false
                      ? Padding(
                          padding: const EdgeInsets.fromLTRB(16, 40, 16, 20),
                          child: Container(
                            height: 230,
                            alignment: Alignment.topCenter,
                            width: MediaQuery.of(context).size.width,
                            child: Card(
                              elevation: 6,
                              color: Colors.grey[100],
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: !loading
                                              ? Text(
                                                  username.capitalize(),
                                                  textAlign: TextAlign.left,
                                                )
                                              : Text('loading')),
                                    ),
                                    Row(
                                      children: [
                                        Spacer(),
                                        Column(
                                          children: [
                                            AnimatedCircularChart(
                                              duration:
                                                  Duration(milliseconds: 1500),
                                              size: const Size(100.0, 100.0),
                                              initialChartData: <
                                                  CircularStackEntry>[
                                                CircularStackEntry(
                                                  <CircularSegmentEntry>[
                                                    CircularSegmentEntry(
                                                      storage,
                                                      Colors.teal[800],
                                                      rankKey: 'completed',
                                                    ),
                                                    CircularSegmentEntry(
                                                      100.0 - storage,
                                                      Colors.white,
                                                      rankKey: 'remaining',
                                                    ),
                                                  ],
                                                  rankKey: 'progress',
                                                ),
                                              ],
                                              chartType:
                                                  CircularChartType.Radial,
                                              percentageValues: true,
                                              holeRadius: 30,
                                              holeLabel: (filesize(totalstorage)
                                                          .contains('.')
                                                      ? filesize(totalstorage)
                                                          .split('.')
                                                          .first
                                                      : filesize(totalstorage)
                                                          .split(' ')
                                                          .first) +
                                                  '\n' +
                                                  filesize(totalstorage)
                                                      .split(' ')
                                                      .last,
                                              labelStyle: new TextStyle(
                                                color: Colors.teal[800],
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15.0,
                                              ),
                                            ),
                                            Text('Storage')
                                          ],
                                        ),
                                        Spacer(),
                                        Column(
                                          children: [
                                            AnimatedCircularChart(
                                              duration:
                                                  Duration(milliseconds: 1500),
                                              size: const Size(100.0, 100.0),
                                              initialChartData: <
                                                  CircularStackEntry>[
                                                new CircularStackEntry(
                                                  <CircularSegmentEntry>[
                                                    new CircularSegmentEntry(
                                                      (duration == 'Month'
                                                          ? (((29 -
                                                                      DateTime.now()
                                                                          .difference(DateTime.parse(
                                                                              txnDate))
                                                                          .inDays
                                                                          .toDouble()) *
                                                                  100.0) /
                                                              30.0)
                                                          : duration == 'Year'
                                                              ? (((364 -
                                                                          DateTime.now()
                                                                              .difference(DateTime.parse(txnDate))
                                                                              .inDays
                                                                              .toDouble()) *
                                                                      100.0) /
                                                                  365)
                                                              : 100.0),
                                                      Colors.teal[800],
                                                      rankKey: 'completed',
                                                    ),
                                                    new CircularSegmentEntry(
                                                      (duration == 'Month'
                                                          ? (100.0 -
                                                              (((29 - DateTime.now().difference(DateTime.parse(txnDate)).inDays.toDouble()) *
                                                                      100.0) /
                                                                  30.0))
                                                          : duration == 'Year'
                                                              ? (100.0 -
                                                                  (((364 - DateTime.now().difference(DateTime.parse(txnDate)).inDays.toDouble()) *
                                                                          100.0) /
                                                                      365))
                                                              : 100.0),
                                                      Colors.white,
                                                      rankKey: 'remaining',
                                                    ),
                                                  ],
                                                  rankKey: 'progress',
                                                ),
                                              ],
                                              chartType:
                                                  CircularChartType.Radial,
                                              percentageValues: true,
                                              holeRadius: 30,
                                              holeLabel: (duration == 'Month'
                                                  ? '0' +
                                                      (29 -
                                                              DateTime.now()
                                                                  .difference(
                                                                      DateTime.parse(
                                                                          txnDate))
                                                                  .inDays)
                                                          .toString() +
                                                      '\nLeft'
                                                  : duration == 'Year'
                                                      ? (364 -
                                                                  DateTime.now()
                                                                      .difference(
                                                                          DateTime.parse(
                                                                              txnDate))
                                                                      .inDays)
                                                              .toString() +
                                                          '\nLeft'
                                                      : String.fromCharCode(
                                                          $infin)),
                                              labelStyle: new TextStyle(
                                                color: Colors.teal[800],
                                                fontWeight: FontWeight.bold,
                                                fontSize: duration == 'Free'
                                                    ? 25.0
                                                    : 15.0,
                                              ),
                                            ),
                                            Text('Validity')
                                          ],
                                        ),
                                        Spacer(),
                                        Column(
                                          children: [
                                            AnimatedCircularChart(
                                              duration:
                                                  Duration(milliseconds: 1500),
                                              size: const Size(100.0, 100.0),
                                              initialChartData: <
                                                  CircularStackEntry>[
                                                new CircularStackEntry(
                                                  <CircularSegmentEntry>[
                                                    new CircularSegmentEntry(
                                                      project,
                                                      Colors.teal[800],
                                                      rankKey: 'completed',
                                                    ),
                                                    new CircularSegmentEntry(
                                                      (100.0 - project),
                                                      Colors.white,
                                                      rankKey: 'remaining',
                                                    ),
                                                  ],
                                                  rankKey: 'progress',
                                                ),
                                              ],
                                              chartType:
                                                  CircularChartType.Radial,
                                              percentageValues: true,
                                              holeRadius: 30,
                                              holeLabel:
                                                  projectCount.toString(),
                                              labelStyle: new TextStyle(
                                                color: Colors.teal[800],
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15.0,
                                              ),
                                            ),
                                            Text("Project's")
                                          ],
                                        ),
                                        Spacer(),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    ButtonTheme(
                                      minWidth:
                                          MediaQuery.of(context).size.width *
                                              0.60,
                                      child: RaisedButton(
                                        color: Colors.teal[700],
                                        onPressed: () {
                                          Navigator.push(context,
                                              MaterialPageRoute(
                                            builder: (context) {
                                              return Plans();
                                            },
                                          ));
                                        },
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        child: Text(
                                          'Upgrade Plan',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
                          child: Container(
                            height: 230,
                            alignment: Alignment.topCenter,
                            width: MediaQuery.of(context).size.width,
                            child: Card(
                              elevation: 6,
                              color: Colors.grey[100],
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: !loading
                                              ? Text(
                                                  username.capitalize(),
                                                  textAlign: TextAlign.left,
                                                )
                                              : Text('loading')),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    ButtonTheme(
                                      minWidth:
                                          MediaQuery.of(context).size.width *
                                              0.60,
                                      child: RaisedButton(
                                        color: Colors.red,
                                        onPressed: () {
                                          Navigator.push(context,
                                              MaterialPageRoute(
                                            builder: (context) {
                                              return Plans();
                                            },
                                          ));
                                        },
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        child: Text(
                                          'Upgrade Plan',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                ]),
                SizedBox(
                  height: 20,
                ),
                Divider(
                  thickness: 10,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: teamName != 'default_team_name'
                        ? Text(
                            'Team Members',
                            textAlign: TextAlign.start,
                            style: TextStyle(fontSize: 20),
                          )
                        : Text(
                            'Create Team',
                            textAlign: TextAlign.start,
                            style: TextStyle(fontSize: 20),
                          ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: !memberLoading
                        ? teamName != 'default_team_name'
                            ? SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                    children: teamMembers != null
                                        ? teamMembers.map((UserModel user) {
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Container(
                                                width: 80,
                                                height: 80,
                                                child: Material(
                                                  elevation: 4.0,
                                                  shape: CircleBorder(),
                                                  clipBehavior: Clip.hardEdge,
                                                  color: Colors.grey[200],
                                                  child: Ink.image(
                                                    image: NetworkImage(
                                                        user.image.image),
                                                    fit: BoxFit.cover,
                                                    width: 40.0,
                                                    height: 40.0,
                                                    child: InkWell(
                                                      onTap: () async {
                                                        Navigator.push(context,
                                                            MaterialPageRoute(
                                                          builder: (context) {
                                                            return UserView(
                                                              data: user,
                                                              projectCount:
                                                                  teamMembers
                                                                      .length,
                                                            );
                                                          },
                                                        ));
                                                      },
                                                    ),
                                                  ),
                                                ),
                                                decoration: BoxDecoration(
                                                  color: Colors.red,
                                                  border: Border.all(
                                                      width: 5,
                                                      color: Colors.white70),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          100),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.grey[400],
                                                      blurRadius:
                                                          8.0, // soften the shadow
                                                      spreadRadius: 3.0,
                                                    )
                                                  ],
                                                ),
                                              ),
                                            );
                                          }).toList()
                                        : []),
                              )
                            : Padding(
                                padding: const EdgeInsets.all(20),
                                child: RaisedButton.icon(
                                    elevation: 8,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    color: Colors.teal,
                                    onPressed: () {
                                      Navigator.popAndPushNamed(
                                          context, '/team');
                                    },
                                    icon: Icon(
                                      Icons.add,
                                      color: Colors.white,
                                    ),
                                    label: Text(
                                      'Create',
                                      style: TextStyle(color: Colors.white),
                                    )),
                              )
                        : Center(
                            child: SpinKitThreeBounce(
                              color: Colors.teal,
                              size: 25,
                            ),
                          ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Divider(
                  thickness: 10,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10, top: 5),
                    child: Row(
                      children: [
                        Text(
                          "Post's",
                          textAlign: TextAlign.start,
                          style: TextStyle(fontSize: 20),
                        ),
                        Spacer(),
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: RaisedButton.icon(
                              elevation: 8,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              color: Colors.teal,
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(
                                  builder: (context) {
                                    return AddPosts(
                                        handleAddPost: handleAddPost);
                                  },
                                ));
                              },
                              icon: Icon(
                                Icons.add,
                                color: Colors.white,
                              ),
                              label: Text(
                                'ADD',
                                style: TextStyle(color: Colors.white),
                              )),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                    width: MediaQuery.of(context).size.width,
                    height: 200,
                    child: !postLoading
                        ? posts != null
                            ? posts.length > 0
                                ? SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: [
                                        Row(
                                          children: posts != null
                                              ? posts
                                                  .sublist(0, seeMore)
                                                  .map((PostModel post) {
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        Navigator.push(context,
                                                            MaterialPageRoute(
                                                          builder: (context) {
                                                            return PostView(
                                                                post: post,
                                                                allUsers:
                                                                    allUsers,
                                                                handlePost1:
                                                                    handlePost1,
                                                                handlePost:
                                                                    handlePost);
                                                          },
                                                        ));
                                                      },
                                                      child: Card(
                                                        elevation: 8,
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20)),
                                                        child: Container(
                                                            height: 150,
                                                            width: 200,
                                                            decoration: post
                                                                        .img !=
                                                                    null
                                                                ? BoxDecoration(
                                                                    color: Colors
                                                                        .white,
                                                                    image:
                                                                        DecorationImage(
                                                                      image: NetworkImage(
                                                                          post.img),
                                                                      fit: BoxFit
                                                                          .cover,
                                                                    ),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            20),
                                                                  )
                                                                : BoxDecoration(
                                                                    color: Colors
                                                                        .white,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            20)),
                                                            child: post.content !=
                                                                    null
                                                                ? post.img !=
                                                                        null
                                                                    ? Container()
                                                                    : Center(
                                                                        child:
                                                                            Container(
                                                                          child:
                                                                              Text(post.content),
                                                                        ),
                                                                      )
                                                                : Container()),
                                                      ),
                                                    ),
                                                  );
                                                }).toList()
                                              : [],
                                        ),
                                        seeMoreShow
                                            ? Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    if (seeMore + 4 <=
                                                        posts.length) {
                                                      setState(() {
                                                        seeMore = seeMore + 4;
                                                      });
                                                    } else {
                                                      setState(() {
                                                        seeMore = posts.length;
                                                        seeMoreShow = false;
                                                      });
                                                    }
                                                  },
                                                  child: Text(
                                                    'See More ->',
                                                    style: TextStyle(
                                                        color: Colors.blue),
                                                  ),
                                                ),
                                              )
                                            : Container(),
                                      ],
                                    ),
                                  )
                                : Center(
                                    child: Text(
                                      'No Posts Added',
                                      style: TextStyle(color: Colors.blue),
                                    ),
                                  )
                            : null
                        : SpinKitThreeBounce(
                            color: Colors.teal,
                            size: 25,
                          ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class UserView extends StatefulWidget {
  UserModel data;
  int projectCount = 0;
  UserView({Key key, this.data, this.projectCount}) : super(key: key);

  @override
  _UserViewState createState() => _UserViewState();
}

class _UserViewState extends State<UserView> {
  var userImages = <Imagelist>[];
  bool loadingImagesAll = false;

  Future<List<Imagelist>> getUserImages1(String token, String username) async {
    var finaldata = <Imagelist>[];
    await http.get(
        Uri.encodeFull(
            'https://abhishekpraja.pythonanywhere.com/imagelistall/'),
        headers: {
          "Accept": 'application/json',
          "Authorization": 'Token ' + token,
        }).then((value) {
      if (value.statusCode == 200) {
        for (var item in jsonDecode(value.body)) {
          if (item['user'] == username) {
            final data = Imagelist(
                id: item['id'],
                user: item['user'],
                albumId: item['album_id'],
                src: item['src'],
                thumbnail: item['thumbnail'],
                thumbnailWidth: item['thumbnailWidth'],
                thumbnailHeight: item['thumbnailHeight'],
                caption: item['caption'],
                selected: item['selected'],
                size: item['size'],
                favourite: item['favourite']);
            finaldata.add(data);
          }
        }
      }
    });
    return finaldata;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.setState(() {
      loadingImagesAll = true;
    });
    getTokenPreferences().then((token) async {
      await getUserImages1(token, widget.data.username).then((value) {
        this.setState(() {
          userImages = value;
          loadingImagesAll = false;
        });
      });
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
                                widget.data.profile.backgroundImage),
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
                          image: NetworkImage(widget.data.image.image),
                          fit: BoxFit.cover,
                          width: 120.0,
                          height: 120.0,
                          child: InkWell(
                            onTap: () async {
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) {
                                  return ProfileImageView(
                                    data: widget.data,
                                  );
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
                        widget.data.username.capitalize(),
                        style: TextStyle(
                            fontSize: 26, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Text(
                        widget.data.profile.aboutMe,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.normal),
                      ),
                    ),
                    Padding(
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
                                Text(widget.data.profile.teamName.toUpperCase())
                              ],
                            ),
                            Spacer(),
                            Column(
                              children: [
                                FlatButton.icon(
                                    onPressed: () {},
                                    icon: Icon(FontAwesomeIcons.users),
                                    label: Text('Members')),
                                Text(widget.projectCount.toString())
                              ],
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
    );
  }
}
