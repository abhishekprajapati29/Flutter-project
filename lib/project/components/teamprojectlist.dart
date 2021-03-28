import 'package:filesize/filesize.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fproject/DashBoard/models.dart';
import 'package:fproject/gettoken.dart';
import 'package:fproject/project/components/api_response.dart';
import 'package:fproject/project/components/models.dart';
import 'package:fproject/project/components/teamprojectsoverview.dart';
import 'package:intl/intl.dart';

class ProjectListTeam extends StatefulWidget {
  List<ProjectModel> currentUserProjects;
  Function handleInvites;
  List<ProjectInvoice> invites;
  ProjectListTeam(
      {Key key, this.currentUserProjects, this.handleInvites, this.invites})
      : super(key: key);

  @override
  _ProjectListTeamState createState() => _ProjectListTeamState();
}

class _ProjectListTeamState extends State<ProjectListTeam> {
  var projectListTeam = <ProjectModel>[];
  String username = '';
  bool initLoading = false;
  var projectId = <int>[];
  List<ProjectInvoice> invites;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      initLoading = true;
      invites = widget.invites;
    });
    for (var item in widget.currentUserProjects) {
      projectId.add(item.id);
    }
    getUserPreferences().then((user) {
      setState(() {
        username = user.username;
      });
    });
    getTokenPreferences().then((token) async {
      await teamProjectList(token).then((value) {
        setState(() {
          projectListTeam = value
              .where((element) => projectId.indexOf(element.id) == -1)
              .toList();
          initLoading = false;
        });
      });
    });
  }

  handleInvites1(ProjectInvoice data) {
    setState(() {
      invites = [...invites, data];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          title: Text("Team Project's List"),
          centerTitle: true,
          backgroundColor: Colors.teal,
        ),
        body: !initLoading
            ? projectListTeam.length > 0
                ? SingleChildScrollView(
                    child: Container(
                      child: _buildPanel(),
                    ),
                  )
                : Center(child: Text('No Projects'))
            : Center(
                child: SpinKitFoldingCube(color: Colors.teal),
              ));
  }

  Widget _buildPanel() {
    return ExpansionPanelList(
      dividerColor: Colors.black,
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          projectListTeam[index].isExpanded = !isExpanded;
        });
      },
      children: projectListTeam.map<ExpansionPanel>((ProjectModel item) {
        return ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return TeamProjectOverview(
                          handleInvites: widget.handleInvites,
                          handleInvites1: handleInvites1,
                          projectOverview: item,
                          invites: invites);
                    },
                  ));
                },
                title: !isExpanded
                    ? Text(item.projectName.toUpperCase())
                    : Text(
                        item.projectName.toUpperCase(),
                        style: TextStyle(
                            fontSize: 27, fontWeight: FontWeight.bold),
                      ),
                trailing: !isExpanded
                    ? null
                    : username == item.username
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
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Spacer(),
                                  Text(
                                      DateFormat('yyyy/MM/dd').format(
                                          DateTime.parse(item.startDate)),
                                      style: TextStyle(fontSize: 20)),
                                ]),
                              ),
                            ),
                            Divider(
                              color: Colors.white,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                child: Row(children: [
                                  Text(
                                    'DeadLine',
                                    style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Spacer(),
                                  Text(
                                      (DateFormat('yyyy/MM/dd').format(
                                          DateTime.parse(item.endDate))),
                                      style: TextStyle(fontSize: 20)),
                                ]),
                              ),
                            ),
                            Divider(
                              color: Colors.white,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                child: Row(children: [
                                  Text(
                                    'Main Application',
                                    style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Spacer(),
                                  Text(
                                    item.mainApplication,
                                    style: TextStyle(fontSize: 20),
                                  )
                                ]),
                              ),
                            ),
                            Divider(
                              color: Colors.white,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                child: Row(children: [
                                  Text(
                                    'Project Type',
                                    style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Spacer(),
                                  Text(item.preferenece,
                                      style: TextStyle(fontSize: 20)),
                                ]),
                              ),
                            ),
                            Divider(
                              color: Colors.white,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                child: Row(children: [
                                  Text(
                                    'Status',
                                    style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Spacer(),
                                  Text(item.status,
                                      style: TextStyle(fontSize: 20)),
                                ]),
                              ),
                            ),
                            Divider(
                              color: Colors.white,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                child: Row(children: [
                                  Text(
                                    'Storage',
                                    style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Spacer(),
                                  Text(filesize(item.projectSize.toString()),
                                      style: TextStyle(fontSize: 20)),
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
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          Spacer(),
                          item.preferenece == 'Team'
                              ? Text(item.promemCount.toString(),
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.white))
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
