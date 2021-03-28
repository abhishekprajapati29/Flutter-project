import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fproject/notes/components/editchips.dart';
import 'package:fproject/notes/components/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'api_resopnse.dart';

class EditNote extends StatefulWidget {
  NotesItem editData;
  Function updateEditData;
  List<NotesItem> allData = [];
  List<NotesItem> searchData = [];
  EditNote(
      {Key key,
      this.editData,
      this.updateEditData,
      this.allData,
      this.searchData})
      : super(key: key);

  @override
  _EditNoteState createState() => _EditNoteState();
}

class _EditNoteState extends State<EditNote> {
  TextEditingController noteTitle = new TextEditingController();
  TextEditingController noteContent = new TextEditingController();
  List<String> editChip = [];
  List<String> editId = [];
  bool loading = false;

  loadingFunction() {
    setState(() {
      this.loading = !loading;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _updateField(widget.editData);
  }

  void _updateField(NotesItem data) {
    noteTitle.text = data.noteTitle;
    noteContent.text = data.noteContent;
    for (var item in data.notechip) {
      editChip.add(item.noteChips);
      editId.add(item.id.toString());
    }
  }

  void _updateEditData(NotesItem data) {
    widget.updateEditData(data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
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
                        controller: noteTitle,
                        keyboardType: TextInputType.text,
                        cursorColor: Colors.black,
                        style: TextStyle(color: Colors.black),
                        decoration: new InputDecoration(
                          border: new OutlineInputBorder(
                              borderSide: new BorderSide(color: Colors.black)),
                          hintText: 'Note Title',
                          labelText: 'Title',
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      TextField(
                        controller: noteContent,
                        keyboardType: TextInputType.text,
                        cursorColor: Colors.black,
                        style: TextStyle(color: Colors.black),
                        decoration: new InputDecoration(
                          border: new OutlineInputBorder(
                              borderSide: new BorderSide(color: Colors.black)),
                          hintText: 'Note Description',
                          labelText: 'Description',
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      NoteEditChips(
                        editChip: editChip,
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      RaisedButton.icon(
                        icon: Icon(Icons.edit, color: Colors.white),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        color: Colors.teal,
                        onPressed: !loading
                            ? () async {
                                Navigator.pop(context);
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                String token = prefs.getString("token");
                                editNote(
                                  noteTitle.text,
                                  noteContent.text,
                                  loadingFunction,
                                  {
                                    'chips': editChip,
                                    "id": widget.editData.id,
                                    "token": token,
                                    "editId": editId
                                  },
                                ).then(_updateEditData);
                              }
                            : null,
                        label: !loading
                            ? Text('Edit',
                                style: TextStyle(color: Colors.white))
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
