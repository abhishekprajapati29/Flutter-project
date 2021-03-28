import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fproject/DashBoard/Drawer.dart';
import 'package:fproject/Video/components/video.dart';
import 'package:fproject/Video/components/model.dart';
import 'package:fproject/gettoken.dart';
import 'package:intl/intl.dart';
import 'addVideo.dart';
import 'api_response.dart';
import 'favouriteVideo.dart';

class VideoMain extends StatefulWidget {
  VideoMain({Key key}) : super(key: key);

  @override
  _VideoMainState createState() => _VideoMainState();
}

class _VideoMainState extends State<VideoMain> {
  int selectedIndex = 0;
  bool deleteLoading = false;
  List<VideoModel> favourite = [];
  int moveToIndex = 0;
  int sliceValue = 0;
  List<VideoModel> _allData = [];
  bool initalLoading = false;
  List<VideoModel> _searchData = [];
  VideoModel editData;
  bool search = false;
  bool filter = false;

  void onItemTapped1(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  void editDataFunction(VideoModel data) {
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
    getVideoData(token).then(_updateData);
  }

  _updateData(List<VideoModel> data) {
    final List<VideoModel> favourites =
        data.where((element) => element.favourite == true).toList();
    print(favourites.length);
    print(data.length);
    setState(() {
      this.favourite = favourites..sort((a, b) => b.id.compareTo(a.id));
      this._allData = data..sort((a, b) => b.id.compareTo(a.id));
      this._searchData = data..sort((a, b) => b.id.compareTo(a.id));
      this.initalLoading = false;
    });
  }

  void _updateData1(List<VideoModel> data) {
    List<VideoModel> fav = _searchData
        .where((element) =>
            element.title.startsWith(searchText.text) &&
            element.favourite == true)
        .toList();
    List<VideoModel> all = _searchData
        .where((element) => element.title.startsWith(searchText.text))
        .toList();
    setState(() {
      this.favourite = fav..sort((a, b) => b.id.compareTo(a.id));
      this._allData = all..sort((a, b) => b.id.compareTo(a.id));
    });
  }

  void _updateData2(List<VideoModel> data) {
    List<VideoModel> fav = data
        .where((element) =>
            element.title.startsWith(searchText.text) &&
            element.favourite == true)
        .toList();
    List<VideoModel> all = data
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
    List<VideoModel> searchmodified = _searchData
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
    List<VideoModel> searchmodified = _searchData.where((element) {
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
    List<VideoModel> searchmodified = _searchData.where((element) {
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

  void updateEditData(VideoModel data) {
    print(data.id);
    for (var item in _allData) {
      print(item.id);
    }
    final List<VideoModel> remainData =
        _searchData.where((element) => element.id != data.id).toList();
    final List<VideoModel> reaminData1 = [data, ...remainData]
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

  updateAllData(VideoModel value) {
    final List<VideoModel> data = _allData
        .where((element) => element.id != value.id)
        .toList()
          ..sort((a, b) => a.id.compareTo(b.id));
    _updateData([value, ...data]);
  }

  addCreatedVideoData(VideoModel data) {
    this.setState(() {
      _allData = [data, ..._allData]..sort((a, b) => b.id.compareTo(a.id));
      _searchData = [data, ..._searchData]
        ..sort((a, b) => b.id.compareTo(a.id));
      selectedIndex = 0;
    });
  }

  editCreatedAlbumData(VideoModel data) {
    List<VideoModel> all =
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
    List<VideoModel> modified =
        _searchData.where((element) => element.id != id).toList();

    // singleVideo(_token, id).then((value) {
    //   print("id = ${value.imagelist.length}");

    //   print(modified.length);
    //   List<VideoModel> reaminData1 = [value, ...modified]
    //     ..sort((a, b) => a.id.compareTo(b.id));
    //   print(reaminData1.length);
    //   this.setState(() {
    //     _allData = reaminData1;
    //     _searchData = reaminData1;
    //   });
    // });
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
                  ? Text('Videos')
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
                    child: Videos(
                      data: _allData,
                      search: search,
                      filter: filter,
                      searchData: _searchData,
                      loading: initalLoading,
                      moveIndex: onItemTapped1,
                      updateAllData: updateAllData,
                      updateDeleteAndData: updateDeleteAndData,
                    ),
                  )
                : selectedIndex == 1
                    ? AddVideo(
                        token: _token, addCreatedVideoData: addCreatedVideoData)
                    : selectedIndex == 2
                        ? FavouriteVideo(
                            data: favourite,
                            filter: filter,
                            search: search,
                            searchData: _searchData,
                            loading: initalLoading,
                            moveIndex: onItemTapped1,
                            updateAllData: updateAllData,
                            updateDeleteAndData: updateDeleteAndData)
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
