import 'package:filesize/filesize.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fproject/DashBoard/Drawer.dart';
import 'package:fproject/DashBoard/api_response.dart';
import 'package:fproject/DashBoard/models.dart';
import 'package:fproject/Team/api_response.dart';
import 'package:fproject/Team/model.dart';
import 'package:fproject/gettoken.dart';
import 'package:fproject/project/components/models.dart';
import 'package:fproject/project/components/project.dart';
import 'package:fproject/project/components/teamprojectlist.dart';
import 'package:fproject/setting/components/plans.dart';
import 'components/api_response.dart';
import 'package:intl/intl.dart';

import 'components/createproject.dart';

class ProjectMain extends StatefulWidget {
  ProjectMain({Key key}) : super(key: key);

  @override
  _ProjectMainState createState() => _ProjectMainState();
}

class _ProjectMainState extends State<ProjectMain> {
  List<ProjectModel> currentUserProjects;
  bool initialLoading = false;
  UserModel currentUser;
  List<UserModel> allUser;
  String token = '';
  List<ProjectInvoice> invites;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.setState(() {
      initialLoading = true;
    });
    getTokenPreferences().then(_updateToken);
  }

  _updateToken(String token) async {
    this.setState(() {
      token = token;
    });
    await getCurrentUser(token).then((value) {
      this.setState(() {
        currentUser = value;
      });
    });
    await getCurrentUserProjects(token).then((value) {
      this.setState(() {
        currentUserProjects = value;
      });
    });
    await getAllProjectInvitesAll(token).then((value) {
      this.setState(() {
        invites = value;
      });
    });
    await getAllUsersData(token).then((value2) {
      this.setState(() {
        allUser = value2
            .where((element) =>
                element.profile.teamName == currentUser.profile.teamName)
            .toList();
        initialLoading = false;
      });
    });
  }

  _handleCreateCheck() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text("Alert", style: TextStyle(color: Colors.red)),
            content: Text(
                "Maximum Project Create Limit Exceeded. Upgrade your Plan for more Project."),
            actions: [
              CupertinoDialogAction(
                child: Text('No'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              CupertinoDialogAction(
                child: Text('Upgrade'),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return Plans();
                    },
                  ));
                },
              ),
            ],
          );
        });
  }

  handleProjectData(ProjectModel data) {
    List<ProjectModel> currentReplace =
        currentUserProjects.where((element) => element.id != data.id).toList();
    setState(() {
      currentUserProjects = [...currentReplace, data]
        ..sort((a, b) => b.id.compareTo(a.id));
    });
  }

  handleProject(ProjectModel data) {
    setState(() {
      currentUserProjects = [...currentUserProjects, data]
        ..sort((a, b) => b.id.compareTo(a.id));
    });
    Navigator.pop(context);
  }

  handleInvites(ProjectInvoice data) {
    setState(() {
      invites = [...invites, data];
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: MyRoute,
        theme: ThemeData(
            accentColor: Colors.teal,
            canvasColor: Colors.transparent,
            fontFamily: 'CrimsonTextRegular'),
        home: Scaffold(
          backgroundColor: Colors.grey[200],
          drawer: MyDrawer(),
          appBar: AppBar(
            title: Text(
              "Project's",
              style: TextStyle(
                  fontFamily: 'CrimsonTextRegular',
                  fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
            backgroundColor: Colors.teal,
          ),
          body: !initialLoading
              ? WillPopScope(
                  onWillPop: onWillPop,
                  child: currentUserProjects.length > 0
                      ? SingleChildScrollView(
                          child: Container(
                            child: _buildPanel(),
                          ),
                        )
                      : Center(
                          child: Text(
                            'No Projects',
                            style: TextStyle(
                                fontFamily: 'CrimsonTextRegular',
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                )
              : Center(
                  child: SpinKitFoldingCube(color: Colors.teal),
                ),
          floatingActionButton: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: FloatingActionButton(
                    heroTag: 'ProjectTeam',
                    backgroundColor: Colors.teal,
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return ProjectListTeam(
                              invites: invites,
                              handleInvites: handleInvites,
                              currentUserProjects: currentUserProjects);
                        },
                      ));
                    },
                    child: Icon(
                      Icons.person_add,
                      size: 25,
                    ),
                  ),
                ),
                FloatingActionButton(
                  heroTag: 'createProject',
                  backgroundColor: Colors.teal,
                  onPressed: () {
                    getUserPreferences().then((user) {
                      if (user.projectCount >= user.noOfProject) {
                        _handleCreateCheck();
                      } else {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return CreateProject(handleProject: handleProject);
                          },
                        ));
                      }
                    });
                  },
                  child: Icon(
                    Icons.add,
                    size: 25,
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Widget _buildPanel() {
    return ExpansionPanelList(
      dividerColor: Colors.black,
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          currentUserProjects[index].isExpanded = !isExpanded;
        });
      },
      children: currentUserProjects.map<ExpansionPanel>((ProjectModel item) {
        return ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return ProjectMenu(
                          token: token,
                          allUser: allUser,
                          handleProjectData: handleProjectData,
                          currentUserProjects: item,
                          currentUserData: currentUser);
                    },
                  ));
                },
                title: !isExpanded
                    ? Text(item.projectName.toUpperCase(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: 'CrimsonTextRegular',
                        ))
                    : Text(
                        item.projectName.toUpperCase(),
                        style: TextStyle(
                            fontSize: 27,
                            fontFamily: 'CrimsonTextRegular',
                            fontWeight: FontWeight.bold),
                      ),
                trailing: !isExpanded
                    ? null
                    : currentUser.username == item.username
                        ? IconButton(
                            icon: Icon(FontAwesomeIcons.trash),
                            onPressed: () {},
                          )
                        : null);
          },
          body: Container(
            child: Column(
              children: [
                Container(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.grey[400],
                          borderRadius: BorderRadius.circular(15)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                child: Row(children: [
                                  Text(
                                    'Start Date',
                                    style: TextStyle(
                                        fontSize: 25,
                                        fontFamily: 'CrimsonTextRegular',
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Spacer(),
                                  Text(
                                      DateFormat('yyyy/MM/dd').format(
                                          DateTime.parse(item.startDate)),
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontFamily: 'CrimsonTextRegular',
                                      )),
                                ]),
                              ),
                            ),
                            Divider(
                              color: Colors.white,
                              thickness: 1,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                child: Row(children: [
                                  Text(
                                    'DeadLine',
                                    style: TextStyle(
                                        fontSize: 25,
                                        fontFamily: 'CrimsonTextRegular',
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Spacer(),
                                  Text(
                                      (DateFormat('yyyy/MM/dd').format(
                                          DateTime.parse(item.endDate))),
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontFamily: 'CrimsonTextRegular',
                                      )),
                                ]),
                              ),
                            ),
                            Divider(
                              color: Colors.white,
                              thickness: 1,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                child: Row(children: [
                                  Text(
                                    'Main Application',
                                    style: TextStyle(
                                        fontSize: 25,
                                        fontFamily: 'CrimsonTextRegular',
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Spacer(),
                                  Text(item.mainApplication,
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontFamily: 'CrimsonTextRegular',
                                      ))
                                ]),
                              ),
                            ),
                            Divider(
                              color: Colors.white,
                              thickness: 1,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                child: Row(children: [
                                  Text(
                                    'Project Type',
                                    style: TextStyle(
                                        fontSize: 25,
                                        fontFamily: 'CrimsonTextRegular',
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Spacer(),
                                  Text(item.preferenece,
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontFamily: 'CrimsonTextRegular',
                                      )),
                                ]),
                              ),
                            ),
                            Divider(
                              color: Colors.white,
                              thickness: 1,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                child: Row(children: [
                                  Text(
                                    'Status',
                                    style: TextStyle(
                                      fontFamily: 'CrimsonTextRegular',
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Spacer(),
                                  Text(item.status,
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontFamily: 'CrimsonTextRegular',
                                      )),
                                ]),
                              ),
                            ),
                            Divider(
                              color: Colors.white,
                              thickness: 1,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                child: Row(children: [
                                  Text(
                                    'Storage',
                                    style: TextStyle(
                                        fontSize: 25,
                                        fontFamily: 'CrimsonTextRegular',
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Spacer(),
                                  Text(filesize(item.projectSize.toString()),
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontFamily: 'CrimsonTextRegular',
                                      )),
                                ]),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.teal,
                        borderRadius: BorderRadius.circular(15)),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8, 15, 8, 15),
                      child: Container(
                        child: Row(children: [
                          Text(
                            item.preferenece == 'Team' ? 'Members' : 'Private',
                            style: TextStyle(
                                fontSize: 25,
                                fontFamily: 'CrimsonTextRegular',
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          Spacer(),
                          item.preferenece == 'Team'
                              ? Text(item.promemCount.toString(),
                                  style: TextStyle(
                                      fontFamily: 'CrimsonTextRegular',
                                      fontSize: 20,
                                      color: Colors.white))
                              : Container(),
                        ]),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          isExpanded: item.isExpanded,
        );
      }).toList(),
    );
  }
}
