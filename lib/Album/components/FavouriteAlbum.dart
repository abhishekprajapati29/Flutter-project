import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fproject/Album/components/model.dart';
import 'package:fproject/Auth/login/fabeanimation.dart';
import 'package:fproject/DashBoard/Drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'api_response.dart';
import 'images/images.dart';
import 'package:fproject/gettoken.dart';

class FavouriteAlbums extends StatefulWidget {
  List<AlbumModel> data;
  List<AlbumModel> searchData;
  bool loading;
  Function allFilter;
  Function todayFilter;
  Function monthFilter;
  Function yearFilter;
  Function updateAllData;
  bool search;
  bool filter;
  Function handleLargeView;
  TextEditingController searchText;
  Function searchUpdate;
  bool largeView;
  bool deleteLoading;
  Function deleteFunction;
  Function completeDeleteProcess;
  String token;
  Function moveIndex;
  FavouriteAlbums(
      {Key key,
      this.data,
      this.loading,
      this.searchUpdate,
      this.filter,
      this.search,
      this.allFilter,
      this.monthFilter,
      this.todayFilter,
      this.completeDeleteProcess,
      this.deleteFunction,
      this.deleteLoading,
      this.token,
      this.yearFilter,
      this.handleLargeView,
      this.searchText,
      this.largeView,
      this.moveIndex,
      this.searchData,
      this.updateAllData})
      : super(key: key);

  @override
  _FavouriteAlbumsState createState() => _FavouriteAlbumsState();
}

