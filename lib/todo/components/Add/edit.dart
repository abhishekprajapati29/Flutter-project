import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fproject/gettoken.dart';
import 'package:fproject/todo/components/Add/bloc.dart';
import 'package:fproject/todo/components/api_response.dart';

import '../models.dart';
import 'editchip.dart';

class EditTodo extends StatefulWidget {
  List<String> chips = [];
  Function editDataNullFunction;
  Function selectedIndex;
  Function updateEditData;
  Function moveIndex;
  int moveToIndex;
  Item edit;

  EditTodo(
      {Key key,
      this.selectedIndex,
      this.edit,
      this.updateEditData,
      this.moveIndex,
      this.moveToIndex,
      this.editDataNullFunction})
      : super(key: key);

  @override
  _EditTodoState createState() => _EditTodoState();
}

class _EditTodoState extends State<EditTodo> {
  String _token = "";
  bool _loading = false;
  bool _editloading = false;
  List<String> editChip = [];
  List<String> editId = [];

  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    updateLoading();
    getTokenPreferences().then(_upadateToken);
  }

  void updateLoading() {
    setState(() {
      this._loading = !_loading;
    });
  }

  void updateeditLoading() {
    setState(() {
      this._editloading = !_editloading;
    });
  }

  void _upadateToken(String value) {
    setState(() {
      this._token = value;
    });
    getSingleTodoData(value, widget.edit.id.toString()).then(_updateField);
  }

  void _updateField(Item data) {
    _titleController.text = data.title;
    _descriptionController.text = data.description;
    for (var item in data.todochip) {
      editChip.add(item.chips);
      editId.add(item.id.toString());
    }
    updateLoading();
  }

  submitEdit() {
    updateeditLoading();
    Map params = {
      'token': _token,
      'title': _titleController.text,
      'description': _descriptionController.text,
      'editChip': editChip,
      'id': widget.edit.id.toString()
    };
    editTodo(params, editId).then((data) {
      widget.updateEditData(data);
      widget.editDataNullFunction();
      updateeditLoading();
      widget.moveIndex(widget.moveToIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: _loading
          ? Container(
              height: MediaQuery.of(context).size.height,
              child: Center(
                child: SpinKitFoldingCube(color: Colors.teal),
              ),
            )
          : Container(
              height: MediaQuery.of(context).size.height,
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
                              FontAwesomeIcons.solidEdit,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        TextField(
                          controller: _titleController,
                          keyboardType: TextInputType.text,
                          cursorColor: Colors.black,
                          style: TextStyle(color: Colors.black),
                          decoration: new InputDecoration(
                            border: new OutlineInputBorder(
                                borderSide:
                                    new BorderSide(color: Colors.white)),
                            hintText: 'Todo Title',
                            labelText: 'Title',
                          ),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        TextField(
                          controller: _descriptionController,
                          keyboardType: TextInputType.text,
                          cursorColor: Colors.black,
                          style: TextStyle(color: Colors.black),
                          decoration: new InputDecoration(
                            border: new OutlineInputBorder(
                                borderSide:
                                    new BorderSide(color: Colors.black)),
                            hintText: 'Todo Description',
                            labelText: 'Description',
                          ),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        // TodoChips(
                        //   todochipsdata: widget.chips,
                        // ),
                        TodoEditChips(todoeditchips: editChip),

                        SizedBox(
                          height: 20.0,
                        ),
                        RaisedButton.icon(
                          icon: Icon(
                            Icons.edit,
                            color: Colors.white,
                          ),
                          color: Colors.teal,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          onPressed: !_editloading
                              ? _titleController.text.length > 0 &&
                                      _descriptionController.text.length > 0
                                  ? () => submitEdit()
                                  : null
                              : null,
                          label: !_editloading
                              ? widget.edit == null
                                  ? Text(
                                      "Create",
                                      style: TextStyle(color: Colors.white),
                                    )
                                  : Text(
                                      "Edit",
                                      style: TextStyle(color: Colors.white),
                                    )
                              : CircularProgressIndicator(
                                  backgroundColor: Colors.white,
                                  valueColor:
                                      AlwaysStoppedAnimation(Colors.teal),
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
