import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fproject/Team/model.dart';
import 'package:fproject/project/components/Owner/more.dart';
import 'package:fproject/project/components/Owner/overview.dart';
import 'package:fproject/project/components/Owner/tasks%20Member.dart';
import 'package:fproject/project/components/Owner/tasks.dart';
import 'package:fproject/project/components/api_response.dart';
import 'package:fproject/project/components/models.dart';
import '../../gettoken.dart';
import 'Owner/bugs Member.dart';
import 'Owner/bugs.dart' as bug;
import 'Owner/dashboard.dart';
import 'package:intl/intl.dart';

class ProjectMenu extends StatefulWidget {
  ProjectModel currentUserProjects;
  UserModel currentUserData;
  String token;
  List<UserModel> allUser;
  Function handleProjectData;
  ProjectMenu(
      {Key key,
      this.currentUserProjects,
      this.handleProjectData,
      this.currentUserData,
      this.allUser,
      this.token})
      : super(key: key);

  @override
  _ProjectMenuState createState() => _ProjectMenuState();
}

class _ProjectMenuState extends State<ProjectMenu> {
  ProjectModel currentUserProjects;
  int selectedIndex = 2;
  bool add = false;
  bool taskAddLoading = false;
  bool bugAddLoading = false;
  TextEditingController addController = new TextEditingController();
  SingingCharacter character = SingingCharacter.Pending;
  bug.SingingCharacter bugsCharacter = bug.SingingCharacter.Pending;
  DateTime dateTime;
  String dropdownValue = 'None';
  String token = '';
  bool taskFilter = false;
  bool taskFilterMember = false;
  List<Task> memberTask = [];
  List<Task> taskFilterData = [];
  List<Task> taskFilterDataMember = [];
  bool bugFilter = false;
  bool bugFilterMember = false;
  List<Bugs> bugFilterData = [];
  List<Bugs> bugFilterDataMember = [];
  List<Bugs> memberBugs = [];
  bool initLoading = false;

  onItemTapped1(int data) {
    this.setState(() {
      selectedIndex = data;
    });
  }

  void handleAdd() {
    setState(() {
      add = true;
    });
  }

  handleDropDown(data) {
    setState(() {
      dropdownValue = data;
    });
  }

  handleCharacter(data) {
    setState(() {
      character = data;
    });
  }

  handleCharacter1(data) {
    setState(() {
      bugsCharacter = data;
    });
  }

  handleDateTime(data) {
    setState(() {
      dateTime = data;
    });
  }

  handleProjectData(ProjectModel data) {
    setState(() {
      currentUserProjects = data;
    });
  }

  allFilterTask() {
    setState(() {
      taskFilter = false;
    });
  }

  pendingFilterTask() {
    List<Task> data = currentUserProjects.task
        .where((element) => element.status == 'Pending')
        .toList();
    setState(() {
      taskFilter = true;
      taskFilterData = data;
    });
  }

  successFilterTask() {
    List<Task> data = currentUserProjects.task
        .where((element) => element.status == 'Success')
        .toList();
    setState(() {
      taskFilter = true;
      taskFilterData = data;
    });
  }

  holdFilterTask() {
    List<Task> data = currentUserProjects.task
        .where((element) => element.status == 'Hold')
        .toList();
    setState(() {
      taskFilter = true;
      taskFilterData = data;
    });
  }

  errorFilterTask() {
    List<Task> data = currentUserProjects.task
        .where((element) => element.status == 'Error')
        .toList();
    setState(() {
      taskFilter = true;
      taskFilterData = data;
    });
  }

  allFilterTaskMember() {
    List<Task> data = currentUserProjects.task
        .where(
            (element) => element.requestedTo == widget.currentUserData.username)
        .toList();
    setState(() {
      taskFilterMember = false;
      taskFilterDataMember = data;
    });
  }

  pendingFilterTaskMember() {
    List<Task> data = currentUserProjects.task
        .where((element) =>
            element.status == 'Pending' &&
            element.requestedTo == widget.currentUserData.username)
        .toList();
    setState(() {
      taskFilterMember = true;
      taskFilterDataMember = data;
    });
  }

