import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fproject/Auth/login/fabeanimation.dart';
import 'package:fproject/Team/model.dart';
import 'package:fproject/project/components/Owner/taskview.dart';
import 'package:fproject/project/components/api_response.dart';
import 'package:fproject/project/components/models.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../gettoken.dart';

enum SingingCharacter1 { Success, Hold, Pending, Error }

class MemberTask extends StatefulWidget {
  ProjectModel currentUserProjects;
  UserModel currentUserData;
  Function handleAdd;
  bool add;
  Function handleCharacter;
  DateTime dateTime;
  Function handleDateTime;
  Function handleDropDown;
  bool taskFilterMember;
  List<Task> taskFilterDataMember;
  List<Task> memberTask;
  Function handleProjectData;
  String dropdownValue;
  TextEditingController addController;
  Function handleProjectData1;
  MemberTask(
      {Key key,
      this.currentUserData,
      this.currentUserProjects,
      this.add,
      this.taskFilterMember,
      this.memberTask,
      this.taskFilterDataMember,
      this.handleProjectData,
      this.dropdownValue,
      this.handleDropDown,
      this.handleDateTime,
      this.handleProjectData1,
      this.handleCharacter,
      this.addController,
      this.dateTime,
      this.handleAdd})
      : super(key: key);

  @override
  _MemberTaskState createState() => _MemberTaskState();
}

class _MemberTaskState extends State<MemberTask> {
  Task moreOption;
  int dropdownValue = 0;
  int startSliceValue = 0;
  int endSliceValue = 0;
  bool loading = false;
  int sliceValue = 0;
  bool editMemberTaskLoading = false;
  bool showPagination = false;
  TextEditingController editingController = new TextEditingController();
  SingingCharacter1 editCharacter = SingingCharacter1.Pending;
  DateTime editDateTime;
  List<Task> memberTask = [];
  final members = <String>[];
  String token = '';

