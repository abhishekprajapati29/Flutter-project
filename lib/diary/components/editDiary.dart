import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fproject/diary/components/model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'api_response.dart';

class EditDiary extends StatefulWidget {
  DiaryModel editData;
  List<DiaryModel> allData;
  List<DiaryModel> searchData;
  Function updateEditData;
  EditDiary(
      {Key key,
      this.allData,
      this.editData,
      this.searchData,
      this.updateEditData})
      : super(key: key);

  @override
  _EditDiaryState createState() => _EditDiaryState();
}

class _EditDiaryState extends State<EditDiary> {
  TextEditingController title = new TextEditingController();
  TextEditingController text = new TextEditingController();
  bool loading = false;

  loadingFunction() {
    setState(() {
      this.loading = !loading;
    });
  }

  @override
  void initState() {
    super.initState();
    _updateField(widget.editData);
  }

  void _updateField(DiaryModel data) {
    title.text = data.title;
    text.text = data.text;
  }

  void _updateEditData(DiaryModel data) {
    widget.updateEditData(data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.teal,
          title: Text('Edit'),
        ),
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            color: Colors.grey[200],
            //color: Colors.white,
            child: new Theme(
              data: new ThemeData(
                primaryColor: Colors.black,
                primaryColorDark: Colors.black,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20.0,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          height: 40.0,
                          width: 40.0,
                          decoration: BoxDecoration(
                            color: Colors.teal,
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(10),
                                bottom: Radius.circular(10)),
                          ),
                          child: Icon(
                            Icons.edit,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      TextField(
                        controller: title,
                        keyboardType: TextInputType.text,
                        cursorColor: Colors.black,
                        style: TextStyle(color: Colors.black),
                        decoration: new InputDecoration(
                          border: new OutlineInputBorder(
                              borderSide: new BorderSide(color: Colors.black)),
                          hintText: 'Diary Title',
                          labelText: 'Title',
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      TextField(
                        controller: text,
                        keyboardType: TextInputType.text,
                        cursorColor: Colors.black,
                        style: TextStyle(color: Colors.black),
                        decoration: new InputDecoration(
                          border: new OutlineInputBorder(
                              borderSide: new BorderSide(color: Colors.black)),
                          hintText: 'Diary Description',
                          labelText: 'Description',
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      RaisedButton.icon(
                        icon: Icon(
                          Icons.edit,
                          color: Colors.white,
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        color: Colors.teal,
                        onPressed: !loading
                            ? () async {
                                Navigator.pop(context);
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                String token = prefs.getString("token");
                                editDiary(
                                  title.text,
                                  text.text,
                                  loadingFunction,
                                  {
                                    "id": widget.editData.id,
                                    "token": token,
                                  },
                                ).then(_updateEditData);
                              }
                            : null,
                        label: !loading
                            ? Text(
                                'Edit',
                                style: TextStyle(color: Colors.white),
                              )
                            : CircularProgressIndicator(
                                backgroundColor: Colors.white,
                                valueColor:
                                    AlwaysStoppedAnimation(Colors.teal)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
