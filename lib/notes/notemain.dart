import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fproject/DashBoard/Drawer.dart';
import 'package:fproject/gettoken.dart';
import 'package:fproject/notes/components/addnotes.dart';
import 'package:intl/intl.dart';
import 'components/api_resopnse.dart';
import 'components/models.dart';
import 'components/notes.dart';

class NoteMain extends StatefulWidget {
  NoteMain({Key key}) : super(key: key);

  @override
  _NoteMainState createState() => _NoteMainState();
}

class _NoteMainState extends State<NoteMain> {
  int selectedIndex = 0;
  bool largeView = true;
  int moveToIndex = 0;
  bool search = false;
  int startSliceValue = 0;
  int endSliceValue = 0;
  int sliceValue = 0;
  List<NotesItem> _allData = [];
  int dropdownValue = 0;
  bool initalLoading = false;
  List<NotesItem> _searchData = [];
  List<Notechip> _chipdata = [];

  void _handleLargeView() {
    setState(() {
      this.largeView = !largeView;
    });
  }

  TextEditingController searchText = new TextEditingController();
  String _token = '';
  @override
  void initState() {
    super.initState();
    setState(() {
      initalLoading = true;
    });
    getTokenPreferences().then(_updateToken);
    searchText.addListener(searchData);
  }

  void _updatechip(List<Notechip> data) {
    setState(() {
      this._chipdata = data;
      this.initalLoading = false;
    });
  }

  _updateToken(String token) {
    setState(() {
      this._token = token;
    });
    getNoteData(token).then(_updateData);
  }

  _updateData(List<NotesItem> data) {
    setState(() {
      this._allData = data;
      this._searchData = data;
    });
    if (_allData.length >= 5 && _allData.length != 0) {
      setState(() {
        this.dropdownValue = 5;
        this.endSliceValue = 5;
      });
    } else {
      setState(() {
        this.dropdownValue = _allData.length;
        this.endSliceValue = _allData.length;
      });
    }
    chipsNotes().then(_updatechip);
  }

  void _updateData1(List<NotesItem> data) {
    setState(() {
      this._allData = data;
    });
  }