class _FavouriteAlbumsState extends State<FavouriteAlbums> {
  AlbumModel moreOption;
  int dropdownValue = 0;
  int startSliceValue = 0;
  int endSliceValue = 0;
  bool loading = false;
  int sliceValue = 0;
  bool showPagination = false;
  bool search = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      loading = true;
      widget.searchText.text = "";
    });
    if (widget.data.length >= 5 && widget.data.length != 0) {
      setState(() {
        this.dropdownValue = 5;
        this.endSliceValue = 5;
      });
    } else {
      setState(() {
        this.dropdownValue = widget.data.length;
        this.endSliceValue = widget.data.length;
      });
    }
    setState(() {
      loading = false;
    });
  }

  void _updateLoading() {
    setState(() {
      this.widget.loading = !widget.loading;
    });
  }

  _showModalBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 170,
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Center(
                child: GridView.count(
                  crossAxisCount: 3,
                  children: [
                    IconButton(
                        icon: Icon(
                          FontAwesomeIcons.heart,
                          color: moreOption.favourite == true
                              ? Colors.red
                              : Colors.white,
                          size: 80,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          _handleMarkedFavourite(moreOption);
                        }),
                    IconButton(
                        icon: Icon(
                          Icons.edit,
                          color: Colors.grey,
                          size: 80,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          _handleEdit(moreOption);
                        }),
                    IconButton(
                        icon: Icon(
                          Icons.delete,
                          color: Colors.black,
                          size: 80,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          _handleDelete(moreOption);
                        }),
                  ],
                ),
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
    });
    _showModalBottomSheet(context);
  }

  _handleDelete(moreOption) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text("Delete To Do"),
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
                  _updateLoading();
                  Navigator.pop(context);
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  String token = prefs.getString("token");
                  deleteAlbum(moreOption.id, token).then((_) {
                    //widget.updateDeleteAndData(moreOption);
                    _updateLoading();
                  });
                },
              ),
            ],
          );
        });
  }

  void _incrementData() {
    if (endSliceValue + dropdownValue <= widget.data.length) {
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
    int data = widget.data.length;
    while (data % dropdownValue != 0) {
      this.setState(() {
        data = data - 1;
      });
    }
    final int minusData = widget.data.length - data;
    setState(() {
      this.startSliceValue = endSliceValue - dropdownValue - minusData;
      this.endSliceValue = endSliceValue - minusData;
    });
  }

  void _incrementDateToItsEnd() {
    setState(() {
      this.startSliceValue = endSliceValue;
      this.endSliceValue = widget.data.length;
    });
  }

  _handleMarkedFavourite(item) {
    print('start0');
    print(item.id);
    print(moreOption.id);
    print('end');
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text("Mark as Favourite"),
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
                  _updateLoading();
                  Navigator.pop(context);
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  String token = prefs.getString("token");
                  markedFavourite(item.id, item.favourite, token).then((value) {
                    widget.updateAllData(value);
                    _updateLoading();
                    widget.moveIndex(2);
                  });
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return !loading
        ? Scaffold(
            body: widget.data.length > 0
                ? Stack(children: [
                    Container(
                      height: MediaQuery.of(context).size.height,
                      padding: EdgeInsets.only(bottom: 15.0),
                      child: Column(
                        children: [
                          Expanded(
                              child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height,
                            padding: EdgeInsets.all(10),
                            child: _buildPanel(),
                          )),
                          !widget.search && !widget.filter
                              ? showPagination
                                  ? FadeAnimation(
                                      0.5,
                                      Dismissible(
                                        key: Key('favalbum'),
                                        onDismissed: (direction) {
                                          // Remove the item from the data source.
                                          setState(() {
                                            showPagination = !showPagination;
                                          });
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 4.0, right: 4.0, top: 3.0),
                                          child: widget.data.length >= 5
                                              ? Container(
                                                  alignment:
                                                      Alignment.bottomCenter,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
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
                                                                          .data
                                                                          .length
                                                                  ? endSliceValue !=
                                                                          widget
                                                                              .data
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
                                                              widget.data
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
                                                        items: widget.data
                                                                        .length >
                                                                    0 &&
                                                                widget.data
                                                                        .length !=
                                                                    5 &&
                                                                widget.data
                                                                        .length !=
                                                                    10 &&
                                                                widget.data
                                                                        .length !=
                                                                    15
                                                            ? <int>[
                                                                5,
                                                                10,
                                                                15,
                                                                widget
                                                                    .data.length
                                                              ].map<DropdownMenuItem<int>>(
                                                                (int value) {
                                                                return DropdownMenuItem<
                                                                    int>(
                                                                  value: value,
                                                                  child: Text(value
                                                                      .toString()),
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
                                                                  child: Text(value
                                                                      .toString()),
                                                                );
                                                              }).toList(),
                                                      ),
                                                      Text(' ( '),
                                                      Text(startSliceValue
                                                          .toString()),
                                                      Text(' to '),
                                                      Text(endSliceValue
                                                          .toString()),
                                                      Text(' out of '),
                                                      Text(widget.data.length
                                                          .toString()),
                                                      Text(' ) '),
                                                      Spacer(),
                                                      IconButton(
                                                          icon: Icon(Icons
                                                              .navigate_next),
                                                          onPressed: endSliceValue !=
                                                                  widget.data
                                                                      .length
                                                              ? dropdownValue !=
                                                                      widget
                                                                          .data
                                                                          .length
                                                                  ? endSliceValue +
                                                                              dropdownValue <=
                                                                          widget
                                                                              .data
                                                                              .length
                                                                      ? () {
                                                                          _incrementData();
                                                                          print(
                                                                              'da');
                                                                        }
                                                                      : () {
                                                                          _incrementDateToItsEnd();
                                                                          print(
                                                                              'da');
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
                              : Container(),
                        ],
                      ),
                    ),
                    !widget.search && !widget.filter
                        ? !showPagination
                            ? widget.data.length >= 5
                                ? Positioned(
                                    child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            showPagination = !showPagination;
                                          });
                                        },
                                        child: Icon(
                                          FontAwesomeIcons.chevronCircleLeft,
                                          color: Colors.teal,
                                          size: 50,
                                        )),
                                    right: -20,
                                    top: MediaQuery.of(context).size.height *
                                        0.725,
                                  )
                                : Container()
                            : Container()
                        : Container()
                  ])
                : Center(
                    child: Text('No Albums'),
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
    return !widget.loading
        ? !widget.search && !widget.filter
            ? ListView.builder(
                itemCount: widget.data.length,
                itemBuilder: (context, index) {
                  return index + startSliceValue < endSliceValue
                      ? widget.largeView
                          ? SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20)),
                                padding: EdgeInsets.fromLTRB(10, 10, 10, 20),
                                height: 270,
                                width: double.maxFinite,
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  color: Colors.teal[900],
                                  elevation: 5,
                                  child: Column(
                                    children: [
                                      Expanded(
                                          child: Padding(
                                        padding: const EdgeInsets.all(0.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            color: Colors.teal[100],
                                          ),
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Expanded(
                                                    flex: 100,
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        Navigator.push(context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) {
                                                          return Images(
                                                            data: widget.data[
                                                                index +
                                                                    startSliceValue],
                                                            title: widget
                                                                .data[index +
                                                                    startSliceValue]
                                                                .title,
                                                            imagelist: widget
                                                                .data[index +
                                                                    startSliceValue]
                                                                .imagelist,
                                                            token: widget.token,
                                                            completeDeleteProcess:
                                                                widget
                                                                    .completeDeleteProcess,
                                                            deleteLoading: widget
                                                                .deleteLoading,
                                                            deleteFunction: widget
                                                                .deleteFunction,
                                                          );
                                                        }));
                                                      },
                                                      child: Container(
                                                        width: 150,
                                                        height: 184,
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                    20),
                                                            shape: BoxShape
                                                                .rectangle,
                                                            image: DecorationImage(
                                                                image: NetworkImage(widget
                                                                    .data[index +
                                                                        startSliceValue]
                                                                    .image),
                                                                fit: BoxFit
                                                                    .fill)),
                                                      ),
                                                    ),

                                                    // child: Text(
                                                    //   widget
                                                    //       .data[index +
                                                    //           startSliceValue]
                                                    //       .title,
                                                    //   style: TextStyle(
                                                    //       fontSize: 30,
                                                    //       fontStyle: FontStyle.italic,
                                                    //       fontWeight:
                                                    //           FontWeight.bold),
                                                    // ),
                                                  ),
                                                  // IconButton(
                                                  //     icon: Icon(Icons.more_vert),
                                                  //     onPressed: () {
                                                  //       _showModalBottomSheet1(
                                                  //           context,
                                                  //           widget.data[index +
                                                  //               startSliceValue]);
                                                  //     })
                                                ],
                                              ),
                                              // Padding(
                                              //   padding: const EdgeInsets.only(
                                              //       left: 8.0, right: 8.0),
                                              //   child: Divider(
                                              //     color: Colors.blue,
                                              //     height: 8.0,
                                              //     thickness: 5,
                                              //   ),
                                              // ),
                                              // Expanded(
                                              //     child: SingleChildScrollView(
                                              //         child: Padding(
                                              //   padding: EdgeInsets.fromLTRB(4, 4, 4, 0),
                                              //   child: Text(widget
                                              //       .data[index + startSliceValue]
                                              //       .noteContent),
                                              // )))
                                            ],
                                          ),
                                        ),
                                      )),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            5, 0, 5, 0),
                                        child: Row(
                                          children: [
                                            Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: widget.data[index].title
                                                            .length <
                                                        15
                                                    ? Text(
                                                        widget
                                                            .data[index].title,
                                                        style: TextStyle(
                                                            fontSize: 25,
                                                            color:
                                                                Colors.white),
                                                      )
                                                    : Text(
                                                        widget
                                                                .data[index +
                                                                    startSliceValue]
                                                                .title
                                                                .substring(
                                                                    0, 15) +
                                                            "...",
                                                        style: TextStyle(
                                                            fontSize: 25,
                                                            color:
                                                                Colors.white))),
                                            Spacer(),
                                            IconButton(
                                                icon: Icon(Icons.more_vert,
                                                    color: Colors.white),
                                                onPressed: () {
                                                  _showModalBottomSheet1(
                                                      context,
                                                      widget.data[index +
                                                          startSliceValue]);
                                                })
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            )
                          : Container(
                              height: 80,
                              width: double.maxFinite,
                              child: Card(
                                color: Colors.white,
                                elevation: 5,
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return Images(
                                        title: widget
                                            .data[index + startSliceValue].title
                                            .capitalize(),
                                        imagelist: widget
                                            .data[index + startSliceValue]
                                            .imagelist,
                                        token: widget.token,
                                        completeDeleteProcess:
                                            widget.completeDeleteProcess,
                                        deleteLoading: widget.deleteLoading,
                                        deleteFunction: widget.deleteFunction,
                                      );
                                    }));
                                  },
                                  child: ListTile(
                                    title: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Text(
                                          widget.data[index + startSliceValue]
                                              .title,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                    ),
                                    subtitle: Text(DateFormat('yyyy/MM/dd')
                                        .format(DateTime.parse(widget
                                            .data[index + startSliceValue]
                                            .timestamp))),
                                    trailing: IconButton(
                                        icon: Icon(Icons.more_vert),
                                        onPressed: () {
                                          _showModalBottomSheet1(
                                              context,
                                              widget.data[
                                                  index + startSliceValue]);
                                        }),
                                  ),
                                ),
                              ),
                            )
                      : null;
                })
            : ListView.builder(
                itemCount: widget.data.length,
                itemBuilder: (context, index) {
                  return widget.largeView
                      ? SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20)),
                            padding: EdgeInsets.fromLTRB(10, 10, 10, 20),
                            height: 270,
                            width: double.maxFinite,
                            child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              color: Colors.teal[900],
                              elevation: 5,
                              child: Column(
                                children: [
                                  Expanded(
                                      child: Padding(
                                    padding: const EdgeInsets.all(0.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Colors.teal[100],
                                      ),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                flex: 100,
                                                child: GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(context,
                                                        MaterialPageRoute(
                                                            builder: (context) {
                                                      return Images(
                                                        data:
                                                            widget.data[index],
                                                        title: widget
                                                            .data[index].title,
                                                        imagelist: widget
                                                            .data[index]
                                                            .imagelist,
                                                        token: widget.token,
                                                        completeDeleteProcess:
                                                            widget
                                                                .completeDeleteProcess,
                                                        deleteLoading: widget
                                                            .deleteLoading,
                                                        deleteFunction: widget
                                                            .deleteFunction,
                                                      );
                                                    }));
                                                  },
                                                  child: Container(
                                                    width: 150,
                                                    height: 184,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                        shape:
                                                            BoxShape.rectangle,
                                                        image: DecorationImage(
                                                            image: NetworkImage(
                                                                widget
                                                                    .data[index]
                                                                    .image),
                                                            fit: BoxFit.fill)),
                                                  ),
                                                ),
                                                // child: Text(
                                                //   widget
                                                //       .data[index +
                                                //           startSliceValue]
                                                //       .title,
                                                //   style: TextStyle(
                                                //       fontSize: 30,
                                                //       fontStyle: FontStyle.italic,
                                                //       fontWeight:
                                                //           FontWeight.bold),
                                                // ),
                                              ),
                                              // IconButton(
                                              //     icon: Icon(Icons.more_vert),
                                              //     onPressed: () {
                                              //       _showModalBottomSheet1(
                                              //           context,
                                              //           widget.data[index +
                                              //               startSliceValue]);
                                              //     })
                                            ],
                                          ),
                                          // Padding(
                                          //   padding: const EdgeInsets.only(
                                          //       left: 8.0, right: 8.0),
                                          //   child: Divider(
                                          //     color: Colors.blue,
                                          //     height: 8.0,
                                          //     thickness: 5,
                                          //   ),
                                          // ),
                                          // Expanded(
                                          //     child: SingleChildScrollView(
                                          //         child: Padding(
                                          //   padding: EdgeInsets.fromLTRB(4, 4, 4, 0),
                                          //   child: Text(widget
                                          //       .data[index + startSliceValue]
                                          //       .noteContent),
                                          // )))
                                        ],
                                      ),
                                    ),
                                  )),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(5, 0, 5, 0),
                                    child: Row(
                                      children: [
                                        Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: widget.data[index].title
                                                        .length <
                                                    15
                                                ? Text(
                                                    widget.data[index].title,
                                                    style: TextStyle(
                                                        fontSize: 25,
                                                        color: Colors.white),
                                                  )
                                                : Text(
                                                    widget.data[index].title
                                                            .substring(0, 15) +
                                                        "...",
                                                    style: TextStyle(
                                                        fontSize: 25,
                                                        color: Colors.white))),
                                        Spacer(),
                                        IconButton(
                                            icon: Icon(Icons.more_vert,
                                                color: Colors.white),
                                            onPressed: () {
                                              _showModalBottomSheet1(
                                                  context, widget.data[index]);
                                            })
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        )
                      : Container(
                          height: 80,
                          width: double.maxFinite,
                          child: Card(
                            color: Colors.white,
                            elevation: 5,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return Images(
                                    title:
                                        widget.data[index].title.capitalize(),
                                    imagelist: widget.data[index].imagelist,
                                    token: widget.token,
                                    completeDeleteProcess:
                                        widget.completeDeleteProcess,
                                    deleteLoading: widget.deleteLoading,
                                    deleteFunction: widget.deleteFunction,
                                  );
                                }));
                              },
                              child: ListTile(
                                title: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Text(widget.data[index].title,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ),
                                subtitle: Text(DateFormat('yyyy/MM/dd').format(
                                    DateTime.parse(
                                        widget.data[index].timestamp))),
                                trailing: IconButton(
                                    icon: Icon(Icons.more_vert),
                                    onPressed: () {
                                      _showModalBottomSheet1(
                                          context, widget.data[index]);
                                    }),
                              ),
                            ),
                          ),
                        );
                })
        : Container(
            height: MediaQuery.of(context).size.height,
            child: Center(
              child: SpinKitFoldingCube(color: Colors.teal),
            ),
          );
  }

  void _handleEdit(item) {
    // widget.edit(item);
    // widget.selectedIndex(1, 0);
  }
}
