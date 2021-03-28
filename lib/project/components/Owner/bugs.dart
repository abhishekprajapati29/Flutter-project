import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fproject/Auth/login/fabeanimation.dart';
import 'package:fproject/Team/model.dart';
import 'package:fproject/project/components/Owner/bugview.dart';
import 'package:fproject/project/components/api_response.dart';
import 'package:fproject/project/components/models.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../gettoken.dart';

enum SingingCharacter { Success, Hold, Pending, Error }

class OwnerBug extends StatefulWidget {
  ProjectModel currentUserProjects;
  UserModel currentUserData;
  Function handleAdd;
  bool add;
  Function handleCharacter1;
  DateTime dateTime;
  bool bugFilter;
  List<Bugs> bugFilterData;
  Function handleDateTime;
  Function handleDropDown;
  Function handleProjectData;
  String dropdownValue;
  SingingCharacter character1;
  TextEditingController addController;
  Function handleProjectData1;
  OwnerBug(
      {Key key,
      this.currentUserData,
      this.currentUserProjects,
      this.add,
      this.bugFilter,
      this.bugFilterData,
      this.handleProjectData,
      this.dropdownValue,
      this.handleDropDown,
      this.handleDateTime,
      this.handleProjectData1,
      this.handleCharacter1,
      this.addController,
      this.character1,
      this.dateTime,
      this.handleAdd})
      : super(key: key);

  @override
  _OwnerBugState createState() => _OwnerBugState();
}

