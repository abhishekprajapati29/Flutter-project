import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fproject/Auth/login/login.dart';
import 'package:fproject/DashBoard/Drawer.dart';
import 'package:fproject/DashBoard/dashboard.dart';
import 'package:fproject/notes/notemain.dart';
import 'package:fproject/todo/components/Add/add.dart';
import 'package:fproject/todo/components/Add/edit.dart';
import 'package:fproject/todo/components/completed.dart';
import 'package:fproject/todo/components/pending.dart';
import '../gettoken.dart';
import 'components/api_response.dart';
import 'components/models.dart';
import 'package:intl/intl.dart';

GlobalKey<_TodoState> globalKey = GlobalKey();

/// This Widget is the main application widget.
class Todo extends StatefulWidget {
  static const String _title = 'To Do';

  @override
  _TodoState createState() => _TodoState();
}

class _TodoState extends State<Todo> {
  int selectedIndex = 0;
  int moveToIndex = 0;
  bool search = false;
  Item editData;
  bool filter = false;

  void editDataFunction(Item data) {
    setState(() {
      this.editData = data;
    });
  }

  void editDataNullFunction() {
    setState(() {
      this.editData = null;
    });
    onItemTapped1(moveToIndex);
  }

  void onItemTapped1(int index) {
    setState(() {
      selectedIndex = index;
    });
    if (index == 0) {
      final List<Item> pendingData =
          _allData.where((fil) => fil.completed == false).toList();
      final pendingcount = pendingData.length;
      setState(() {
        _pendingData = pendingData;
        _pendingDataLength = pendingcount;
      });
    }
    if (index == 2) {
      final List<Item> completedData =
          _allData.where((fil) => fil.completed == true).toList();
      final completedCount = completedData.length;
      setState(() {
        _completedData = completedData;
        _completedDataLength = completedCount;
      });
    }
  }

  void onItemTapped(int index, int index1) {
    setState(() {
      selectedIndex = index;
      moveToIndex = index1;
    });
  }

  List<Item> _allData = [];
  List<Item> _pendingData = [];
  List<Item> _completedData = [];
  int _pendingDataLength = 0;
  int _completedDataLength = 0;
  List<Todochip> _chipdata = [];
  bool initalLoading = false;
  TextEditingController searchText = new TextEditingController();

  @override
  void initState() {
    super.initState();
    setState(() {
      initalLoading = true;
    });
    getTokenPreferences().then(_updateToken);
    searchText.addListener(searchData);
    chipsTodo().then(_updatechip);
  }

  void _updatechip(List<Todochip> data) {
    this._chipdata = data;
  }

  void _updateToken(String token) {
    getTodoData(token).then(_updateData);
  }

  void _updateData(List<Item> data) {
    final List<Item> pendingData =
        data.where((fil) => fil.completed == false).toList();
    final List<Item> completedData =
        data.where((fil) => fil.completed == true).toList();
    final pendingcount = pendingData.length;
    final completedcount = completedData.length;
    print(pendingcount);
    print(completedcount);
    chipsTodo().then(_updatechip);
    setState(() {
      this._allData = data;
      this._pendingData = pendingData;
      this._completedData = completedData;
      this._pendingDataLength = pendingcount;
      this._completedDataLength = completedcount;
      this.initalLoading = false;
    });
  }

  void _updateData1(List<Item> data) {
    final List<Item> pendingData =
        data.where((fil) => fil.completed == false).toList();
    final List<Item> completedData =
        data.where((fil) => fil.completed == true).toList();
    final pendingcount = pendingData.length;
    final completedcount = completedData.length;
    print(pendingcount);
    print(completedcount);
    chipsTodo().then(_updatechip);
    setState(() {
      this._pendingData = pendingData;
      this._completedData = completedData;
      this._pendingDataLength = pendingcount;
      this._completedDataLength = completedcount;
    });
  }

  void updateAddData(Item data) {
    setState(() {
      this._pendingData = [data, ...this._pendingData];
      this._allData = [data, ...this._allData];
      this._pendingDataLength = _pendingDataLength + 1;
    });
  }

