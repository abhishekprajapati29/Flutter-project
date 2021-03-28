import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fproject/DashBoard/Drawer.dart';
import 'package:fproject/Team/addMember.dart';
import 'package:fproject/Team/model.dart';
import 'package:fproject/Team/users.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Invoices.dart';
import 'plan.dart' as plandetail;
import '../gettoken.dart';
import 'api_response.dart';

class TeamMain extends StatefulWidget {
  TeamMain({Key key}) : super(key: key);

  @override
  _TeamMainState createState() => _TeamMainState();
}

class _TeamMainState extends State<TeamMain> {
  int selectedIndex = 0;
  bool largeView = true;
  int moveToIndex = 0;
  bool search = false;
  int startSliceValue = 0;
  int endSliceValue = 0;
  int sliceValue = 0;
  List<UserModel> _teamMembers = [];
  List<UserModel> allUsersData = [];
  int dropdownValue = 0;
  bool initalLoading = false;
  TextEditingController searchText = new TextEditingController();
  String _token = '';
  String teamName = '';
  String username = '';
  UserModel currentUserData;
  SubModel currentUserSubPlan;
  var allSubsPlan = <AllPlanModel>[];
  var invoiceData = <InoviceModel>[];
  var invoiceData1 = <InoviceModel>[];

  @override
  void initState() {
    super.initState();
    setState(() {
      initalLoading = true;
    });
    getTokenPreferences().then(_updateToken);
  }

  updateInvoice(InoviceModel data) {
    this.setState(() {
      invoiceData = [...invoiceData, data];
    });
  }

  teamNameUpdate(String name) {
    this.setState(() {
      teamName = name;
    });
  }

  updateInvoice12(InoviceModel data) async {
    await getInvoice().then((value) {
      invoiceData1 = value
          .where((element) => element.requestedBy == currentUserData.id)
          .toList();
    });
  }

  _updateToken(String token) async {
    setState(() {
      this._token = token;
    });
    await getCurrentUser(token).then(_updateData);
    await getAllUsersData(token).then((value) {
      print('allUsers = ${value.length}');
      this.setState(() {
        allUsersData = value;
      });
    });
    await getInvoice().then((value) {
      print('allUsers = ${value.length}');
      final data =
          value.where((element) => element.user == currentUserData.id).toList();
      this.setState(() {
        invoiceData = data;
        invoiceData1 = value
            .where((element) => element.requestedBy == currentUserData.id)
            .toList();
        initalLoading = false;
      });
    });
  }

  loadingChange() {
    this.setState(() {
      initalLoading = !initalLoading;
    });
  }

  handleAcceptInvite() {
    setState(() {
      initalLoading = true;
    });
    getTokenPreferences().then(_updateToken);
    Navigator.pop(context);
  }

  updateInvoice2(InoviceModel value) {
    this.setState(() {
      invoiceData1 = [...invoiceData1, value];
    });
  }

  updateCurrentUser(UserModel data) {
    this.setState(() {
      currentUserData = data;
    });
    final finaldata =
        _teamMembers.where((element) => element.id != data.id).toList();

    this.setState(() {
      _teamMembers = [data, ...finaldata]..sort((a, b) => a.id.compareTo(b.id));
    });
  }

  _updateData(UserModel data) {
    this.setState(() {
      currentUserData = data;
    });
    getData(_token, data, teamName).then((value) {
      this.setState(() {
        teamName = data.profile.teamName;
        _teamMembers = value;
      });
      getPlan(_token, data.username).then((plan) {
        print(plan.amount);
        this.setState(() {
          currentUserSubPlan = plan;
        });
        final subPlanDetail = plandetail.Plan_detail;

        for (var item in subPlanDetail) {
          final data = AllPlanModel(
              price: item['price'],
              type: item['type'],
              time: item['time'],
              cloudStorage: item['cloud_storage'],
              cloudStorageValue: item['cloud_storage_value'],
              noOfProjectMembers: item['no_of_project_members'],
              noOfProjects: item['no_of_projects'],
              noOfTeamMember: item['no_of_team_member'],
              noTeam: item['no_team']);
          this.setState(() {
            allSubsPlan = [...allSubsPlan, data];
          });
        }
      });
    });
  }