class _OwnerBugState extends State<OwnerBug> {
  Bugs moreOption;
  int dropdownValue = 0;
  int startSliceValue = 0;
  int endSliceValue = 0;
  bool loading = false;
  int sliceValue = 0;
  bool editbugLoading = false;
  bool addbugLoading = false;
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
                            fontFamily: 'CrimsonTextRegular',
                            fontWeight: FontWeight.bold),
                        decoration: new InputDecoration(
                          border: new OutlineInputBorder(
                              borderSide: new BorderSide(color: Colors.black)),
                          hintText: 'Bug',
                          labelText: 'Bug',
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
                              fontSize: 20,
                              fontFamily: 'CrimsonTextRegular',
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
                                fontFamily: 'CrimsonTextRegular',
                                fontWeight: FontWeight.bold,
                                fontSize: 20),
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
                          onPressed: !editbugLoading
                              ? () async {
                                  await getTokenPreferences().then((data) {
                                    setState(() {
                                      token = data;
                                      editbugLoading = true;
                                    });
                                  });
                                  await editBug(
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
                                    await widget.handleProjectData(value);
                                    await widget.handleProjectData1(value);
                                    setState(() {
                                      editbugLoading = false;
                                    });
                                    Navigator.pop(context);
                                  });
                                }
                              : null,
                          color: Colors.teal,
                          icon: Icon(Icons.edit, color: Colors.white),
                          label: !editbugLoading
                              ? Text('Edit',
                                  style: TextStyle(
                                      fontFamily: 'CrimsonTextRegular',
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white))
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
                        height: 20.0,
                      ),
                      RaisedButton.icon(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          onPressed: () async {
                            await getTokenPreferences().then((data) {
                              setState(() {
                                token = data;
                              });
                            });
                            await editBugMember(
                                    token,
                                    widget.currentUserProjects,
                                    editCharacter.toString().substring(17),
                                    moreOption.id)
                                .then((value) async {
                              await widget.handleProjectData(value);
                              await widget.handleProjectData1(value);
                              Navigator.pop(context);
                            });
                          },
                          color: Colors.teal,
                          icon: Icon(Icons.edit, color: Colors.white),
                          label: Text('Edit',
                              style: TextStyle(
                                  fontFamily: 'CrimsonTextRegular',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)))
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
    setState(() {
      this.moreOption = item;
      editingController.text = item.bugs;
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
            title: Text("Delete Bug",
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
                  deleteBug(moreOption.id, token, widget.currentUserProjects)
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
        widget.currentUserProjects.bugs.length) {
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
    int data = widget.currentUserProjects.bugs.length;
    while (data % dropdownValue != 0) {
      this.setState(() {
        data = data - 1;
      });
    }
    final int minusData = widget.currentUserProjects.bugs.length - data;
    setState(() {
      this.startSliceValue = endSliceValue - dropdownValue - minusData;
      this.endSliceValue = endSliceValue - minusData;
    });
  }

  void _incrementDateToItsEnd() {
    setState(() {
      this.startSliceValue = endSliceValue;
      this.endSliceValue = widget.currentUserProjects.bugs.length;
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
    if (widget.currentUserProjects.bugs.length >= 5 &&
        widget.currentUserProjects.bugs.length != 0) {
      setState(() {
        this.dropdownValue = 5;
        this.endSliceValue = 5;
      });
    } else {
      setState(() {
        this.dropdownValue = widget.currentUserProjects.bugs.length;
        this.endSliceValue = widget.currentUserProjects.bugs.length;
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
            floatingActionButton: !widget.bugFilter
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
                      child: !widget.bugFilter
                          ? _buildPanel()
                          : _buildPanelFilter(),
                    ),
                    !widget.bugFilter
                        ? !widget.add
                            ? showPagination
                                ? FadeAnimation(
                                    0.5,
                                    Dismissible(
                                      key: Key('bugs'),
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
                                            widget.currentUserProjects.bugs
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
                                                                            .bugs
                                                                            .length
                                                                    ? endSliceValue !=
                                                                            widget.currentUserProjects.bugs.length
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
                                                                    .bugs
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
                                                          items: widget.currentUserProjects.bugs.length > 0 &&
                                                                  widget.currentUserProjects.bugs.length !=
                                                                      5 &&
                                                                  widget.currentUserProjects.bugs.length !=
                                                                      10 &&
                                                                  widget
                                                                          .currentUserProjects
                                                                          .bugs
                                                                          .length !=
                                                                      15
                                                              ? <int>[
                                                                  5,
                                                                  10,
                                                                  15,
                                                                  widget
                                                                      .currentUserProjects
                                                                      .bugs
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
                                                            .bugs
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
                                                                        .bugs
                                                                        .length
                                                                ? dropdownValue !=
                                                                        widget
                                                                            .currentUserProjects
                                                                            .bugs
                                                                            .length
                                                                    ? endSliceValue +
                                                                                dropdownValue <=
                                                                            widget.currentUserProjects.bugs.length
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
              !widget.bugFilter
                  ? !widget.add
                      ? !showPagination
                          ? widget.currentUserProjects.bugs.length >= 5
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
                                  top: MediaQuery.of(context).size.height *
                                      0.725,
                                )
                              : Container()
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
    print(members);
    return !loading
        ? widget.bugFilterData.length > 0
            ? ListView.builder(
                itemCount: widget.bugFilterData.length,
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
                              return BugView(data: widget.bugFilterData[index]);
                            },
                          ));
                        },
                        title: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Text(widget.bugFilterData[index].bugs,
                              style: TextStyle(
                                  fontFamily: 'CrimsonTextRegular',
                                  fontWeight: FontWeight.bold)),
                        ),
                        subtitle: Text(
                            DateFormat('yyyy/MM/dd').format(DateTime.parse(
                                widget.bugFilterData[index].timestamp)),
                            style: TextStyle(
                                fontFamily: 'CrimsonTextRegular',
                                fontWeight: FontWeight.bold)),
                        trailing: widget.currentUserData.username ==
                                widget.currentUserProjects.username
                            ? IconButton(
                                icon: Icon(Icons.more_vert),
                                onPressed: () {
                                  _showModalBottomSheet1(
                                      context, widget.bugFilterData[index]);
                                })
                            : IconButton(
                                icon: Icon(
                                  Icons.edit,
                                  color: Colors.grey,
                                ),
                                onPressed: () {
                                  _showBottomMember(
                                      context, widget.bugFilterData[index]);
                                }),
                      ),
                    ),
                  );
                })
            : Container(
                height: MediaQuery.of(context).size.height,
                child: Center(
                  child: Text('No Bugs',
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
        ? widget.currentUserProjects.bugs.length > 0
            ? !widget.add
                ? ListView.builder(
                    itemCount: widget.currentUserProjects.bugs
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
                                  return BugView(
                                      data: widget.currentUserProjects
                                          .bugs[index + startSliceValue]);
                                },
                              ));
                            },
                            title: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Text(
                                  widget.currentUserProjects
                                      .bugs[index + startSliceValue].bugs,
                                  style: TextStyle(
                                      fontFamily: 'CrimsonTextRegular',
                                      fontWeight: FontWeight.bold)),
                            ),
                            subtitle: Text(
                                DateFormat('yyyy/MM/dd').format(DateTime.parse(
                                    widget
                                        .currentUserProjects
                                        .bugs[index + startSliceValue]
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
                                              .bugs[index + startSliceValue]);
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
                                              .bugs[index + startSliceValue]);
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
                                    fontFamily: 'CrimsonTextRegular',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                                decoration: new InputDecoration(
                                  border: new OutlineInputBorder(
                                      borderSide:
                                          new BorderSide(color: Colors.black)),
                                  hintText: 'Bug',
                                  labelText: 'Bug',
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
                                        groupValue: widget.character1,
                                        onChanged: (SingingCharacter value) {
                                          widget.handleCharacter1(value);
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
                                        groupValue: widget.character1,
                                        onChanged: (SingingCharacter value) {
                                          widget.handleCharacter1(value);
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
                                        groupValue: widget.character1,
                                        onChanged: (SingingCharacter value) {
                                          widget.handleCharacter1(value);
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
                                        groupValue: widget.character1,
                                        onChanged: (SingingCharacter value) {
                                          widget.handleCharacter1(value);
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
                                focusColor: Colors.white,
                                dropdownColor: Colors.white,
                                iconSize: 24,
                                elevation: 16,
                                style: TextStyle(
                                    fontFamily: 'CrimsonTextRegular',
                                    color: Colors.deepPurple),
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
                                        fontFamily: 'CrimsonTextRegular',
                                        fontSize: 20),
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
