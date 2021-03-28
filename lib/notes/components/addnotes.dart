import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fproject/notes/components/api_resopnse.dart';
import 'package:fproject/notes/components/chips.dart';

class AddNote extends StatefulWidget {
  String token;
  Function addData;
  AddNote({Key key, this.token, this.addData}) : super(key: key);

  @override
  _AddNoteState createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  TextEditingController noteTitle = new TextEditingController();
  TextEditingController noteContent = new TextEditingController();

  List<String> chips = [];
  bool loading = false;

  loadingChange() {
    setState(() {
      this.loading = !loading;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.teal,
          title: Text('Add'),
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
                            FontAwesomeIcons.stickyNote,
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
                      NoteChips(
                        noteChipsdata: chips,
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      RaisedButton.icon(
                        icon: Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                        color: Colors.teal,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        onPressed: !loading
                            ? () => addNote(
                                context,
                                chips,
                                widget.token,
                                noteContent.text,
                                noteTitle.text,
                                widget.addData,
                                loadingChange)
                            : null,
                        label: !loading
                            ? Text(
                                'Create',
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