  void searchUpdate() {
    setState(() {
      this.search = !search;
    });
  }

  @override
  void dispose() {
    super.dispose();
    searchText.dispose();
  }

  void clearData() {
    searchText.text = "";
  }

  _handleAlert(currentUserData) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text("Want To Leave ${currentUserData.profile.teamName}"),
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
                  await leaveTeam(currentUserData).then((_) async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    prefs.setString('teamName', 'default_team_name');
                    this.setState(() {
                      initalLoading = true;
                    });
                    await getTokenPreferences().then(_updateToken);
                  });
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    for (var item in allSubsPlan) {
      print(item.cloudStorageValue);
    }
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          accentColor: Colors.teal,
          canvasColor: Colors.transparent,
          fontFamily: 'CrimsonTextRegular'),
      routes: MyRoute,
      home: Scaffold(
        backgroundColor: Colors.grey[200],
        drawer: MyDrawer(),
        appBar: AppBar(
          backgroundColor: search ? Colors.white : Colors.teal,
          title: currentUserData != null
              ? currentUserData.profile.teamName != 'default_team_name'
                  ? Text(teamName.toUpperCase())
                  : Text("JOIN TEAM")
              : null,
          actions: [
            currentUserData != null
                ? currentUserData.profile.teamName != 'default_team_name'
                    ? Padding(
                        padding: const EdgeInsets.only(right: 4.0),
                        child: IconButton(
                            icon: Icon(FontAwesomeIcons.doorOpen),
                            tooltip: 'Leave Team',
                            onPressed: () {
                              _handleAlert(currentUserData);
                            }),
                      )
                    : Container()
                : Container()
          ],
        ),
        body: initalLoading == false
            ? WillPopScope(
                onWillPop: onWillPop,
                child: TeamMembers(
                  teamName: teamName,
                  data: _teamMembers,
                  updateCurrentUser: updateCurrentUser,
                  currentUserData: currentUserData,
                  token: _token,
                  allUsersData: allUsersData,
                  invoiceData: invoiceData,
                  invoiceData1: invoiceData1,
                  updateInvoice2: updateInvoice2,
                  updateInvoice12: updateInvoice12,
                  // searchData: _searchData,
                  // loading: initalLoading,
                  // startSliceValue: startSliceValue,
                  // endSliceValue: endSliceValue,
                  // dropdownValue: dropdownValue,
                  // updateEditData: updateEditData,
                  // updateDeleteAndData: updateDeleteAndData
                ),
              )
            : Container(
                color: Colors.white,
                height: MediaQuery.of(context).size.height,
                child: Center(
                  child: SpinKitFoldingCube(color: Colors.teal),
                ),
              ),
        floatingActionButton: currentUserData != null
            ? currentUserData.profile.teamName != 'default_team_name'
                ? Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: FloatingActionButton(
                            heroTag: "btn1",
                            onPressed: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return Invoices(
                                    token: _token,
                                    invoiceData: invoiceData,
                                    currentUserData: currentUserData,
                                    handleAcceptInvite: handleAcceptInvite,
                                    loadingChange: loadingChange);
                              }));
                            },
                            child: Icon(FontAwesomeIcons.envelopeOpenText,
                                color: Colors.white),
                            backgroundColor: Colors.teal,
                          ),
                        ),
                        FloatingActionButton(
                          heroTag: "btn2",
                          onPressed: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return AddMembers(
                                  token: _token,
                                  currentUserData: currentUserData,
                                  updateCurrentUser: updateCurrentUser,
                                  invoiceData: invoiceData,
                                  updateInvoice: updateInvoice,
                                  allUsersData: allUsersData);
                            }));
                          },
                          child:
                              Icon(FontAwesomeIcons.plus, color: Colors.white),
                          backgroundColor: Colors.teal,
                        ),
                      ],
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: FloatingActionButton(
                      heroTag: "btn1",
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return Invoices(
                              token: _token,
                              invoiceData: invoiceData,
                              currentUserData: currentUserData,
                              handleAcceptInvite: handleAcceptInvite,
                              loadingChange: loadingChange);
                        }));
                      },
                      child: Icon(FontAwesomeIcons.envelopeOpenText),
                      backgroundColor: Colors.teal,
                    ),
                  )
            : null,
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }
}