  void updateEditData(Item data) {
    _pendingData.removeWhere((element) => element.id == data.id);
    _allData.removeWhere((element) => element.id == data.id);
    setState(() {
      this._pendingData = [data, ...this._pendingData];
      this._allData = [data, ...this._allData];
    });
  }

  void searchUpdate() {
    setState(() {
      this.search = !search;
      searchText.text = "";
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    searchText.dispose();
  }

  void clearData() {
    searchText.text = "";
  }

  searchData() {
    List<Item> searchmodified = _allData
        .where((element) => element.title.startsWith(searchText.text))
        .toList();

    _updateData1(searchmodified);
  }

  void allFilter() {
    _updateData1(_allData);
    this.setState(() {
      filter = false;
    });
  }

  void todayFilter() {
    this.setState(() {
      filter = true;
    });
    DateTime date = DateTime.now();
    String formattedDate = DateFormat('yyyy/MM/dd').format(date);
    List<Item> searchmodified = _allData
        .where((element) =>
            DateFormat('yyyy/MM/dd')
                .format(DateTime.parse(element.timestamp)) ==
            formattedDate)
        .toList();

    _updateData1(searchmodified);
  }

  void monthFilter() {
    this.setState(() {
      filter = true;
    });
    DateTime now = DateTime.now();
    var month = new DateTime(now.year, now.month - 1, now.day);
    List<Item> searchmodified = _allData.where((element) {
      DateTime date = DateTime.parse(element.timestamp);
      return month.isBefore(date);
    }).toList();

    _updateData1(searchmodified);
  }

  void yearFilter() {
    this.setState(() {
      filter = true;
    });
    DateTime now = DateTime.now();
    var month = new DateTime(now.year - 1, now.month, now.day);
    List<Item> searchmodified = _allData.where((element) {
      DateTime date = DateTime.parse(element.timestamp);
      return month.isBefore(date);
    }).toList();

    _updateData1(searchmodified);
  }

  Future<void> chipFilter() async {
    this.setState(() {
      filter = true;
    });
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
    }
  }

  filterchips(String chip) {
    List<int> ids = [];
    for (var item in _chipdata) {
      if (item.chips == chip) {
        ids.add(item.todochip);
      }
    }
    final check = _allData.where((element) {
      return ids.indexOf(element.id) != -1;
    }).toList();

    List<Item> finaldata = [];
    if (ids.length > 0) {
      finaldata = check;
    }
    _updateData1(finaldata);
  }

  updateAllData(Item value) {
    print('data');
    chipsTodo().then(_updatechip);
    final List<Item> data =
        _allData.where((element) => element.id != value.id).toList();
    _updateData([value, ...data]);
  }

  updateDeleteAndData(Item value) {
    print('data');
    final List<Item> data =
        _allData.where((element) => element.id != value.id).toList();
    _updateData(data);
  }

  void handlePending() {
    setState(() {
      this._pendingDataLength = _pendingDataLength - 1;
      this._completedDataLength = _completedDataLength + 1;
    });
  }

  void handleCompleted() {
    setState(() {
      this._pendingDataLength = _pendingDataLength + 1;
      this._completedDataLength = _completedDataLength - 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Todo._title,
      debugShowCheckedModeBanner: false,
      routes: MyRoute,
      color: Colors.teal,
      theme: ThemeData(
          accentColor: Colors.teal,
          canvasColor: Colors.transparent,
          fontFamily: 'CrimsonTextRegular'),
      home: Scaffold(
        appBar: editData == null
            ? AppBar(
                backgroundColor: search
                    ? selectedIndex == 1 ? Colors.teal : Colors.white
                    : Colors.teal,
                leading: search && selectedIndex != 1
                    ? IconButton(
                        icon: Icon(
                          Icons.arrow_back,
                          color: Colors.grey,
                        ),
                        onPressed: searchUpdate)
                    : null,
                title: selectedIndex == 0
                    ? !search
                        ? Text('Pending')
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
                              contentPadding: EdgeInsets.only(
                                  left: 0, bottom: 11, top: 11, right: 0),
                              hintText: 'Search',
                            ),
                          )
                    : selectedIndex == 1
                        ? editData == null ? Text('Add') : Text('Edit')
                        : selectedIndex == 2
                            ? !search
                                ? Text('Completed')
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
                                      contentPadding: EdgeInsets.only(
                                          left: 0,
                                          bottom: 11,
                                          top: 11,
                                          right: 0),
                                      hintText: 'Search',
                                    ),
                                  )
                            : null,
                actions: !search
                    ? selectedIndex == 0 || selectedIndex == 2
                        ? [
                            IconButton(
                                icon: Icon(Icons.search),
                                onPressed: searchUpdate),
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
                            )
                            // IconButton(
                            //     icon: Icon(Icons.filter_list),
                            //     onPressed: () => print('filter')),
                          ]
                        : null
                    : selectedIndex != 1
                        ? [
                            IconButton(
                                icon: Icon(
                                  FontAwesomeIcons.timesCircle,
                                  color: Colors.grey,
                                ),
                                onPressed: () => clearData())
                          ]
                        : [])
            : AppBar(
                backgroundColor: Colors.teal,
                actions: selectedIndex == 1
                    ? [
                        IconButton(
                            icon: Icon(FontAwesomeIcons.timesCircle),
                            onPressed: editDataNullFunction)
                      ]
                    : [
                        IconButton(
                            icon: Icon(Icons.search), onPressed: searchUpdate),
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
                        )
                        // IconButton(
                        //     icon: Icon(Icons.filter_list),
                        //     onPressed: () => print('filter')),
                      ],
                title: selectedIndex == 0
                    ? Text('Pending')
                    : selectedIndex == 1
                        ? editData == null ? Text('Add') : Text('Edit')
                        : selectedIndex == 2 ? Text('Completed') : null,
              ),
        bottomNavigationBar: CurvedNavigationBar(
          height: 55,
          color: Colors.teal,
          backgroundColor: Colors.grey[200],
          items: <Widget>[
            Icon(
              FontAwesomeIcons.list,
              size: 25,
              color: Colors.white,
            ),
            editData == null
                ? Icon(
                    FontAwesomeIcons.plus,
                    size: 30,
                    color: Colors.white,
                  )
                : Icon(
                    Icons.edit,
                    size: 30,
                    color: Colors.white,
                  ),
            Icon(
              FontAwesomeIcons.checkCircle,
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
        ),
        backgroundColor: Colors.grey[200],
        body: initalLoading == false
            ? selectedIndex == 0
                ? WillPopScope(
                    onWillPop: onWillPop,
                    child: Pending(
                        data: _pendingData,
                        selectedIndex: onItemTapped,
                        moveIndex: onItemTapped1,
                        edit: editDataFunction,
                        updateAllData: updateAllData,
                        loading: initalLoading,
                        search: search,
                        filter: filter,
                        searchData: searchText.text,
                        //sliceValue: sliceValue,
                        handlePending: handlePending,
                        updateDeleteAndData: updateDeleteAndData,
                        pendingCount: _pendingDataLength),
                  )
                : selectedIndex == 1
                    ? editData == null
                        ? AddTodo(
                            moveIndex: onItemTapped1,
                            addData: updateAddData,
                          )
                        : EditTodo(
                            selectedIndex: onItemTapped,
                            edit: editData,
                            editDataNullFunction: editDataNullFunction,
                            updateEditData: updateEditData,
                            moveIndex: onItemTapped1,
                            moveToIndex: moveToIndex)
                    : selectedIndex == 2
                        ? Completed(
                            search: search,
                            filter: filter,
                            searchData: searchText.text,
                            data: _completedData,
                            selectedIndex: onItemTapped,
                            updateAllData: updateAllData,
                            moveIndex: onItemTapped1,
                            //handleCompleted: handleCompleted,
                            moveToIndex: moveToIndex,
                            edit: editDataFunction,
                            loading: initalLoading,
                            updateDeleteAndData: updateDeleteAndData,
                            completedCount: _completedDataLength)
                        : null
            : Container(
                height: MediaQuery.of(context).size.height,
                child: Center(
                  child: SpinKitFoldingCube(color: Colors.teal),
                ),
              ),
        drawer: MyDrawer(),
      ),
    );
  }
}