  successFilterTaskMember() {
    List<Task> data = currentUserProjects.task
        .where((element) => element.status == 'Success')
        .toList();
    setState(() {
      taskFilterMember = true;
      taskFilterDataMember = data;
    });
  }

  holdFilterTaskMember() {
    List<Task> data = currentUserProjects.task
        .where((element) => element.status == 'Hold')
        .toList();
    setState(() {
      taskFilterMember = true;
      taskFilterDataMember = data;
    });
  }

  errorFilterTaskMember() {
    print('daerror');
    List<Task> data = currentUserProjects.task
        .where((element) => element.status == 'Error')
        .toList();
    setState(() {
      taskFilterMember = true;
      taskFilterDataMember = data;
    });
  }

  allFilterBug() {
    setState(() {
      bugFilter = false;
    });
  }

  pendingFilterBug() {
    List<Bugs> data = currentUserProjects.bugs
        .where((element) => element.status == 'Pending')
        .toList();
    setState(() {
      bugFilter = true;
      bugFilterData = data;
    });
  }

  successFilterBug() {
    List<Bugs> data = currentUserProjects.bugs
        .where((element) => element.status == 'Success')
        .toList();
    setState(() {
      bugFilter = true;
      bugFilterData = data;
    });
  }

  holdFilterBug() {
    List<Bugs> data = currentUserProjects.bugs
        .where((element) => element.status == 'Hold')
        .toList();
    setState(() {
      bugFilter = true;
      bugFilterData = data;
    });
  }

  errorFilterBug() {
    List<Bugs> data = currentUserProjects.bugs
        .where((element) => element.status == 'Error')
        .toList();
    setState(() {
      bugFilter = true;
      bugFilterData = data;
    });
  }

  allFilterBugMember() {
    List<Bugs> data = currentUserProjects.bugs
        .where(
            (element) => element.requestedTo == widget.currentUserData.username)
        .toList();
    print(data.toString());
    setState(() {
      bugFilterMember = false;
      bugFilterDataMember = data;
    });
  }

  pendingFilterBugMember() {
    List<Bugs> data = currentUserProjects.bugs
        .where((element) =>
            element.status == 'Pending' &&
            element.requestedTo == widget.currentUserData.username)
        .toList();
    print(data.toString());
    setState(() {
      bugFilterMember = true;
      bugFilterDataMember = data;
    });
  }

  successFilterBugMember() {
    List<Bugs> data = currentUserProjects.bugs
        .where((element) => element.status == 'Success')
        .toList();
    setState(() {
      bugFilterMember = true;
      bugFilterDataMember = data;
    });
  }

  holdFilterBugMember() {
    List<Bugs> data = currentUserProjects.bugs
        .where((element) => element.status == 'Hold')
        .toList();
    setState(() {
      bugFilterMember = true;
      bugFilterDataMember = data;
    });
  }

  errorFilterBugMember() {
    List<Bugs> data = currentUserProjects.bugs
        .where((element) => element.status == 'Error')
        .toList();
    print('data = ${data.length}');
    setState(() {
      bugFilterMember = true;
      bugFilterDataMember = data;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      initLoading = true;
    });
    setState(() {
      currentUserProjects = widget.currentUserProjects;
      memberTask = widget.currentUserProjects.task
          .where((element) =>
              element.requestedTo == widget.currentUserData.username)
          .toList();
      memberBugs = widget.currentUserProjects.bugs
          .where((element) =>
              element.requestedTo == widget.currentUserData.username)
          .toList();
    });
    setState(() {
      initLoading = false;
    });
    print(memberBugs);
  }

