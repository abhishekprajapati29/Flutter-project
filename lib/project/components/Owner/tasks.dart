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

enum SingingCharacter { Success, Hold, Pending, Error }

class OwnerTask extends StatefulWidget {
  ProjectModel currentUserProjects;
  UserModel currentUserData;
  Function handleAdd;
  bool add;
  Function handleCharacter;
  DateTime dateTime;
  Function handleDateTime;
  Function handleDropDown;
  bool taskFilter;
  List<Task> taskFilterData;
  Function handleProjectData;
  String dropdownValue;
  SingingCharacter character;
  TextEditingController addController;
  Function handleProjectData1;
  OwnerTask(
      {Key key,
      this.currentUserData,
      this.currentUserProjects,
      this.add,
      this.taskFilter,
      this.taskFilterData,
      this.handleProjectData,
      this.dropdownValue,
      this.handleDropDown,
      this.handleDateTime,
      this.handleProjectData1,
      this.handleCharacter,
      this.addController,
      this.character,
      this.dateTime,
      this.handleAdd})
      : super(key: key);

  @override
  _OwnerTaskState createState() => _OwnerTaskState();
}

class _OwnerTaskState extends State<OwnerTask> {
  Task moreOption;
  int dropdownValue = 0;
  int startSliceValue = 0;
  int endSliceValue = 0;
  bool loading = false;
  bool editTaskLoading = false;
  int sliceValue = 0;
  bool showPagination = false;
  TextEditingController editingController = new TextEditingController();
  SingingCharacter editCharacter = SingingCharacter.Pending;
  DateTime editDateTime;
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
                            fontFamily: 'CrimsonTextRegular'),
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
                                      fontWeight: FontWeight.bold)),
                              leading: Radio(
                                value: SingingCharacter.Success,
                                groupValue: editCharacter,
                                onChanged: (SingingCharacter value) {
                                  setState(() {
                                    editCharacter = value;
                                  });
                                },
                              ),
                            ),
                            ListTile(
                              title: const Text('Hold',
                                  style: TextStyle(
                                      fontFamily: 'CrimsonTextRegular',
                                      fontWeight: FontWeight.bold)),
                              leading: Radio(
                                value: SingingCharacter.Hold,
                                groupValue: editCharacter,
                                onChanged: (SingingCharacter value) {
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
                                value: SingingCharacter.Pending,
                                groupValue: editCharacter,
                                onChanged: (SingingCharacter value) {
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
                                value: SingingCharacter.Error,
                                groupValue: editCharacter,
                                onChanged: (SingingCharacter value) {
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
                              fontSize: 20,
                              fontFamily: 'CrimsonTextRegular',
                            ),
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
                          onPressed: !editTaskLoading
                              ? () async {
                                  await getTokenPreferences().then((data) {
                                    setState(() {
                                      token = data;
                                      editTaskLoading = true;
                                    });
                                  });
                                  await editTask(
                                          token,
                                          widget.currentUserProjects,
                                          editingController.text,
                                          DateFormat('yyyy-MM-dd').format(
                                              DateTime.parse(
                                                  editDateTime.toString())),
                                          editCharacter
                                              .toString()
                                              .substring(17),
                                          moreOption.id)
                                      .then((value) async {
                                    print(value.task.toString());
                                    await widget.handleProjectData(value);
                                    await widget.handleProjectData1(value);
                                    setState(() {
                                      editTaskLoading = false;
                                    });
                                    Navigator.pop(context);
                                  });
                                }
                              : null,
                          color: Colors.teal,
                          icon: Icon(Icons.edit, color: Colors.white),
                          label: !editTaskLoading
                              ? Text('Edit',
                                  style: TextStyle(color: Colors.white))
                              : CircularProgressIndicator(
                                  valueColor:
                                      AlwaysStoppedAnimation(Colors.teal),
                                  backgroundColor: Colors.white,
                                ))
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
          ? SingingCharacter.Error
          : data.status == 'Pending'
              ? SingingCharacter.Pending
              : data.status == 'Success'
                  ? SingingCharacter.Success
                  : data.status == 'Hold' ? SingingCharacter.Hold : null;
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
                                      fontFamily: 'CrimsonTextRegular',
                                      fontWeight: FontWeight.bold)),
                              leading: Radio(
                                value: SingingCharacter.Success,
                                groupValue: editCharacter,
                                onChanged: (SingingCharacter value) {
                                  setState(() {
                                    editCharacter = value;
                                  });
                                },
                              ),
                            ),
                            ListTile(
                              title: const Text('Hold',
                                  style: TextStyle(
                                      fontFamily: 'CrimsonTextRegular',
                                      fontWeight: FontWeight.bold)),
                              leading: Radio(
                                value: SingingCharacter.Hold,
                                groupValue: editCharacter,
                                onChanged: (SingingCharacter value) {
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
                                value: SingingCharacter.Pending,
                                groupValue: editCharacter,
                                onChanged: (SingingCharacter value) {
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
                                value: SingingCharacter.Error,
                                groupValue: editCharacter,
                                onChanged: (SingingCharacter value) {
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
                                    editCharacter.toString().substring(17),
                                    moreOption.id)
                                .then((value) async {
                              print(value.task.toString());
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
          ? SingingCharacter.Error
          : item.status == 'Pending'
              ? SingingCharacter.Pending
              : item.status == 'Success'
                  ? SingingCharacter.Success
                  : item.status == 'Hold' ? SingingCharacter.Hold : null;
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
                style: TextStyle(
                    fontFamily: 'CrimsonTextRegular',
                    fontWeight: FontWeight.bold)),
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
    if (endSliceValue + dropdownValue <=
        widget.currentUserProjects.task.length) {
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
    int data = widget.currentUserProjects.task.length;
    while (data % dropdownValue != 0) {
      this.setState(() {
        data = data - 1;
      });
    }
    final int minusData = widget.currentUserProjects.task.length - data;
    setState(() {
      this.startSliceValue = endSliceValue - dropdownValue - minusData;
      this.endSliceValue = endSliceValue - minusData;
    });
  }

  void _incrementDateToItsEnd() {
    setState(() {
      this.startSliceValue = endSliceValue;
      this.endSliceValue = widget.currentUserProjects.task.length;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    members.add('None');
    setState(() {
      loading = true;
    });
    if (widget.currentUserProjects.task.length >= 5 &&
        widget.currentUserProjects.task.length != 0) {
      setState(() {
        this.dropdownValue = 5;
        this.endSliceValue = 5;
      });
    } else {
      setState(() {
        this.dropdownValue = widget.currentUserProjects.task.length;
        this.endSliceValue = widget.currentUserProjects.task.length;
      });
    }
    setState(() {
      loading = false;
    });
    for (var item in widget.currentUserProjects.promem) {
      if (widget.currentUserData.username != item.member) {
        members.add(item.member);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    print(startSliceValue);
    print(endSliceValue);
    return !loading
        ? Scaffold(
            backgroundColor: Colors.grey[200],
            floatingActionButton: !widget.taskFilter
                ? !widget.add
                    ? !showPagination
                        ? FloatingActionButton(
                            onPressed: () {
                              widget.handleAdd();
                            },
                            child: Icon(Icons.add),
                          )
                        : null
                    : null
                : null,
            body: Stack(children: [
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(bottom: 15.0),
                child: Column(
                  children: [
                    Expanded(
                      child: !widget.taskFilter
                          ? _buildPanel()
                          : _buildPanelFilter(),
                    ),
                    !widget.taskFilter
                        ? !widget.add
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
                                        child:
                                            widget.currentUserProjects.task
                                                        .length >=
                                                    5
                                                ? Container(
                                                    alignment:
                                                        Alignment.bottomCenter,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                        color: Colors.teal),
                                                    child: Row(
                                                      children: [
                                                        IconButton(
                                                            icon: Icon(Icons
                                                                .navigate_before),
                                                            onPressed: startSliceValue !=
                                                                        0 &&
                                                                    endSliceValue !=
                                                                        dropdownValue
                                                                ? dropdownValue !=
                                                                        widget
                                                                            .currentUserProjects
                                                                            .task
                                                                            .length
                                                                    ? endSliceValue !=
                                                                            widget.currentUserProjects.task.length
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
                                                                fontFamily:
                                                                    'CrimsonTextRegular',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                        DropdownButton<int>(
                                                          value: dropdownValue,
                                                          icon: Icon(Icons
                                                              .arrow_downward),
                                                          iconSize: 24,
                                                          elevation: 16,
                                                          dropdownColor:
                                                              Colors.white,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black),
                                                          underline: Container(
                                                            height: 2,
                                                            color: Colors
                                                                .transparent,
                                                          ),
                                                          onChanged:
                                                              (int newValue) {
                                                            if (newValue <=
                                                                widget
                                                                    .currentUserProjects
                                                                    .task
                                                                    .length) {
                                                              setState(() {
                                                                dropdownValue =
                                                                    newValue;
                                                                startSliceValue =
                                                                    0;
                                                                endSliceValue =
                                                                    newValue;
                                                              });
                                                            }
                                                          },
                                                          items: widget.currentUserProjects.task.length > 0 &&
                                                                  widget.currentUserProjects.task.length !=
                                                                      5 &&
                                                                  widget.currentUserProjects.task.length !=
                                                                      10 &&
                                                                  widget
                                                                          .currentUserProjects
                                                                          .task
                                                                          .length !=
                                                                      15
                                                              ? <int>[
                                                                  5,
                                                                  10,
                                                                  15,
                                                                  widget
                                                                      .currentUserProjects
                                                                      .task
                                                                      .length
                                                                ].map<DropdownMenuItem<int>>(
                                                                  (int value) {
                                                                  return DropdownMenuItem<
                                                                      int>(
                                                                    value:
                                                                        value,
                                                                    child: Text(
                                                                        value
                                                                            .toString(),
                                                                        style: TextStyle(
                                                                            fontFamily:
                                                                                'CrimsonTextRegular',
                                                                            fontWeight:
                                                                                FontWeight.bold)),
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
                                                                    value:
                                                                        value,
                                                                    child: Text(
                                                                        value
                                                                            .toString(),
                                                                        style: TextStyle(
                                                                            fontFamily:
                                                                                'CrimsonTextRegular',
                                                                            fontWeight:
                                                                                FontWeight.bold)),
                                                                  );
                                                                }).toList(),
                                                        ),
                                                        Text(' ( ',
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'CrimsonTextRegular',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                        Text(startSliceValue
                                                            .toString()),
                                                        Text(' to ',
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'CrimsonTextRegular',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                        Text(endSliceValue
                                                            .toString()),
                                                        Text(' out of ',
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'CrimsonTextRegular',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                        Text(widget
                                                            .currentUserProjects
                                                            .task
                                                            .length
                                                            .toString()),
                                                        Text(' ) ',
                                                            style: TextStyle(
                                                                fontFamily:
                                                                    'CrimsonTextRegular',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                        Spacer(),
                                                        IconButton(
                                                            icon: Icon(Icons
                                                                .navigate_next),
                                                            onPressed: endSliceValue !=
                                                                    widget
                                                                        .currentUserProjects
                                                                        .task
                                                                        .length
                                                                ? dropdownValue !=
                                                                        widget
                                                                            .currentUserProjects
                                                                            .task
                                                                            .length
                                                                    ? endSliceValue +
                                                                                dropdownValue <=
                                                                            widget.currentUserProjects.task.length
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
                        : Container()
                  ],
                ),
              ),
              !widget.taskFilter
                  ? !showPagination &&
                          widget.currentUserProjects.task.length >= 5
                      ? !widget.add
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
        ? widget.taskFilterData.length > 0
            ? ListView.builder(
                itemCount: widget.taskFilterData.length,
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
                                  data: widget.taskFilterData[index]);
                            },
                          ));
                        },
                        title: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Text(
                              widget.taskFilterData[index].tasks.capitalize(),
                              style: TextStyle(
                                  fontFamily: 'CrimsonTextRegular',
                                  fontWeight: FontWeight.bold)),
                        ),
                        subtitle: Text(
                            DateFormat('yyyy/MM/dd').format(DateTime.parse(
                                widget.taskFilterData[index].timestamp)),
                            style: TextStyle(
                                fontFamily: 'CrimsonTextRegular',
                                fontWeight: FontWeight.bold)),
                        trailing: widget.currentUserData.username ==
                                widget.currentUserProjects.username
                            ? IconButton(
                                icon: Icon(Icons.more_vert),
                                onPressed: () {
                                  _showModalBottomSheet1(
                                      context, widget.taskFilterData[index]);
                                })
                            : IconButton(
                                icon: Icon(
                                  Icons.edit,
                                  color: Colors.grey,
                                ),
                                onPressed: () {
                                  _showBottomMember(
                                      context, widget.taskFilterData[index]);
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
                ),
              )
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
        ? widget.currentUserProjects.task.length > 0
            ? !widget.add
                ? ListView.builder(
                    itemCount: widget.currentUserProjects.task
                        .sublist(startSliceValue, endSliceValue)
                        .length,
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
                                      data: widget.currentUserProjects
                                          .task[index + startSliceValue]);
                                },
                              ));
                            },
                            title: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Text(
                                  widget.currentUserProjects
                                      .task[index + startSliceValue].tasks
                                      .capitalize(),
                                  style: TextStyle(
                                      fontFamily: 'CrimsonTextRegular',
                                      fontWeight: FontWeight.bold)),
                            ),
                            subtitle: Text(
                                DateFormat('yyyy/MM/dd').format(DateTime.parse(
                                    widget
                                        .currentUserProjects
                                        .task[index + startSliceValue]
                                        .timestamp)),
                                style: TextStyle(
                                    fontFamily: 'CrimsonTextRegular',
                                    fontWeight: FontWeight.bold)),
                            trailing: widget.currentUserData.username ==
                                    widget.currentUserProjects.username
                                ? IconButton(
                                    icon: Icon(Icons.more_vert),
                                    onPressed: () {
                                      _showModalBottomSheet1(
                                          context,
                                          widget.currentUserProjects
                                              .task[index + startSliceValue]);
                                    })
                                : IconButton(
                                    icon: Icon(
                                      Icons.edit,
                                      color: Colors.grey,
                                    ),
                                    onPressed: () {
                                      _showBottomMember(
                                          context,
                                          widget.currentUserProjects
                                              .task[index + startSliceValue]);
                                    }),
                          ),
                        ),
                      );
                    })
                : SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 18.0,
                              ),
                              TextField(
                                controller: widget.addController,
                                keyboardType: TextInputType.text,
                                cursorColor: Colors.black,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'CrimsonTextRegular'),
                                decoration: new InputDecoration(
                                  border: new OutlineInputBorder(
                                      borderSide:
                                          new BorderSide(color: Colors.black)),
                                  hintText: 'Task',
                                  labelText: 'Task',
                                ),
                              ),
                              SizedBox(
                                height: 18.0,
                              ),
                              Text('Status',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontFamily: 'CrimsonTextRegular',
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
                                              fontWeight: FontWeight.bold)),
                                      leading: Radio(
                                        value: SingingCharacter.Success,
                                        groupValue: widget.character,
                                        onChanged: (SingingCharacter value) {
                                          widget.handleCharacter(value);
                                        },
                                      ),
                                    ),
                                    ListTile(
                                      title: const Text('Hold',
                                          style: TextStyle(
                                              fontFamily: 'CrimsonTextRegular',
                                              fontWeight: FontWeight.bold)),
                                      leading: Radio(
                                        value: SingingCharacter.Hold,
                                        groupValue: widget.character,
                                        onChanged: (SingingCharacter value) {
                                          widget.handleCharacter(value);
                                        },
                                      ),
                                    ),
                                    ListTile(
                                      title: const Text('Pending',
                                          style: TextStyle(
                                              fontFamily: 'CrimsonTextRegular',
                                              fontWeight: FontWeight.bold)),
                                      leading: Radio(
                                        value: SingingCharacter.Pending,
                                        groupValue: widget.character,
                                        onChanged: (SingingCharacter value) {
                                          widget.handleCharacter(value);
                                        },
                                      ),
                                    ),
                                    ListTile(
                                      title: const Text('Error',
                                          style: TextStyle(
                                              fontFamily: 'CrimsonTextRegular',
                                              fontWeight: FontWeight.bold)),
                                      leading: Radio(
                                        value: SingingCharacter.Error,
                                        groupValue: widget.character,
                                        onChanged: (SingingCharacter value) {
                                          widget.handleCharacter(value);
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 18.0,
                              ),
                              Text('Assigned To',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontFamily: 'CrimsonTextRegular',
                                      fontWeight: FontWeight.bold)),
                              SizedBox(
                                height: 18.0,
                              ),
                              DropdownButton<String>(
                                value: widget.dropdownValue,
                                icon: Icon(Icons.arrow_downward),
                                iconSize: 24,
                                elevation: 16,
                                dropdownColor: Colors.white,
                                focusColor: Colors.white,
                                style: TextStyle(color: Colors.deepPurple),
                                underline: Container(
                                  height: 2,
                                  color: Colors.deepPurpleAccent,
                                ),
                                onChanged: (String newValue) {
                                  widget.handleDropDown(newValue);
                                },
                                items: members.map<DropdownMenuItem<String>>(
                                    (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                              Text('DeadLine',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontFamily: 'CrimsonTextRegular',
                                      fontWeight: FontWeight.bold)),
                              Row(
                                children: [
                                  Spacer(),
                                  Text(
                                    widget.dateTime == null
                                        ? DateFormat('yyyy/MM/dd').format(
                                            DateTime.parse(
                                                DateTime.now().toString()))
                                        : DateFormat('yyyy/MM/dd').format(
                                            DateTime.parse(
                                                widget.dateTime.toString())),
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontFamily: 'CrimsonTextRegular',
                                    ),
                                  ),
                                  IconButton(
                                      icon: Icon(Icons.edit),
                                      onPressed: () {
                                        showDatePicker(
                                                context: context,
                                                initialDate:
                                                    widget.dateTime == null
                                                        ? DateTime.now()
                                                        : widget.dateTime,
                                                firstDate: DateTime(2010),
                                                lastDate: DateTime(2021))
                                            .then((date) async {
                                          await widget.handleDateTime(date);
                                        });
                                      }),
                                  Spacer()
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20))),
                    ),
                  )
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
