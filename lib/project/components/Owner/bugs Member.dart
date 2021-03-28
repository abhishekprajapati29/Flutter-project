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

enum SingingCharacter2 { Success, Hold, Pending, Error }

class MemberBug extends StatefulWidget {
  ProjectModel currentUserProjects;
  UserModel currentUserData;
  bool bugFilterMember;
  List<Bugs> bugFilterDataMember;
  Function handleAdd;
  bool add;
  Function handleCharacter1;
  DateTime dateTime;
  bool bugFilter;
  List<Bugs> bugFilterData;
  List<Bugs> memberBugs;
  Function handleDateTime;
  Function handleDropDown;
  Function handleProjectData;
  String dropdownValue;
  TextEditingController addController;
  Function handleProjectData1;
  MemberBug(
      {Key key,
      this.currentUserData,
      this.memberBugs,
      this.bugFilterDataMember,
      this.bugFilterMember,
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
      this.dateTime,
      this.handleAdd})
      : super(key: key);

  @override
  _MemberBugState createState() => _MemberBugState();
}

class _MemberBugState extends State<MemberBug> {
  Bugs moreOption;
  int dropdownValue = 0;
  int startSliceValue = 0;
  int endSliceValue = 0;
  bool loading = false;
  int sliceValue = 0;
  bool showPagination = false;
  TextEditingController editingController = new TextEditingController();
  SingingCharacter2 editCharacter = SingingCharacter2.Pending;
  DateTime editDateTime;
  List<Bugs> memberBugs = [];
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
                        style: TextStyle(color: Colors.black),
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
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      SizedBox(
                        height: 18.0,
                      ),
                      Container(
                        child: Column(
                          children: [
                            ListTile(
                              title: const Text('Success'),
                              leading: Radio(
                                value: SingingCharacter2.Success,
                                groupValue: editCharacter,
                                onChanged: (SingingCharacter2 value) {
                                  setState(() {
                                    editCharacter = value;
                                  });
                                },
                              ),
                            ),
                            ListTile(
                              title: const Text('Hold'),
                              leading: Radio(
                                value: SingingCharacter2.Hold,
                                groupValue: editCharacter,
                                onChanged: (SingingCharacter2 value) {
                                  setState(() {
                                    editCharacter = value;
                                  });
                                },
                              ),
                            ),
                            ListTile(
                              title: const Text('Pending'),
                              leading: Radio(
                                value: SingingCharacter2.Pending,
                                groupValue: editCharacter,
                                onChanged: (SingingCharacter2 value) {
                                  setState(() {
                                    editCharacter = value;
                                  });
                                },
                              ),
                            ),
                            ListTile(
                              title: const Text('Error'),
                              leading: Radio(
                                value: SingingCharacter2.Error,
                                groupValue: editCharacter,
                                onChanged: (SingingCharacter2 value) {
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
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      Row(
                        children: [
                          Spacer(),
                          Text(
                            editDateTime == null
                                ? DateFormat('yyyy/MM/dd').format(
                                    DateTime.parse(DateTime.now().toString()))
                                : DateFormat('yyyy/MM/dd').format(
                                    DateTime.parse(editDateTime.toString())),
                            style: TextStyle(fontSize: 20),
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
                              });
                            });
                            await editBug(
                                    token,
                                    widget.currentUserProjects,
                                    editingController.text,
                                    DateFormat('yyyy-MM-dd').format(
                                        DateTime.parse(
                                            editDateTime.toString())),
                                    editCharacter.toString().substring(18),
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
                              style: TextStyle(color: Colors.white)))
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
          ? SingingCharacter2.Error
          : data.status == 'Pending'
              ? SingingCharacter2.Pending
              : data.status == 'Success'
                  ? SingingCharacter2.Success
                  : data.status == 'Hold' ? SingingCharacter2.Hold : null;
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
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      SizedBox(
                        height: 18.0,
                      ),
                      Container(
                        child: Column(
                          children: [
                            ListTile(
                              title: const Text('Success'),
                              leading: Radio(
                                value: SingingCharacter2.Success,
                                groupValue: editCharacter,
                                onChanged: (SingingCharacter2 value) {
                                  setState(() {
                                    editCharacter = value;
                                  });
                                },
                              ),
                            ),
                            ListTile(
                              title: const Text('Hold'),
                              leading: Radio(
                                value: SingingCharacter2.Hold,
                                groupValue: editCharacter,
                                onChanged: (SingingCharacter2 value) {
                                  setState(() {
                                    editCharacter = value;
                                  });
                                },
                              ),
                            ),
                            ListTile(
                              title: const Text('Pending'),
                              leading: Radio(
                                value: SingingCharacter2.Pending,
                                groupValue: editCharacter,
                                onChanged: (SingingCharacter2 value) {
                                  setState(() {
                                    editCharacter = value;
                                  });
                                },
                              ),
                            ),
                            ListTile(
                              title: const Text('Error'),
                              leading: Radio(
                                value: SingingCharacter2.Error,
                                groupValue: editCharacter,
                                onChanged: (SingingCharacter2 value) {
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
                                    editCharacter.toString().substring(18),
                                    moreOption.id)
                                .then((value) async {
                              setState(() {
                                memberBugs = value.bugs;
                              });
                              await widget.handleProjectData(value);
                              await widget.handleProjectData1(value);
                              Navigator.pop(context);
                            });
                          },
                          color: Colors.teal,
                          icon: Icon(Icons.edit, color: Colors.white),
                          label: Text('Edit',
                              style: TextStyle(color: Colors.white)))
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
          ? SingingCharacter2.Error
          : item.status == 'Pending'
              ? SingingCharacter2.Pending
              : item.status == 'Success'
                  ? SingingCharacter2.Success
                  : item.status == 'Hold' ? SingingCharacter2.Hold : null;
      editDateTime = DateTime.parse(item.dueDate);
    });
    _showModalBottomSheet(context);
  }

  _handleDelete(moreOption) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text("Delete Bug"),
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
    if (endSliceValue + dropdownValue <= memberBugs.length) {
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
    int data = memberBugs.length;
    while (data % dropdownValue != 0) {
      this.setState(() {
        data = data - 1;
      });
    }
    final int minusData = memberBugs.length - data;
    setState(() {
      this.startSliceValue = endSliceValue - dropdownValue - minusData;
      this.endSliceValue = endSliceValue - minusData;
    });
  }

  void _incrementDateToItsEnd() {
    setState(() {
      this.startSliceValue = endSliceValue;
      this.endSliceValue = memberBugs.length;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    members.add('None');
    setState(() {
      loading = true;
      memberBugs = widget.memberBugs;
    });
    if (memberBugs.length >= 5 && memberBugs.length != 0) {
      setState(() {
        this.dropdownValue = 5;
        this.endSliceValue = 5;
      });
    } else {
      setState(() {
        this.dropdownValue = memberBugs.length;
        this.endSliceValue = memberBugs.length;
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
                      child: !widget.bugFilterMember
                          ? _buildPanel()
                          : _buildPanelFilter(),
                    ),
                    !widget.bugFilterMember
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
                                    child: memberBugs.length >= 5
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
                                                                memberBugs
                                                                    .length
                                                            ? endSliceValue !=
                                                                    memberBugs
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
                                                Text('Rows : '),
                                                DropdownButton<int>(
                                                  value: dropdownValue,
                                                  icon: Icon(
                                                      Icons.arrow_downward),
                                                  iconSize: 24,
                                                  elevation: 16,
                                                  dropdownColor: Colors.white,
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                  underline: Container(
                                                    height: 2,
                                                    color: Colors.transparent,
                                                  ),
                                                  onChanged: (int newValue) {
                                                    if (newValue <=
                                                        memberBugs.length) {
                                                      setState(() {
                                                        dropdownValue =
                                                            newValue;
                                                        startSliceValue = 0;
                                                        endSliceValue =
                                                            newValue;
                                                      });
                                                    }
                                                  },
                                                  items: memberBugs.length >
                                                              0 &&
                                                          memberBugs.length !=
                                                              5 &&
                                                          memberBugs.length !=
                                                              10 &&
                                                          memberBugs.length !=
                                                              15
                                                      ? <int>[
                                                          5,
                                                          10,
                                                          15,
                                                          memberBugs.length
                                                        ].map<DropdownMenuItem<int>>(
                                                          (int value) {
                                                          return DropdownMenuItem<
                                                              int>(
                                                            value: value,
                                                            child: Text(value
                                                                .toString()),
                                                          );
                                                        }).toList()
                                                      : <int>[5, 10, 15].map<
                                                              DropdownMenuItem<
                                                                  int>>(
                                                          (int value) {
                                                          return DropdownMenuItem<
                                                              int>(
                                                            value: value,
                                                            child: Text(value
                                                                .toString()),
                                                          );
                                                        }).toList(),
                                                ),
                                                Text(' ( '),
                                                Text(
                                                    startSliceValue.toString()),
                                                Text(' to '),
                                                Text(endSliceValue.toString()),
                                                Text(' out of '),
                                                Text(memberBugs.length
                                                    .toString()),
                                                Text(' ) '),
                                                Spacer(),
                                                IconButton(
                                                    icon: Icon(
                                                        Icons.navigate_next),
                                                    onPressed: endSliceValue !=
                                                            memberBugs.length
                                                        ? dropdownValue !=
                                                                memberBugs
                                                                    .length
                                                            ? endSliceValue +
                                                                        dropdownValue <=
                                                                    memberBugs
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
              !widget.bugFilter
                  ? !showPagination
                      ? memberBugs.length >= 5
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
    print(members);
    return !loading
        ? widget.bugFilterDataMember.length > 0
            ? ListView.builder(
                itemCount: widget.bugFilterDataMember.length,
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
                                  data: widget.bugFilterDataMember[index]);
                            },
                          ));
                        },
                        title: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Text(widget.bugFilterDataMember[index].bugs,
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        subtitle: Text(DateFormat('yyyy/MM/dd').format(
                            DateTime.parse(
                                widget.bugFilterDataMember[index].timestamp))),
                        trailing: widget.currentUserData.username ==
                                widget.currentUserProjects.username
                            ? IconButton(
                                icon: Icon(Icons.more_vert),
                                onPressed: () {
                                  _showModalBottomSheet1(context,
                                      widget.bugFilterDataMember[index]);
                                })
                            : IconButton(
                                icon: Icon(
                                  Icons.edit,
                                  color: Colors.grey,
                                ),
                                onPressed: () {
                                  _showBottomMember(context,
                                      widget.bugFilterDataMember[index]);
                                }),
                      ),
                    ),
                  );
                })
            : Container(
                height: MediaQuery.of(context).size.height,
                child: Center(
                  child: Text('No Bugs'),
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
        ? memberBugs.length > 0
            ? ListView.builder(
                itemCount:
                    memberBugs.sublist(startSliceValue, endSliceValue).length,
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
                                  data: memberBugs[index + startSliceValue]);
                            },
                          ));
                        },
                        title: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Text(memberBugs[index + startSliceValue].bugs,
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        subtitle: Text(DateFormat('yyyy/MM/dd').format(
                            DateTime.parse(memberBugs[index + startSliceValue]
                                .timestamp))),
                        trailing: widget.currentUserData.username ==
                                widget.currentUserProjects.username
                            ? IconButton(
                                icon: Icon(Icons.more_vert),
                                onPressed: () {
                                  _showModalBottomSheet1(context,
                                      memberBugs[index + startSliceValue]);
                                })
                            : IconButton(
                                icon: Icon(
                                  Icons.edit,
                                  color: Colors.grey,
                                ),
                                onPressed: () {
                                  _showBottomMember(context,
                                      memberBugs[index + startSliceValue]);
                                }),
                      ),
                    ),
                  );
                })
            : Container(
                height: MediaQuery.of(context).size.height,
                child: Center(
                  child: Text('No Task'),
                ))
        : Container(
            height: MediaQuery.of(context).size.height,
            child: Center(
              child: SpinKitFoldingCube(color: Colors.teal),
            ),
          );
  }
}
