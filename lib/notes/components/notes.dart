import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fproject/notes/components/models.dart';
import 'package:fproject/notes/components/viewnotes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fproject/gettoken.dart';
import 'api_resopnse.dart';
import 'editnotes.dart';

// ignore: must_be_immutable
class Notes extends StatefulWidget {
  Function updateDeleteAndData;
  bool largeView;
  int startSliceValue;
  bool search;
  int endSliceValue;
  int dropdownValue;
  List<NotesItem> data = [];
  List<NotesItem> searchData = [];
  bool loading;
  Function updateEditData;
  Notes(
      {Key key,
      this.data,
      this.search,
      this.searchData,
      this.startSliceValue,
      this.endSliceValue,
      this.dropdownValue,
      this.updateEditData,
      this.loading,
      this.largeView,
      this.updateDeleteAndData})
      : super(key: key);
  @override
  _NotesState createState() => _NotesState();
}

class _NotesState extends State<Notes> {
  NotesItem moreOption;
  bool loading = false;
  int sliceValue = 0;

  @override
  void initState() {
    super.initState();
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
                          FontAwesomeIcons.eye,
                          color: Colors.white,
                          size: 80,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return ViewNote(
                              editData: moreOption,
                            );
                          }));
                        }),
                    IconButton(
                        icon: Icon(
                          Icons.edit,
                          color: Colors.white,
                          size: 80,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return EditNote(
                              editData: moreOption,
                              allData: widget.data,
                              searchData: widget.searchData,
                              updateEditData: widget.updateEditData,
                            );
                          }));
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
                  deleteNote(moreOption.id, token).then((_) {
                    widget.updateDeleteAndData(moreOption);
                    _updateLoading();
                  });
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.data.length > 0
          ? Container(
              color: Colors.grey[200],
              child: Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
                      child: _buildPanel(),
                    ),
                  ),
                ],
              ),
            )
          : Center(
              child: Text('No Notes'),
            ),
    );
  }

  Widget _buildPanel() {
    return !widget.search
        ? ListView.builder(
            itemCount: widget.data.length,
            itemBuilder: (context, index) {
              return index + widget.startSliceValue < widget.endSliceValue
                  ? widget.largeView
                      ? Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.grey[200]),
                          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                          height: widget.data[index + widget.startSliceValue]
                                      .notechip.length >
                                  0
                              ? 270
                              : 220,
                          width: double.maxFinite,
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            color: Colors.teal,
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
                                    height: double.infinity,
                                    width: double.infinity,
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              8, 4, 8, 4),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                flex: 100,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    color: Colors.teal[100],
                                                  ),
                                                  child: SingleChildScrollView(
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    child: Text(
                                                      widget
                                                          .data[index +
                                                              widget
                                                                  .startSliceValue]
                                                          .noteTitle
                                                          .capitalize(),
                                                      style: TextStyle(
                                                          fontSize: 30,
                                                          fontStyle:
                                                              FontStyle.italic,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              IconButton(
                                                  icon: Icon(Icons.more_vert),
                                                  onPressed: () {
                                                    _showModalBottomSheet1(
                                                        context,
                                                        widget.data[index +
                                                            widget
                                                                .startSliceValue]);
                                                  })
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 8.0, right: 8.0),
                                          child: Divider(
                                            color: Colors.teal,
                                            height: 8.0,
                                            thickness: 5,
                                          ),
                                        ),
                                        Expanded(
                                            child: SingleChildScrollView(
                                                child: Padding(
                                          padding: widget
                                                      .data[index +
                                                          widget
                                                              .startSliceValue]
                                                      .notechip
                                                      .length >
                                                  0
                                              ? EdgeInsets.fromLTRB(4, 4, 4, 0)
                                              : EdgeInsets.all(4.0),
                                          child: Text(widget
                                              .data[index +
                                                  widget.startSliceValue]
                                              .noteContent),
                                        )))
                                      ],
                                    ),
                                  ),
                                )),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10.0, right: 10.0),
                                  child: SingleChildScrollView(
                                      padding: EdgeInsets.only(
                                          left: 10.0, right: 10.0),
                                      scrollDirection: Axis.horizontal,
                                      child: Row(
                                          children: widget
                                              .data[index +
                                                  widget.startSliceValue]
                                              .notechip
                                              .map((Notechip chip) {
                                        return Padding(
                                          padding:
                                              const EdgeInsets.only(right: 3.0),
                                          child: Chip(
                                            avatar: CircleAvatar(
                                              backgroundColor: Colors.white,
                                              child: Icon(
                                                Icons.check_circle,
                                                color: Colors.teal,
                                              ),
                                            ),
                                            backgroundColor: Colors.grey[200],
                                            label: Text(chip.noteChips),
                                          ),
                                        );
                                      }).toList())),
                                )
                              ],
                            ),
                          ),
                        )
                      : Container(
                          height: 80,
                          width: double.maxFinite,
                          child: Card(
                            color: Colors.white,
                            elevation: 5,
                            child: ListTile(
                              title: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Text(
                                    widget.data[index + widget.startSliceValue]
                                        .noteTitle
                                        .capitalize(),
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                              ),
                              subtitle: widget
                                          .data[index + widget.startSliceValue]
                                          .noteContent
                                          .length <=
                                      20
                                  ? Text(widget
                                      .data[index + widget.startSliceValue]
                                      .noteContent)
                                  : Text(widget
                                          .data[index + widget.startSliceValue]
                                          .noteContent
                                          .substring(0, 20) +
                                      "...."),
                              trailing: IconButton(
                                  icon: Icon(Icons.more_vert),
                                  onPressed: () {
                                    _showModalBottomSheet1(
                                        context,
                                        widget.data[
                                            index + widget.startSliceValue]);
                                  }),
                            ),
                          ),
                        )
                  : null;
            })
        : ListView.builder(
            itemCount: widget.data.length,
            itemBuilder: (context, index) {
              return widget.largeView
                  ? Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.grey[200]),
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                      height:
                          widget.data[index].notechip.length > 0 ? 270 : 220,
                      width: double.maxFinite,
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        color: Colors.teal,
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
                                height: double.infinity,
                                width: double.infinity,
                                child: Column(
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(8, 4, 8, 4),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            flex: 100,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                color: Colors.teal[100],
                                              ),
                                              child: SingleChildScrollView(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                child: Text(
                                                  widget.data[index].noteTitle
                                                      .capitalize(),
                                                  style: TextStyle(
                                                      fontSize: 30,
                                                      fontStyle:
                                                          FontStyle.italic,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ),
                                          ),
                                          IconButton(
                                              icon: Icon(Icons.more_vert),
                                              onPressed: () {
                                                _showModalBottomSheet1(context,
                                                    widget.data[index]);
                                              })
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8.0, right: 8.0),
                                      child: Divider(
                                        color: Colors.teal,
                                        height: 8.0,
                                        thickness: 5,
                                      ),
                                    ),
                                    Expanded(
                                        child: SingleChildScrollView(
                                            child: Padding(
                                      padding:
                                          widget.data[index].notechip.length > 0
                                              ? EdgeInsets.fromLTRB(4, 4, 4, 0)
                                              : EdgeInsets.all(4.0),
                                      child:
                                          Text(widget.data[index].noteContent),
                                    )))
                                  ],
                                ),
                              ),
                            )),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 10.0, right: 10.0),
                              child: SingleChildScrollView(
                                  padding:
                                      EdgeInsets.only(left: 10.0, right: 10.0),
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                      children: widget.data[index].notechip
                                          .map((Notechip chip) {
                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(right: 3.0),
                                      child: Chip(
                                        avatar: CircleAvatar(
                                          backgroundColor: Colors.white,
                                          child: Icon(
                                            Icons.check_circle,
                                            color: Colors.teal,
                                          ),
                                        ),
                                        backgroundColor: Colors.grey[200],
                                        label: Text(chip.noteChips),
                                      ),
                                    );
                                  }).toList())),
                            )
                          ],
                        ),
                      ),
                    )
                  : Container(
                      height: 80,
                      width: double.maxFinite,
                      child: Card(
                        color: Colors.white,
                        elevation: 5,
                        child: ListTile(
                          title: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Text(
                                widget.data[index].noteTitle.capitalize(),
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          subtitle: widget.data[index].noteContent.length <= 20
                              ? Text(widget.data[index].noteContent)
                              : Text(widget.data[index].noteContent
                                      .substring(0, 20) +
                                  "...."),
                          trailing: IconButton(
                              icon: Icon(Icons.more_vert),
                              onPressed: () {
                                _showModalBottomSheet1(
                                    context, widget.data[index]);
                              }),
                        ),
                      ),
                    );
            });
  }
}