  _showBottom(context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
              height: 600,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.edit,
                          color: Colors.teal,
                          size: 40,
                        ),
                        onPressed: () {},
                      ),
                      SizedBox(
                        height: 18.0,
                      ),
                      TextField(
                        controller: editingController,
                        keyboardType: TextInputType.text,
                        cursorColor: Colors.black,
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'CrimsonTextRegular',
                            fontWeight: FontWeight.bold),
                        decoration: new InputDecoration(
                          border: new OutlineInputBorder(
                              borderSide: new BorderSide(color: Colors.black)),
                          hintText: 'Task',
                          labelText: 'Task',
                        ),
                      ),
                      SizedBox(
                        height: 18.0,
                      ),
                      Text('Status',
                          style: TextStyle(
                              fontFamily: 'CrimsonTextRegular',
                              fontSize: 20,
                              fontWeight: FontWeight.bold)),
                      SizedBox(
                        height: 18.0,
                      ),
                      Container(
                        child: Column(
                          children: [
                            ListTile(
                              title: const Text('Success',
                                  style: TextStyle(
                                    fontFamily: 'CrimsonTextRegular',
                                  )),
                              leading: Radio(
                                value: SingingCharacter1.Success,
                                groupValue: editCharacter,
                                onChanged: (SingingCharacter1 value) {
                                  setState(() {
                                    editCharacter = value;
                                  });
                                },
                              ),
                            ),
                            ListTile(
                              title: const Text('Hold',
                                  style: TextStyle(
                                      fontFamily: 'CrimsonTextRegular')),
                              leading: Radio(
                                value: SingingCharacter1.Hold,
                                groupValue: editCharacter,
                                onChanged: (SingingCharacter1 value) {
                                  setState(() {
                                    editCharacter = value;
                                  });
                                },
                              ),
                            ),
                            ListTile(
                              title: const Text('Pending',
                                  style: TextStyle(
                                      fontFamily: 'CrimsonTextRegular',
                                      fontWeight: FontWeight.bold)),
                              leading: Radio(
                                value: SingingCharacter1.Pending,
                                groupValue: editCharacter,
                                onChanged: (SingingCharacter1 value) {
                                  setState(() {
                                    editCharacter = value;
                                  });
                                },
                              ),
                            ),
                            ListTile(
                              title: const Text('Error',
                                  style: TextStyle(
                                      fontFamily: 'CrimsonTextRegular',
                                      fontWeight: FontWeight.bold)),
                              leading: Radio(
                                value: SingingCharacter1.Error,
                                groupValue: editCharacter,
                                onChanged: (SingingCharacter1 value) {
                                  print(value);
                                  setState(() {
                                    editCharacter = value;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 18.0,
                      ),
                      Text('DeadLine',
                          style: TextStyle(
                              fontFamily: 'CrimsonTextRegular',
                              fontSize: 20,
                              fontWeight: FontWeight.bold)),
                      Row(
                        children: [
                          Spacer(),
                          Text(
                            editDateTime == null
                                ? DateFormat('yyyy/MM/dd').format(
                                    DateTime.parse(DateTime.now().toString()))
                                : DateFormat('yyyy/MM/dd').format(
                                    DateTime.parse(editDateTime.toString())),
                            style: TextStyle(
                                fontSize: 20, fontFamily: 'CrimsonTextRegular'),
                          ),
                          IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                showDatePicker(
                                        context: context,
                                        initialDate: editDateTime == null
                                            ? DateTime.now()
                                            : editDateTime,
                                        firstDate: DateTime(2010),
                                        lastDate: DateTime(2021))
                                    .then((date) {
                                  setState(() {
                                    editDateTime = date;
                                  });
                                });
                              }),
                          Spacer()
                        ],
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      RaisedButton.icon(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        onPressed: () async {
                          await getTokenPreferences().then((data) {
                            setState(() {
                              token = data;
                              editMemberTaskLoading = true;
                            });
                          });
                          await editTask(
                                  token,
                                  widget.currentUserProjects,
                                  editingController.text,
                                  DateFormat('yyyy-MM-dd').format(
                                      DateTime.parse(editDateTime.toString())),
                                  editCharacter.toString().substring(17),
                                  moreOption.id)
                              .then((value) async {
                            print(value.task.toString());
                            await widget.handleProjectData(value);
                            await widget.handleProjectData1(value);
                            setState(() {
                              editMemberTaskLoading = false;
                            });
                            Navigator.pop(context);
                          });
                        },
                        color: Colors.teal,
                        icon: Icon(Icons.edit, color: Colors.white),
                        label: !editMemberTaskLoading
                            ? Text('Edit',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'CrimsonTextRegular'))
                            : CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation(Colors.teal),
                                backgroundColor: Colors.white),
                      )
                    ],
                  ),
                ),
              ),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20))),
            ),
          );
        });
      },
    );
  }

  _showBottomMember(context, data) {
    setState(() {
      this.moreOption = data;
      editCharacter = data.status == 'Error'
          ? SingingCharacter1.Error
          : data.status == 'Pending'
              ? SingingCharacter1.Pending
              : data.status == 'Success'
                  ? SingingCharacter1.Success
                  : data.status == 'Hold' ? SingingCharacter1.Hold : null;
    });
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Container(
              height: 500,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.edit,
                          color: Colors.teal,
                          size: 40,
                        ),
                        onPressed: () {},
                      ),
                      SizedBox(
                        height: 18.0,
                      ),
                      Text('Status',
                          style: TextStyle(
                              fontFamily: 'CrimsonTextRegular',
                              fontSize: 20,
                              fontWeight: FontWeight.bold)),
                      SizedBox(
                        height: 18.0,
                      ),
                      Container(
                        child: Column(
                          children: [
                            ListTile(
                              title: const Text('Success',
                                  style: TextStyle(
                                      fontFamily: 'CrimsonTextRegular')),
                              leading: Radio(
                                value: SingingCharacter1.Success,
                                groupValue: editCharacter,
                                onChanged: (SingingCharacter1 value) {
                                  setState(() {
                                    editCharacter = value;
                                  });
                                },
                              ),
                            ),
                            ListTile(
                              title: const Text('Hold',
                                  style: TextStyle(
                                      fontFamily: 'CrimsonTextRegular')),
                              leading: Radio(
                                value: SingingCharacter1.Hold,
                                groupValue: editCharacter,
                                onChanged: (SingingCharacter1 value) {
                                  setState(() {
                                    editCharacter = value;
                                  });
                                },
                              ),
                            ),
                            ListTile(
                              title: const Text('Pending',
                                  style: TextStyle(
                                      fontFamily: 'CrimsonTextRegular')),
                              leading: Radio(
                                value: SingingCharacter1.Pending,
                                groupValue: editCharacter,
                                onChanged: (SingingCharacter1 value) {
                                  setState(() {
                                    editCharacter = value;
                                  });
                                },
                              ),
                            ),
                            ListTile(
                              title: const Text('Error',
                                  style: TextStyle(
                                      fontFamily: 'CrimsonTextRegular')),
                              leading: Radio(
                                value: SingingCharacter1.Error,
                                groupValue: editCharacter,
                                onChanged: (SingingCharacter1 value) {
                                  print(value);
                                  setState(() {
                                    editCharacter = value;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 18.0,
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      RaisedButton.icon(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          color: Colors.teal,
                          onPressed: () async {
                            await getTokenPreferences().then((data) {
                              setState(() {
                                token = data;
                              });
                            });
                            await editTaskMember(
                                    token,
                                    widget.currentUserProjects,
                                    editCharacter.toString().substring(18),
                                    moreOption.id)
                                .then((value) async {
                              print(value.task.toString());
                              setState(() {
                                memberTask = value.task;
                              });
                              await widget.handleProjectData(value);
                              await widget.handleProjectData1(value);
                              Navigator.pop(context);
                            });
                          },
                          icon: Icon(
                            Icons.edit,
                            color: Colors.white,
                          ),
                          label: Text('Edit',
                              style: TextStyle(
                                fontFamily: 'CrimsonTextRegular',
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              )))
                    ],
                  ),
                ),
              ),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20))),
            ),
          );
        });
      },
    );
  }

  _showModalBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 170,
            child: Center(
              child: GridView.count(
                crossAxisCount: 2,
                children: [
                  IconButton(
                      icon: Icon(
                        Icons.edit,
                        color: Colors.white,
                        size: 80,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        _showBottom(context);
                      }),
                  IconButton(
                      icon: Icon(
                        Icons.delete,
                        color: Colors.white,
                        size: 80,
                      ),
                      onPressed: () {
                        Navigator.pop(context);

                        _handleDelete(moreOption);
                      }),
                ],
              ),
            ),
            decoration: BoxDecoration(
                color: Colors.teal[200],
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20))),
          );
        });
  }

  _showModalBottomSheet1(BuildContext context, item) {
    print(item.tasks);
    final val = item.status;
    setState(() {
      this.moreOption = item;
      editingController.text = item.tasks;
      editCharacter = item.status == 'Error'
          ? SingingCharacter1.Error
          : item.status == 'Pending'
              ? SingingCharacter1.Pending
              : item.status == 'Success'
                  ? SingingCharacter1.Success
                  : item.status == 'Hold' ? SingingCharacter1.Hold : null;
      editDateTime = DateTime.parse(item.dueDate);
    });
    _showModalBottomSheet(context);
  }

  _handleDelete(moreOption) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text("Delete Task",
                style: TextStyle(fontFamily: 'CrimsonTextRegular')),
            content: Text("Are you sure?",
                style: TextStyle(fontFamily: 'CrimsonTextRegular')),
            actions: [
              CupertinoDialogAction(
                child: Text('No',
                    style: TextStyle(fontFamily: 'CrimsonTextRegular')),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              CupertinoDialogAction(
                child: Text('Yes',
                    style: TextStyle(fontFamily: 'CrimsonTextRegular')),
                onPressed: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  String token = prefs.getString("token");
                  deleteTask(moreOption.id, token, widget.currentUserProjects)
                      .then((value) async {
                    await widget.handleProjectData(value);
                    await widget.handleProjectData1(value);
                    Navigator.pop(context);
                  });
                },
              ),
            ],
          );
        });
  }

  void _incrementData() {
    if (endSliceValue + dropdownValue <= widget.memberTask.length) {
      this.setState(() {
        this.startSliceValue = endSliceValue;
        this.endSliceValue = dropdownValue + endSliceValue;
      });
    }
  }

  void _decrementData() {
    if (startSliceValue - dropdownValue >= 0) {
      setState(() {
        this.endSliceValue = endSliceValue - dropdownValue;
        this.startSliceValue = startSliceValue - dropdownValue;
      });
    }
  }

  void _decrementEndData() {
    int data = widget.memberTask.length;
    while (data % dropdownValue != 0) {
      this.setState(() {
        data = data - 1;
      });
    }
    final int minusData = widget.memberTask.length - data;
    setState(() {
      this.startSliceValue = endSliceValue - dropdownValue - minusData;
      this.endSliceValue = endSliceValue - minusData;
    });
  }

  void _incrementDateToItsEnd() {
    setState(() {
      this.startSliceValue = endSliceValue;
      this.endSliceValue = widget.memberTask.length;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    members.add('None');
    setState(() {
      loading = true;
      memberTask = widget.memberTask;
    });
    if (memberTask.length >= 5 && memberTask.length != 0) {
      setState(() {
        this.dropdownValue = 5;
        this.endSliceValue = 5;
      });
    } else {
      setState(() {
        this.dropdownValue = memberTask.length;
        this.endSliceValue = memberTask.length;
      });
    }
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    print(startSliceValue);
    print(endSliceValue);
    return !loading
        ? Scaffold(
            backgroundColor: Colors.grey[200],
            body: Stack(children: [
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(bottom: 15.0),
                child: Column(
                  children: [
                    Expanded(
                      child: !widget.taskFilterMember
                          ? _buildPanel()
                          : _buildPanelFilter(),
                    ),
                    !widget.taskFilterMember
                        ? showPagination
                            ? FadeAnimation(
                                0.5,
                                Dismissible(
                                  key: Key('tasks'),
                                  onDismissed: (direction) {
                                    // Remove the item from the data source.
                                    setState(() {
                                      showPagination = !showPagination;
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 4.0, right: 4.0, top: 3.0),
                                    child: widget.memberTask.length >= 5
                                        ? Container(
                                            alignment: Alignment.bottomCenter,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                color: Colors.teal),
                                            child: Row(
                                              children: [
                                                IconButton(
                                                    icon: Icon(
                                                        Icons.navigate_before),
                                                    onPressed: startSliceValue !=
                                                                0 &&
                                                            endSliceValue !=
                                                                dropdownValue
                                                        ? dropdownValue !=
                                                                widget
                                                                    .memberTask
                                                                    .length
                                                            ? endSliceValue !=
                                                                    widget
                                                                        .memberTask
                                                                        .length
                                                                ? () {
                                                                    _decrementData();
                                                                  }
                                                                : () {
                                                                    _decrementEndData();
                                                                  }
                                                            : null
                                                        : null),
                                                Spacer(),
                                                Text('Rows : ',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontFamily:
                                                            'CrimsonTextRegular')),
                                                DropdownButton<int>(
                                                  value: dropdownValue,
                                                  icon: Icon(
                                                      Icons.arrow_downward),
                                                  iconSize: 24,
                                                  elevation: 16,
                                                  dropdownColor: Colors.white,
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontFamily:
                                                          'CrimsonTextRegular',
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  underline: Container(
                                                    height: 2,
                                                    color: Colors.transparent,
                                                  ),
                                                  onChanged: (int newValue) {
                                                    if (newValue <=
                                                        widget.memberTask
                                                            .length) {
                                                      setState(() {
                                                        dropdownValue =
                                                            newValue;
                                                        startSliceValue = 0;
                                                        endSliceValue =
                                                            newValue;
                                                      });
                                                    }
                                                  },
                                                  items: widget.memberTask.length > 0 &&
                                                          widget.memberTask
                                                                  .length !=
                                                              5 &&
                                                          widget.memberTask
                                                                  .length !=
                                                              10 &&
                                                          widget.memberTask
                                                                  .length !=
                                                              15
                                                      ? <int>[
                                                          5,
                                                          10,
                                                          15,
                                                          widget
                                                              .memberTask.length
                                                        ].map<DropdownMenuItem<int>>(
                                                          (int value) {
                                                          return DropdownMenuItem<
                                                              int>(
                                                            value: value,
                                                            child: Text(
                                                                value
                                                                    .toString(),
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        'CrimsonTextRegular',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold)),
                                                          );
                                                        }).toList()
                                                      : <int>[
                                                          5,
                                                          10,
                                                          15
                                                        ].map<DropdownMenuItem<int>>(
                                                          (int value) {
                                                          return DropdownMenuItem<
                                                              int>(
                                                            value: value,
                                                            child: Text(
                                                                value
                                                                    .toString(),
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        'CrimsonTextRegular',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold)),
                                                          );
                                                        }).toList(),
                                                ),
                                                Text(' ( ',
                                                    style: TextStyle(
                                                        fontFamily:
                                                            'CrimsonTextRegular',
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                Text(
                                                    startSliceValue.toString()),
                                                Text(' to ',
                                                    style: TextStyle(
                                                        fontFamily:
                                                            'CrimsonTextRegular',
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                Text(endSliceValue.toString()),
                                                Text(' out of  ',
                                                    style: TextStyle(
                                                        fontFamily:
                                                            'CrimsonTextRegular',
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                Text(
                                                  widget.memberTask.length
                                                      .toString(),
                                                ),
                                                Text(' ) ',
                                                    style: TextStyle(
                                                        fontFamily:
                                                            'CrimsonTextRegular',
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                Spacer(),
                                                IconButton(
                                                    icon: Icon(
                                                        Icons.navigate_next),
                                                    onPressed: endSliceValue !=
                                                            widget.memberTask
                                                                .length
                                                        ? dropdownValue !=
                                                                widget
                                                                    .memberTask
                                                                    .length
                                                            ? endSliceValue +
                                                                        dropdownValue <=
                                                                    widget
                                                                        .memberTask
                                                                        .length
                                                                ? () {
                                                                    _incrementData();
                                                                    print('da');
                                                                  }
                                                                : () {
                                                                    _incrementDateToItsEnd();
                                                                    print('da');
                                                                  }
                                                            : null
                                                        : null),
                                              ],
                                            ),
                                          )
                                        : null,
                                  ),
                                ),
                              )
                            : Container()
                        : Container()
                  ],
                ),
              ),
              !widget.taskFilterMember
                  ? !showPagination && memberTask.length >= 5
                      ? Positioned(
                          child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  showPagination = !showPagination;
                                });
                              },
                              child: Icon(
                                FontAwesomeIcons.chevronCircleRight,
                                color: Colors.teal,
                                size: 50,
                              )),
                          left: -20,
                          top: MediaQuery.of(context).size.height * 0.725,
                        )
                      : Container()
                  : Container()
            ]),
          )
        : Container(
            height: MediaQuery.of(context).size.height,
            child: Center(
              child: SpinKitFoldingCube(color: Colors.teal),
            ),
          );
  }

  Widget _buildPanelFilter() {
    return !loading
        ? widget.taskFilterDataMember.length > 0
            ? ListView.builder(
                itemCount: widget.taskFilterDataMember.length,
                itemBuilder: (context, index) {
                  return Container(
                    height: 80,
                    width: double.maxFinite,
                    child: Card(
                      color: Colors.white,
                      elevation: 5,
                      child: ListTile(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return TaskView(
                                  data: widget.taskFilterDataMember[index]);
                            },
                          ));
                        },
                        title: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Text(
                              widget.taskFilterDataMember[index].tasks
                                  .capitalize(),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'CrimsonTextRegular')),
                        ),
                        subtitle: Text(
                            DateFormat('yyyy/MM/dd').format(DateTime.parse(
                                widget.taskFilterDataMember[index].timestamp)),
                            style: TextStyle(
                                fontFamily: 'CrimsonTextRegular',
                                fontWeight: FontWeight.bold)),
                        trailing: widget.currentUserData.username ==
                                widget.currentUserProjects.username
                            ? IconButton(
                                icon: Icon(Icons.more_vert),
                                onPressed: () {
                                  _showModalBottomSheet1(context,
                                      widget.taskFilterDataMember[index]);
                                })
                            : IconButton(
                                icon: Icon(
                                  Icons.edit,
                                  color: Colors.grey,
                                ),
                                onPressed: () {
                                  _showBottomMember(context,
                                      widget.taskFilterDataMember[index]);
                                }),
                      ),
                    ),
                  );
                })
            : Container(
                height: MediaQuery.of(context).size.height,
                child: Center(
                  child: Text('No Task',
                      style: TextStyle(
                          fontFamily: 'CrimsonTextRegular',
                          fontWeight: FontWeight.bold)),
                ))
        : Container(
            height: MediaQuery.of(context).size.height,
            child: Center(
              child: SpinKitFoldingCube(color: Colors.teal),
            ),
          );
  }

  Widget _buildPanel() {
    print(members);
    return !loading
        ? memberTask.length > 0
            ? ListView.builder(
                itemCount:
                    memberTask.sublist(startSliceValue, endSliceValue).length,
                itemBuilder: (context, index) {
                  return Container(
                    height: 80,
                    width: double.maxFinite,
                    child: Card(
                      color: Colors.white,
                      elevation: 5,
                      child: ListTile(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return TaskView(
                                  data: memberTask[index + startSliceValue]);
                            },
                          ));
                        },
                        title: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Text(
                              memberTask[index + startSliceValue]
                                  .tasks
                                  .capitalize(),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'CrimsonTextRegular')),
                        ),
                        subtitle: Text(
                            DateFormat('yyyy/MM/dd').format(DateTime.parse(
                                memberTask[index + startSliceValue].timestamp)),
                            style: TextStyle(
                                fontFamily: 'CrimsonTextRegular',
                                fontWeight: FontWeight.bold)),
                        trailing: widget.currentUserData.username ==
                                widget.currentUserProjects.username
                            ? IconButton(
                                icon: Icon(Icons.more_vert),
                                onPressed: () {
                                  _showModalBottomSheet1(context,
                                      memberTask[index + startSliceValue]);
                                })
                            : IconButton(
                                icon: Icon(
                                  Icons.edit,
                                  color: Colors.grey,
                                ),
                                onPressed: () {
                                  _showBottomMember(context,
                                      memberTask[index + startSliceValue]);
                                }),
                      ),
                    ),
                  );
                })
            : Container(
                height: MediaQuery.of(context).size.height,
                child: Center(
                  child: Text('No Task',
                      style: TextStyle(
                          fontFamily: 'CrimsonTextRegular',
                          fontWeight: FontWeight.bold)),
                ))
        : Container(
            height: MediaQuery.of(context).size.height,
            child: Center(
              child: SpinKitFoldingCube(color: Colors.teal),
            ),
          );
  }
}
