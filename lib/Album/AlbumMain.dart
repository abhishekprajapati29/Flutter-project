import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fproject/Album/components/AddAlbum.dart';
import 'package:fproject/Album/components/Album.dart';
import 'package:fproject/Album/components/FavouriteAlbum.dart';
import 'package:fproject/DashBoard/Drawer.dart';
import 'package:intl/intl.dart';
import '../gettoken.dart';
import 'components/EditAlbum.dart';
import 'components/api_response.dart';
import 'components/model.dart';

class AlbumMain extends StatefulWidget {
  AlbumMain({Key key}) : super(key: key);

  @override
  _AlbumMainState createState() => _AlbumMainState();
}

class _AlbumMainState extends State<AlbumMain> {
  int selectedIndex = 0;
  bool deleteLoading = false;
  List<AlbumModel> favourite = [];
  bool largeView = true;
  int moveToIndex = 0;
  int sliceValue = 0;
  List<AlbumModel> _allData = [];
  bool initalLoading = false;
  List<AlbumModel> _searchData = [];
  AlbumModel editData;
  bool search = false;
  bool filter = false;

  void _handleLargeView() {
    setState(() {
      this.largeView = !largeView;
    });
  }

  void onItemTapped1(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  void editDataFunction(AlbumModel data) {
    setState(() {
      this.editData = data;
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

  _updateToken(String token) {
    setState(() {
      this._token = token;
    });
    getAlbumData(token).then(_updateData);
  }

  _updateData(List<AlbumModel> data) {
    final List<AlbumModel> favourites =
        data.where((element) => element.favourite == true).toList();
    setState(() {
      this.favourite = favourites..sort((a, b) => b.id.compareTo(a.id));
      this._allData = data..sort((a, b) => b.id.compareTo(a.id));
      this._searchData = data..sort((a, b) => b.id.compareTo(a.id));
      this.initalLoading = false;
    });
  }

  void _updateData1(List<AlbumModel> data) {
    List<AlbumModel> fav = _searchData
        .where((element) =>
            element.title.startsWith(searchText.text) &&
            element.favourite == true)
        .toList();
    List<AlbumModel> all = _searchData
        .where((element) => element.title.startsWith(searchText.text))
        .toList();
    setState(() {
      this.favourite = fav..sort((a, b) => b.id.compareTo(a.id));
      this._allData = all..sort((a, b) => b.id.compareTo(a.id));
    });
  }

  void _updateData2(List<AlbumModel> data) {
    List<AlbumModel> fav = data
        .where((element) =>
            element.title.startsWith(searchText.text) &&
            element.favourite == true)
        .toList();
    List<AlbumModel> all = data
        .where((element) => element.title.startsWith(searchText.text))
        .toList();
    setState(() {
      this.favourite = fav..sort((a, b) => b.id.compareTo(a.id));
      this._allData = all..sort((a, b) => b.id.compareTo(a.id));
    });
  }

  void searchUpdate() {
    setState(() {
      searchText.text = '';
    });
  }

  // void searchUpdate1() {
  //   setState(() {
  //     this.search = false;
  //   });
  // }

  @override
  void dispose() {
    super.dispose();
    searchText.dispose();
  }

  void clearData() {
    searchText.text = "";
  }

  searchData() {
    _updateData1(_searchData);
  }

  void allFilter() {
    this.setState(() {
      filter = false;
    });
    _updateData2(_searchData);
  }

  void todayFilter() {
    this.setState(() {
      filter = true;
    });
    DateTime date = DateTime.now();
    String formattedDate = DateFormat('yyyy/MM/dd').format(date);
    List<AlbumModel> searchmodified = _searchData
        .where((element) =>
            DateFormat('yyyy/MM/dd')
                .format(DateTime.parse(element.timestamp)) ==
            formattedDate)
        .toList();

    _updateData2(searchmodified);
  }

  void monthFilter() {
    this.setState(() {
      filter = true;
    });
    DateTime now = DateTime.now();
    var month = new DateTime(now.year, now.month - 1, now.day);
    List<AlbumModel> searchmodified = _searchData.where((element) {
      DateTime date = DateTime.parse(element.timestamp);
      return month.isBefore(date);
    }).toList();

    _updateData2(searchmodified);
  }

  void yearFilter() {
    this.setState(() {
      filter = true;
    });
    DateTime now = DateTime.now();
    var month = new DateTime(now.year - 1, now.month, now.day);
    List<AlbumModel> searchmodified = _searchData.where((element) {
      DateTime date = DateTime.parse(element.timestamp);
      return month.isBefore(date);
    }).toList();

    _updateData2(searchmodified);
  }

  addData(album) {
    setState(() {
      _allData = [album, ..._allData]..sort((a, b) => b.id.compareTo(a.id));
      _searchData = [album, ..._searchData]
        ..sort((a, b) => b.id.compareTo(a.id));
    });
  }

  void updateEditData(AlbumModel data) {
    print(data.id);
    for (var item in _allData) {
      print(item.id);
    }
    final List<AlbumModel> remainData =
        _searchData.where((element) => element.id != data.id).toList();
    final List<AlbumModel> reaminData1 = [data, ...remainData]
      ..sort((a, b) => b.id.compareTo(a.id));
    setState(() {
      _allData = reaminData1..sort((a, b) => b.id.compareTo(a.id));
      _searchData = reaminData1..sort((a, b) => b.id.compareTo(a.id));
    });
  }

  void updateDeleteAndData(data) {
    final afterDelete =
        _searchData.where((element) => element.id != data.id).toList();
    setState(() {
      this._allData = afterDelete..sort((a, b) => b.id.compareTo(a.id));
      this._searchData = afterDelete..sort((a, b) => b.id.compareTo(a.id));
    });
  }

  updateAllData(AlbumModel value) {
    final List<AlbumModel> data =
        _allData.where((element) => element.id != value.id).toList();
    _updateData([value, ...data])..sort((a, b) => b.id.compareTo(a.id));
  }

  addCreatedAlbumData(AlbumModel data) {
    this.setState(() {
      _allData = [data, ..._allData]..sort((a, b) => b.id.compareTo(a.id));
      _searchData = [data, ..._searchData]
        ..sort((a, b) => b.id.compareTo(a.id));
      selectedIndex = 0;
    });
  }

  editCreatedAlbumData(AlbumModel data) {
    List<AlbumModel> all =
        _searchData.where((element) => element.id != data.id).toList();
    this.setState(() {
      _allData = [data, ...all]..sort((a, b) => b.id.compareTo(a.id));
      _searchData = [data, ...all]..sort((a, b) => b.id.compareTo(a.id));
      selectedIndex = 0;
    });
  }

  cancelEdit() {
    this.setState(() {
      editData = null;
      selectedIndex = 0;
    });
  }

  completeDeleteProcess(int id) {
    List<AlbumModel> modified =
        _searchData.where((element) => element.id != id).toList();

    singleAlbum(_token, id).then((value) {
      print("id = ${value.imagelist.length}");

      print(modified.length);
      List<AlbumModel> reaminData1 = [value, ...modified]
        ..sort((a, b) => a.id.compareTo(b.id));
      print(reaminData1.length);
      this.setState(() {
        _allData = reaminData1..sort((a, b) => b.id.compareTo(a.id));
        _searchData = reaminData1..sort((a, b) => b.id.compareTo(a.id));
      });
    });
  }

  deleteFunction() {
    this.setState(() {
      deleteLoading = !deleteLoading;
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
        drawer: MyDrawer(),
        appBar: AppBar(
          backgroundColor: search ? Colors.white : Colors.teal,
          leading: search
              ? IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.grey,
                  ),
                  // onPressed: searchUpdate,
                  onPressed: () {
                    setState(() {
                      this.search = false;
                      searchText.text = '';
                    });
                  })
              : null,
          title: !search
              ? selectedIndex == 0
                  ? Text('Album')
                  : selectedIndex == 1
                      ? editData == null ? Text('Add') : Text('Edit')
                      : selectedIndex == 2 ? Text('Favourite') : null
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
              ? selectedIndex != 1
                  ? [
                      IconButton(
                          icon: Icon(Icons.search),
                          onPressed: () {
                            setState(() {
                              this.search = true;
                            });
                          }),
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
                        ],
                      ),
                      IconButton(
                          icon: largeView
                              ? Icon(FontAwesomeIcons.list)
                              : Icon(FontAwesomeIcons.thLarge),
                          onPressed: () => _handleLargeView())
                    ]
                  : editData != null
                      ? [
                          IconButton(
                              icon: Icon(
                                Icons.clear,
                                color: Colors.white,
                              ),
                              // onPressed: () => clearData())
                              onPressed: () => cancelEdit())
                        ]
                      : null
              : [
                  IconButton(
                      icon: Icon(
                        Icons.clear,
                        color: Colors.grey,
                      ),
                      // onPressed: () => clearData())
                      onPressed: () => searchUpdate())
                ],
        ),
        backgroundColor: Colors.grey[200],
        body: initalLoading == false
            ? selectedIndex == 0
                ? WillPopScope(
                    onWillPop: onWillPop,
                    child: Album(
                        data: _allData,
                        searchData: _searchData,
                        loading: initalLoading,
                        updateAllData: updateAllData,
                        largeView: largeView,
                        moveIndex: onItemTapped1,
                        handleLargeView: _handleLargeView,
                        searchText: searchText,
                        filter: filter,
                        search: search,
                        searchUpdate: searchUpdate,
                        updateEditData: updateEditData,
                        editDataFunction: editDataFunction,
                        allFilter: allFilter,
                        monthFilter: monthFilter,
                        todayFilter: todayFilter,
                        yearFilter: yearFilter,
                        token: _token,
                        completeDeleteProcess: completeDeleteProcess,
                        deleteLoading: deleteLoading,
                        deleteFunction: deleteFunction,
                        updateDeleteAndData: updateDeleteAndData),
                  )
                : selectedIndex == 1
                    ? editData == null
                        ? AddAlbum(
                            token: _token,
                            addCreatedAlbumData: addCreatedAlbumData)
                        : EditAlbum(
                            token: _token,
                            editCreatedAlbumData: editCreatedAlbumData,
                            editData: editData,
                            cancelEdit: cancelEdit,
                          )
                    : selectedIndex == 2
                        ? FavouriteAlbums(
                            data: favourite,
                            largeView: largeView,
                            filter: filter,
                            search: search,
                            searchData: _searchData,
                            searchText: searchText,
                            loading: initalLoading,
                            handleLargeView: _handleLargeView,
                            updateAllData: updateAllData,
                            moveIndex: onItemTapped1,
                            allFilter: allFilter,
                            monthFilter: monthFilter,
                            todayFilter: todayFilter,
                            yearFilter: yearFilter,
                            token: _token,
                            completeDeleteProcess: completeDeleteProcess,
                            deleteLoading: deleteLoading,
                            deleteFunction: deleteFunction,
                          )
                        : null
            : Container(
                height: MediaQuery.of(context).size.height,
                child: Center(
                  child: SpinKitFoldingCube(color: Colors.teal),
                ),
              ),
        bottomNavigationBar: CurvedNavigationBar(
          height: 55,
          backgroundColor: Colors.grey[200],
          color: Colors.teal,
          items: <Widget>[
            Icon(
              FontAwesomeIcons.list,
              size: 25,
              color: Colors.white,
            ),
            editData == null
                ? Icon(FontAwesomeIcons.plus, size: 30, color: Colors.white)
                : Icon(
                    Icons.edit,
                    size: 30,
                    color: Colors.white,
                  ),
            Icon(FontAwesomeIcons.heart, color: Colors.white, size: 25),
          ],
          animationCurve: Curves.easeInOut,
          animationDuration: Duration(milliseconds: 350),
          index: selectedIndex,
          onTap: (index) {
            onItemTapped1(index);
          },
        ),
      ),
    );
  }
}