  void searchUpdate() {
    if (_searchData.length >= 5 && _searchData.length != 0) {
      setState(() {
        this.dropdownValue = 5;
        this.endSliceValue = 5;
      });
    } else {
      setState(() {
        this.dropdownValue = _searchData.length;
        this.endSliceValue = _searchData.length;
      });
    }
    setState(() {
      _allData = _searchData;
      this.search = !search;
      searchText.text = "";
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

  searchData() {
    print(searchText.text);
    List<NotesItem> searchmodified = _searchData
        .where((element) => element.noteTitle.startsWith(searchText.text))
        .toList();
    print(searchmodified.length);
    _updateData1(searchmodified);
  }

  void allFilter() {
    if (_searchData.length >= 5 && _searchData.length != 0) {
      setState(() {
        this.startSliceValue = 0;
        this.dropdownValue = 5;
        this.endSliceValue = 5;
      });
    } else {
      setState(() {
        this.startSliceValue = 0;
        this.dropdownValue = _searchData.length;
        this.endSliceValue = _searchData.length;
      });
    }
    _updateData1(_searchData);
  }

  void todayFilter() {
    DateTime date = DateTime.now();
    String formattedDate = DateFormat('yyyy/MM/dd').format(date);
    List<NotesItem> searchmodified = _searchData
        .where((element) =>
            DateFormat('yyyy/MM/dd')
                .format(DateTime.parse(element.timestamp)) ==
            formattedDate)
        .toList();
    if (searchmodified.length >= 5 && searchmodified.length != 0) {
      setState(() {
        this.startSliceValue = 0;
        this.dropdownValue = 5;
        this.endSliceValue = 5;
      });
    } else {
      setState(() {
        this.startSliceValue = 0;
        this.dropdownValue = searchmodified.length;
        this.endSliceValue = searchmodified.length;
      });
    }

    _updateData1(searchmodified);
  }

  void monthFilter() {
    DateTime now = DateTime.now();
    var month = new DateTime(now.year, now.month - 1, now.day);
    List<NotesItem> searchmodified = _searchData.where((element) {
      DateTime date = DateTime.parse(element.timestamp);
      return month.isBefore(date);
    }).toList();

    if (searchmodified.length >= 5 && searchmodified.length != 0) {
      setState(() {
        this.startSliceValue = 0;
        this.dropdownValue = 5;
        this.endSliceValue = 5;
      });
    } else {
      setState(() {
        this.startSliceValue = 0;
        this.dropdownValue = searchmodified.length;
        this.endSliceValue = searchmodified.length;
      });
    }

    _updateData1(searchmodified);
  }

  void yearFilter() {
    DateTime now = DateTime.now();
    var month = new DateTime(now.year - 1, now.month, now.day);
    List<NotesItem> searchmodified = _searchData.where((element) {
      DateTime date = DateTime.parse(element.timestamp);
      return month.isBefore(date);
    }).toList();

    if (searchmodified.length >= 5 && searchmodified.length != 0) {
      setState(() {
        this.startSliceValue = 0;
        this.dropdownValue = 5;
        this.endSliceValue = 5;
      });
    } else {
      setState(() {
        this.startSliceValue = 0;
        this.dropdownValue = searchmodified.length;
        this.endSliceValue = searchmodified.length;
      });
    }

    _updateData1(searchmodified);
  }

  Future<void> chipFilter() async {
    switch (await showDialog<int>(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text('Choose Chips'),
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, 1);
                },
                child: const Text('Now'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, 2);
                },
                child: const Text('Urgent'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, 3);
                },
                child: const Text('Meeting'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, 4);
                },
                child: const Text('Work'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, 5);
                },
                child: const Text('Home'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, 6);
                },
                child: const Text('Today'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, 7);
                },
                child: const Text('School'),
              ),
            ],
          );
        })) {
      case 1:
        filterchips('Now');
        break;
      case 2:
        filterchips('Urgent');
        break;
      case 3:
        filterchips('Meeting');
        break;
      case 4:
        filterchips('Work');
        break;
      case 5:
        filterchips('Home');
        break;
      case 6:
        filterchips('Today');
        break;
      case 7:
        filterchips('School');
        break;
    }
  }

  filterchips(String chip) {
    List<int> ids = [];

    for (var item in _chipdata) {
      if (item.noteChips == chip) {
        ids.add(item.notechip);
      }
    }
    final check = _searchData.where((element) {
      return ids.indexOf(element.id) != -1;
    }).toList();
    if (check.length >= 5 && check.length != 0) {
      setState(() {
        this.startSliceValue = 0;
        this.dropdownValue = 5;
        this.endSliceValue = 5;
      });
    } else {
      setState(() {
        this.startSliceValue = 0;
        this.dropdownValue = check.length;
        this.endSliceValue = check.length;
      });
    }
    List<NotesItem> finaldata = [];
    if (ids.length > 0) {
      finaldata = check;
    }

    _updateData1(finaldata);
  }

  addData(note) {
    chipsNotes().then(_updatechip);
    setState(() {
      _allData = [note, ..._allData];
      _searchData = [note, ..._searchData];
    });
    if (_allData.length >= 5 && _allData.length != 0) {
      setState(() {
        this.startSliceValue = 0;
        this.dropdownValue = 5;
        this.endSliceValue = 5;
      });
    } else {
      setState(() {
        this.startSliceValue = 0;
        this.dropdownValue = _allData.length;
        this.endSliceValue = _allData.length;
      });
    }
  }

  void _incrementData() {
    if (endSliceValue + dropdownValue <= _allData.length) {
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
    int data = _allData.length;
    if (data % dropdownValue != 0) {
      while (data % dropdownValue != 0) {
        this.setState(() {
          data = data - 1;
        });
      }
      final int minusData = _allData.length - data;
      setState(() {
        this.startSliceValue = endSliceValue - dropdownValue - minusData;
        this.endSliceValue = endSliceValue - minusData;
      });
    } else {
      setState(() {
        this.startSliceValue = startSliceValue - dropdownValue;
        this.endSliceValue = endSliceValue - dropdownValue;
      });
    }
  }

  void _incrementDateToItsEnd() {
    setState(() {
      this.startSliceValue = endSliceValue;
      this.endSliceValue = _allData.length;
    });
  }

  void updateEditData(NotesItem data) {
    print(data.id);
    for (var item in _allData) {
      print(item.id);
    }
    final List<NotesItem> remainData =
        _searchData.where((element) => element.id != data.id).toList();
    final List<NotesItem> reaminData1 = [data, ...remainData]
      ..sort((a, b) => b.id.compareTo(a.id));
    setState(() {
      _allData = reaminData1;
      _searchData = reaminData1;
    });
  }

  void updateDeleteAndData(data) {
    final afterDelete =
        _searchData.where((element) => element.id != data.id).toList();
    setState(() {
      this._allData = afterDelete;
      this._searchData = afterDelete;
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
        backgroundColor: Colors.grey[200],
        drawer: MyDrawer(),
        appBar: AppBar(
          backgroundColor: search ? Colors.white : Colors.teal,
          leading: search
              ? IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.grey,
                  ),
                  onPressed: searchUpdate)
              : null,
          title: !search
              ? Text('Notes')
              : TextField(
                  controller: searchText,
                  cursorColor: Colors.black,
                  keyboardType: TextInputType.text,
                  decoration: new InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    contentPadding:
                        EdgeInsets.only(left: 0, bottom: 11, top: 11, right: 0),
                    hintText: 'Search',
                  ),
                ),
          actions: !search
              ? [
                  IconButton(icon: Icon(Icons.search), onPressed: searchUpdate),
                  PopupMenuButton<String>(
                    icon: Icon(Icons.filter_list),
                    onSelected: (String result) {
                      if (result == 'All') {
                        allFilter();
                      }
                      if (result == 'Today') {
                        todayFilter();
                      }
                      if (result == 'Month') {
                        monthFilter();
                      }
                      if (result == 'Year') {
                        yearFilter();
                      }
                      if (result == 'chip') {
                        chipFilter();
                      }
                    },
                    itemBuilder: (BuildContext context) =>
                        <PopupMenuEntry<String>>[
                      const PopupMenuItem<String>(
                        value: "All",
                        child: Text('All'),
                      ),
                      const PopupMenuItem<String>(
                        value: "Today",
                        child: Text('Today'),
                      ),
                      const PopupMenuItem<String>(
                        value: "Month",
                        child: Text('Month'),
                      ),
                      const PopupMenuItem<String>(
                        value: "Year",
                        child: Text('Year'),
                      ),
                      const PopupMenuItem<String>(
                          value: 'chip', child: Text('Chips')),
                    ],
                  ),
                  IconButton(
                      icon: largeView
                          ? Icon(FontAwesomeIcons.list)
                          : Icon(FontAwesomeIcons.thLarge),
                      onPressed: () => _handleLargeView())
                ]
              : [
                  IconButton(
                      icon: Icon(
                        Icons.clear,
                        color: Colors.grey,
                      ),
                      onPressed: () => clearData())
                ],
        ),
        body: initalLoading == false
            ? WillPopScope(
                onWillPop: onWillPop,
                child: Notes(
                    data: _allData,
                    search: search,
                    searchData: _searchData,
                    loading: initalLoading,
                    largeView: largeView,
                    startSliceValue: startSliceValue,
                    endSliceValue: endSliceValue,
                    dropdownValue: dropdownValue,
                    updateEditData: updateEditData,
                    updateDeleteAndData: updateDeleteAndData),
              )
            : Container(
                color: Colors.white,
                height: MediaQuery.of(context).size.height,
                child: Center(
                  child: SpinKitFoldingCube(color: Colors.teal),
                ),
              ),
        bottomNavigationBar: initalLoading == false
            ? !search
                ? _allData.length > 0
                    ? BottomAppBar(
                        elevation: 5,
                        shape: const CircularNotchedRectangle(),
                        color: Colors.teal,
                        child: Container(
                          height: 50,
                          alignment: Alignment.centerLeft,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Container(
                              alignment: Alignment.center,
                              width: MediaQuery.of(context).size.width * 0.80,
                              color: Colors.transparent,
                              child: Row(
                                children: [
                                  IconButton(
                                      icon: Icon(Icons.navigate_before),
                                      onPressed: startSliceValue != 0 &&
                                              endSliceValue != dropdownValue
                                          ? dropdownValue != _allData.length
                                              ? endSliceValue != _allData.length
                                                  ? () {
                                                      _decrementData();
                                                    }
                                                  : () {
                                                      _decrementEndData();
                                                    }
                                              : null
                                          : null),
                                  DropdownButton<int>(
                                    value: dropdownValue,
                                    icon: Icon(Icons.arrow_downward),
                                    iconSize: 14,
                                    elevation: 16,
                                    dropdownColor: Colors.white,
                                    style: TextStyle(color: Colors.black),
                                    underline: Container(
                                      height: 2,
                                      color: Colors.transparent,
                                    ),
                                    onChanged: (int newValue) {
                                      if (newValue <= _allData.length) {
                                        setState(() {
                                          dropdownValue = newValue;
                                          startSliceValue = 0;
                                          endSliceValue = newValue;
                                        });
                                      }
                                    },
                                    items: _allData.length > 0 &&
                                            _allData.length != 5 &&
                                            _allData.length != 10 &&
                                            _allData.length != 15
                                        ? <int>[5, 10, 15, _allData.length]
                                            .map<DropdownMenuItem<int>>(
                                                (int value) {
                                            return DropdownMenuItem<int>(
                                              value: value,
                                              child: Text(value.toString()),
                                            );
                                          }).toList()
                                        : <int>[5, 10, 15]
                                            .map<DropdownMenuItem<int>>(
                                                (int value) {
                                            return DropdownMenuItem<int>(
                                              value: value,
                                              child: Text(value.toString()),
                                            );
                                          }).toList(),
                                  ),
                                  Text(' ( '),
                                  Text(startSliceValue.toString()),
                                  Text(' to '),
                                  Text(endSliceValue.toString()),
                                  Text(' out of '),
                                  Text(_allData.length.toString()),
                                  Text(' ) '),
                                  IconButton(
                                      icon: Icon(Icons.navigate_next),
                                      onPressed: endSliceValue !=
                                              _allData.length
                                          ? dropdownValue != _allData.length
                                              ? endSliceValue + dropdownValue <=
                                                      _allData.length
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
                            ),
                          ),
                        ),
                      )
                    : null
                : null
            : null,
        floatingActionButton: !initalLoading
            ? !search
                ? FloatingActionButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return AddNote(
                          token: _token,
                          addData: addData,
                        );
                      }));
                    },
                    child: Icon(FontAwesomeIcons.plus),
                    backgroundColor: Colors.red,
                  )
                : null
            : null,
        floatingActionButtonLocation: _allData.length > 0
            ? FloatingActionButtonLocation.endDocked
            : FloatingActionButtonLocation.endFloat,
      ),
    );
  }
}
