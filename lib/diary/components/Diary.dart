import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fproject/diary/components/viewdiary.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'api_response.dart';
import 'editDiary.dart';
import 'model.dart';

class Diary extends StatefulWidget {
  List<DiaryModel> data;
  List<DiaryModel> searchData;
  bool loading;
  int startSliceValue;
  int endSliceValue;
  int dropdownValue;
  Function updateEditData;
  Function updateDeleteAndData;
  Diary(
      {Key key,
      this.data,
      this.dropdownValue,
      this.endSliceValue,
      this.loading,
      this.searchData,
      this.startSliceValue,
      this.updateDeleteAndData,
      this.updateEditData})
      : super(key: key);

  @override
  _DiaryState createState() => _DiaryState();
}

class _DiaryState extends State<Diary> {
  DiaryModel moreOption;
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
                            return ViewDiary(
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
                            return EditDiary(
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
                  deleteDiary(moreOption.id, token).then((_) {
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
                    child: _buildPanel(),
                  ),
                ],
              ),
            )
          : Center(
              child: Text('No Diarys'),
            ),
    );
  }

  Widget _buildPanel() {
    return ListView.builder(
        itemCount: widget.data.length,
        itemBuilder: (context, index) {
          return index + widget.startSliceValue < widget.endSliceValue
              ? GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return ViewDiary(
                        editData: widget.data[index + widget.startSliceValue],
                      );
                    }));
                  },
                  child: Container(
                    height: 80,
                    width: double.maxFinite,
                    child: Card(
                      color: Colors.white,
                      elevation: 5,
                      child: ListTile(
                        title: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Text(
                              widget.data[index + widget.startSliceValue].title,
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        subtitle: Text(DateFormat('yyyy/MM/dd').format(
                            DateTime.parse(widget
                                .data[index + widget.startSliceValue]
                                .postedDate))),
                        trailing: IconButton(
                            icon: Icon(Icons.more_vert),
                            onPressed: () {
                              _showModalBottomSheet1(context,
                                  widget.data[index + widget.startSliceValue]);
                            }),
                      ),
                    ),
                  ),
                )
              : null;
        });
  }
}