  @override
  Widget build(BuildContext context) {
    print(addController.text);
    print(dateTime);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: selectedIndex == 0
            ? Text(
                'Overview',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'CrimsonTextRegular',
                ),
              )
            : selectedIndex == 1
                ? add
                    ? Text('Add Task',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: 'CrimsonTextRegular',
                        ))
                    : Text('Tasks',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: 'CrimsonTextRegular',
                        ))
                : selectedIndex == 2
                    ? Text('DashBoard',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: 'CrimsonTextRegular',
                        ))
                    : selectedIndex == 3
                        ? add
                            ? Text('Add Bug',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'CrimsonTextRegular',
                                ))
                            : Text('Bugs',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'CrimsonTextRegular',
                                ))
                        : selectedIndex == 4
                            ? Text('More',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'CrimsonTextRegular',
                                ))
                            : null,
        backgroundColor: Colors.teal[500],
        leading: selectedIndex == 0
            ? null
            : selectedIndex == 1
                ? widget.currentUserData.username ==
                        currentUserProjects.username
                    ? !add
                        ? null
                        : IconButton(
                            icon: Icon(Icons.cancel),
                            onPressed: () {
                              setState(() {
                                addController.text = "";
                                dropdownValue = "None";
                                dateTime = DateTime.now();
                                character = SingingCharacter.Pending;
                                add = !add;
                              });
                            })
                    : null
                : selectedIndex == 2
                    ? null
                    : selectedIndex == 3
                        ? !add
                            ? null
                            : IconButton(
                                icon: Icon(Icons.cancel),
                                onPressed: () {
                                  setState(() {
                                    addController.text = "";
                                    dropdownValue = "None";
                                    dateTime = DateTime.now();
                                    bugsCharacter =
                                        bug.SingingCharacter.Pending;
                                    add = !add;
                                  });
                                })
                        : null,
        actions: selectedIndex == 0
            ? []
            : selectedIndex == 1
                ? widget.currentUserData.username ==
                        currentUserProjects.username
                    ? !add
                        ? [
                            PopupMenuButton<String>(
                              icon: Icon(Icons.filter_list),
                              onSelected: (String result) {
                                if (result == 'All') {
                                  allFilterTask();
                                }
                                if (result == 'Pending') {
                                  pendingFilterTask();
                                }
                                if (result == 'Success') {
                                  successFilterTask();
                                }
                                if (result == 'Hold') {
                                  holdFilterTask();
                                }
                                if (result == 'Error') {
                                  errorFilterTask();
                                }
                              },
                              itemBuilder: (BuildContext context) =>
                                  <PopupMenuEntry<String>>[
                                const PopupMenuItem<String>(
                                  value: "All",
                                  child: Text('All',
                                      style: TextStyle(
                                        fontFamily: 'CrimsonTextRegular',
                                      )),
                                ),
                                const PopupMenuItem<String>(
                                  value: "Pending",
                                  child: Text('Pending',
                                      style: TextStyle(
                                        fontFamily: 'CrimsonTextRegular',
                                      )),
                                ),
                                const PopupMenuItem<String>(
                                  value: "Success",
                                  child: Text('Success',
                                      style: TextStyle(
                                        fontFamily: 'CrimsonTextRegular',
                                      )),
                                ),
                                const PopupMenuItem<String>(
                                  value: "Hold",
                                  child: Text('Hold',
                                      style: TextStyle(
                                        fontFamily: 'CrimsonTextRegular',
                                      )),
                                ),
                                const PopupMenuItem<String>(
                                  value: "Error",
                                  child: Text('Error',
                                      style: TextStyle(
                                        fontFamily: 'CrimsonTextRegular',
                                      )),
                                ),
                              ],
                            ),
                          ]
                        : [
                            !taskAddLoading
                                ? IconButton(
                                    icon: Icon(Icons.save, color: Colors.white),
                                    onPressed: () async {
                                      if (token != null &&
                                          currentUserProjects != null &&
                                          addController.text.length > 0 &&
                                          dateTime != null &&
                                          character != null &&
                                          dropdownValue != 'None') {
                                        await getTokenPreferences()
                                            .then((data) {
                                          setState(() {
                                            token = data;
                                            taskAddLoading = false;
                                          });
                                        });
                                        await addTask(
                                                token,
                                                currentUserProjects,
                                                addController.text,
                                                DateFormat('yyyy-MM-dd').format(
                                                    DateTime.parse(
                                                        dateTime.toString())),
                                                character
                                                    .toString()
                                                    .substring(17),
                                                dropdownValue)
                                            .then((value) async {
                                          await widget.handleProjectData(value);
                                          await handleProjectData(value);
                                          setState(() {
                                            taskAddLoading = false;
                                            add = false;
                                            addController.text = "";
                                            character =
                                                SingingCharacter.Pending;
                                            dropdownValue = 'None';
                                            dateTime = DateTime.now();
                                          });
                                        });
                                      }
                                    })
                                : Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: CircularProgressIndicator(
                                      valueColor:
                                          AlwaysStoppedAnimation(Colors.teal),
                                      backgroundColor: Colors.white,
                                    ),
                                  )
                          ]
                    : [
                        PopupMenuButton<String>(
                          icon: Icon(Icons.filter_list),
                          onSelected: (String result) {
                            if (result == 'All') {
                              allFilterTaskMember();
                            }
                            if (result == 'Pending') {
                              pendingFilterTaskMember();
                            }
                            if (result == 'Success') {
                              successFilterTaskMember();
                            }
                            if (result == 'Hold') {
                              holdFilterTaskMember();
                            }
                            if (result == 'Error') {
                              errorFilterTaskMember();
                            }
                          },
                          itemBuilder: (BuildContext context) =>
                              <PopupMenuEntry<String>>[
                            const PopupMenuItem<String>(
                              value: "All",
                              child: Text('All',
                                  style: TextStyle(
                                    fontFamily: 'CrimsonTextRegular',
                                  )),
                            ),
                            const PopupMenuItem<String>(
                              value: "Pending",
                              child: Text('Pending',
                                  style: TextStyle(
                                    fontFamily: 'CrimsonTextRegular',
                                  )),
                            ),
                            const PopupMenuItem<String>(
                              value: "Success",
                              child: Text('Success',
                                  style: TextStyle(
                                    fontFamily: 'CrimsonTextRegular',
                                  )),
                            ),
                            const PopupMenuItem<String>(
                              value: "Hold",
                              child: Text('Hold',
                                  style: TextStyle(
                                    fontFamily: 'CrimsonTextRegular',
                                  )),
                            ),
                            const PopupMenuItem<String>(
                              value: "Error",
                              child: Text('Error',
                                  style: TextStyle(
                                    fontFamily: 'CrimsonTextRegular',
                                  )),
                            ),
                          ],
                        ),
                      ]
                : selectedIndex == 2
                    ? []
                    : selectedIndex == 3
                        ? widget.currentUserData.username ==
                                currentUserProjects.username
                            ? !add
                                ? [
                                    PopupMenuButton<String>(
                                      icon: Icon(Icons.filter_list),
                                      onSelected: (String result) {
                                        if (result == 'All') {
                                          allFilterBug();
                                        }
                                        if (result == 'Pending') {
                                          pendingFilterBug();
                                        }
                                        if (result == 'Success') {
                                          successFilterBug();
                                        }
                                        if (result == 'Hold') {
                                          holdFilterBug();
                                        }
                                        if (result == 'Error') {
                                          errorFilterBug();
                                        }
                                      },
                                      itemBuilder: (BuildContext context) =>
                                          <PopupMenuEntry<String>>[
                                        const PopupMenuItem<String>(
                                          value: "All",
                                          child: Text('All',
                                              style: TextStyle(
                                                fontFamily:
                                                    'CrimsonTextRegular',
                                              )),
                                        ),
                                        const PopupMenuItem<String>(
                                          value: "Pending",
                                          child: Text('Pending',
                                              style: TextStyle(
                                                fontFamily:
                                                    'CrimsonTextRegular',
                                              )),
                                        ),
                                        const PopupMenuItem<String>(
                                          value: "Success",
                                          child: Text('Success',
                                              style: TextStyle(
                                                fontFamily:
                                                    'CrimsonTextRegular',
                                              )),
                                        ),
                                        const PopupMenuItem<String>(
                                          value: "Hold",
                                          child: Text('Hold',
                                              style: TextStyle(
                                                fontFamily:
                                                    'CrimsonTextRegular',
                                              )),
                                        ),
                                        const PopupMenuItem<String>(
                                          value: "Error",
                                          child: Text('Error',
                                              style: TextStyle(
                                                fontFamily:
                                                    'CrimsonTextRegular',
                                              )),
                                        ),
                                      ],
                                    ),
                                  ]
                                : [
                                    !bugAddLoading
                                        ? IconButton(
                                            icon: Icon(Icons.save,
                                                color: Colors.white),
                                            onPressed: () async {
                                              if (token != null &&
                                                  currentUserProjects != null &&
                                                  addController.text.length >
                                                      0 &&
                                                  dateTime != null &&
                                                  bugsCharacter != null &&
                                                  dropdownValue != 'None') {
                                                await getTokenPreferences()
                                                    .then((data) {
                                                  setState(() {
                                                    token = data;
                                                    bugAddLoading = true;
                                                  });
                                                });
                                                await addBug(
                                                        token,
                                                        currentUserProjects,
                                                        addController.text,
                                                        DateFormat('yyyy-MM-dd')
                                                            .format(DateTime
                                                                .parse(dateTime
                                                                    .toString())),
                                                        bugsCharacter
                                                            .toString()
                                                            .substring(17),
                                                        dropdownValue)
                                                    .then((value) async {
                                                  await widget
                                                      .handleProjectData(value);
                                                  await handleProjectData(
                                                      value);
                                                  setState(() {
                                                    bugAddLoading = false;
                                                    add = false;
                                                    addController.text = "";
                                                    bugsCharacter = bug
                                                        .SingingCharacter
                                                        .Pending;
                                                    dropdownValue = 'None';
                                                    dateTime = DateTime.now();
                                                  });
                                                });
                                              }
                                            })
                                        : Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: CircularProgressIndicator(
                                              valueColor:
                                                  AlwaysStoppedAnimation(
                                                      Colors.teal),
                                              backgroundColor: Colors.white,
                                            ),
                                          )
                                  ]
                            : [
                                PopupMenuButton<String>(
                                  icon: Icon(Icons.filter_list),
                                  onSelected: (String result) {
                                    if (result == 'All') {
                                      allFilterBugMember();
                                    }
                                    if (result == 'Pending') {
                                      pendingFilterBugMember();
                                    }
                                    if (result == 'Success') {
                                      successFilterBugMember();
                                    }
                                    if (result == 'Hold') {
                                      holdFilterBugMember();
                                    }
                                    if (result == 'Error') {
                                      errorFilterBugMember();
                                    }
                                  },
                                  itemBuilder: (BuildContext context) =>
                                      <PopupMenuEntry<String>>[
                                    const PopupMenuItem<String>(
                                      value: "All",
                                      child: Text('All',
                                          style: TextStyle(
                                            fontFamily: 'CrimsonTextRegular',
                                          )),
                                    ),
                                    const PopupMenuItem<String>(
                                      value: "Pending",
                                      child: Text('Pending',
                                          style: TextStyle(
                                            fontFamily: 'CrimsonTextRegular',
                                          )),
                                    ),
                                    const PopupMenuItem<String>(
                                      value: "Success",
                                      child: Text('Success',
                                          style: TextStyle(
                                            fontFamily: 'CrimsonTextRegular',
                                          )),
                                    ),
                                    const PopupMenuItem<String>(
                                      value: "Hold",
                                      child: Text('Hold',
                                          style: TextStyle(
                                            fontFamily: 'CrimsonTextRegular',
                                          )),
                                    ),
                                    const PopupMenuItem<String>(
                                      value: "Error",
                                      child: Text('Error',
                                          style: TextStyle(
                                            fontFamily: 'CrimsonTextRegular',
                                          )),
                                    ),
                                  ],
                                ),
                              ]
                        : null,
      ),
      body: !initLoading
          ? selectedIndex == 0
              ? Overview(
                  currentUserProjects: currentUserProjects,
                  currentUserData: widget.currentUserData)
              : selectedIndex == 1
                  ? widget.currentUserData.username ==
                          currentUserProjects.username
                      ? OwnerTask(
                          addController: addController,
                          character: character,
                          handleDropDown: handleDropDown,
                          dropdownValue: dropdownValue,
                          dateTime: dateTime,
                          add: add,
                          taskFilter: taskFilter,
                          taskFilterData: taskFilterData,
                          handleProjectData: widget.handleProjectData,
                          handleProjectData1: handleProjectData,
                          handleDateTime: handleDateTime,
                          handleCharacter: handleCharacter,
                          handleAdd: handleAdd,
                          currentUserProjects: currentUserProjects,
                          currentUserData: widget.currentUserData)
                      : MemberTask(
                          addController: addController,
                          handleDropDown: handleDropDown,
                          dropdownValue: dropdownValue,
                          dateTime: dateTime,
                          add: add,
                          taskFilterMember: taskFilterMember,
                          taskFilterDataMember: taskFilterDataMember,
                          handleProjectData: widget.handleProjectData,
                          handleProjectData1: handleProjectData,
                          handleDateTime: handleDateTime,
                          handleCharacter: handleCharacter,
                          handleAdd: handleAdd,
                          memberTask: memberTask,
                          currentUserProjects: currentUserProjects,
                          currentUserData: widget.currentUserData)
                  : selectedIndex == 2
                      ? Dashboard(
                          currentUserProjects: currentUserProjects,
                          currentUserData: widget.currentUserData)
                      : selectedIndex == 3
                          ? widget.currentUserData.username ==
                                  currentUserProjects.username
                              ? bug.OwnerBug(
                                  addController: addController,
                                  handleDropDown: handleDropDown,
                                  dropdownValue: dropdownValue,
                                  dateTime: dateTime,
                                  character1: bugsCharacter,
                                  add: add,
                                  bugFilter: bugFilter,
                                  bugFilterData: bugFilterData,
                                  handleProjectData: widget.handleProjectData,
                                  handleProjectData1: handleProjectData,
                                  handleDateTime: handleDateTime,
                                  handleCharacter1: handleCharacter1,
                                  handleAdd: handleAdd,
                                  currentUserProjects: currentUserProjects,
                                  currentUserData: widget.currentUserData)
                              : MemberBug(
                                  addController: addController,
                                  handleDropDown: handleDropDown,
                                  dropdownValue: dropdownValue,
                                  dateTime: dateTime,
                                  add: add,
                                  memberBugs: memberBugs,
                                  bugFilterMember: bugFilterMember,
                                  bugFilterDataMember: bugFilterDataMember,
                                  bugFilter: bugFilter,
                                  bugFilterData: bugFilterData,
                                  handleProjectData: widget.handleProjectData,
                                  handleProjectData1: handleProjectData,
                                  handleDateTime: handleDateTime,
                                  handleCharacter1: handleCharacter1,
                                  handleAdd: handleAdd,
                                  currentUserProjects: currentUserProjects,
                                  currentUserData: widget.currentUserData)
                          : More(
                              allUser: widget.allUser,
                              handleProjectData: widget.handleProjectData,
                              handleProjectData1: handleProjectData,
                              currentUserProjects: currentUserProjects,
                              currentUserData: widget.currentUserData)
          : SpinKitFoldingCube(
              color: Colors.teal,
            ),
      bottomNavigationBar: !add
          ? CurvedNavigationBar(
              height: 55,
              backgroundColor: Colors.grey[200],
              color: Colors.teal,
              items: <Widget>[
                Icon(
                  FontAwesomeIcons.list,
                  size: 25,
                  color: Colors.white,
                ),
                Icon(
                  FontAwesomeIcons.tasks,
                  size: 25,
                  color: Colors.white,
                ),
                Icon(
                  Icons.dashboard,
                  size: 35,
                  color: Colors.white,
                ),
                Icon(
                  FontAwesomeIcons.bug,
                  size: 25,
                  color: Colors.white,
                ),
                Icon(
                  Icons.more_vert,
                  size: 25,
                  color: Colors.white,
                ),
              ],
              animationCurve: Curves.easeInOut,
              animationDuration: Duration(milliseconds: 350),
              index: selectedIndex,
              onTap: (index) {
                onItemTapped1(index);
              },
            )
          : null,
    );
  }
}
