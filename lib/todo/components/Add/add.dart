import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fproject/gettoken.dart';
import 'package:fproject/todo/components/Add/bloc.dart';
import 'package:fproject/todo/components/Add/chips.dart';

class AddTodo extends StatefulWidget {
  List<String> chips = [];
  Function moveIndex;
  Function addData;

  AddTodo({Key key, this.moveIndex, this.addData}) : super(key: key);

  @override
  _AddTodoState createState() => _AddTodoState();
}

class _AddTodoState extends State<AddTodo> {
  final bloc = BlocAdd();
  String _token = "";
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    getTokenPreferences().then(_upadateToken);
  }

  void updateLoading() {
    setState(() {
      this._loading = !_loading;
    });
  }

  void _upadateToken(String value) {
    setState(() {
      this._token = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
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
                        FontAwesomeIcons.tasks,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  StreamBuilder<String>(
                    stream: bloc.title,
                    builder: (context, snapshot) => TextField(
                      onChanged: bloc.titleChanged,
                      keyboardType: TextInputType.text,
                      cursorColor: Colors.black,
                      style: TextStyle(color: Colors.black),
                      decoration: new InputDecoration(
                          border: new OutlineInputBorder(
                              borderSide: new BorderSide(color: Colors.black)),
                          hintText: 'Todo Title',
                          labelText: 'Title',
                          errorText: snapshot.error),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  StreamBuilder<String>(
                    stream: bloc.description,
                    builder: (context, snapshot) => TextField(
                      onChanged: bloc.descriptionChanged,
                      keyboardType: TextInputType.text,
                      cursorColor: Colors.black,
                      style: TextStyle(color: Colors.black),
                      decoration: new InputDecoration(
                          border: new OutlineInputBorder(
                              borderSide: new BorderSide(color: Colors.black)),
                          hintText: 'Todo Description',
                          labelText: 'Description',
                          errorText: snapshot.error),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  TodoChips(
                    todochipsdata: widget.chips,
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  StreamBuilder<bool>(
                    stream: bloc.submitCheck,
                    builder: (context, snapshot) => RaisedButton.icon(
                      icon: Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      color: Colors.teal,
                      onPressed: snapshot.hasData && !_loading
                          ? () => bloc.submit(context, widget.chips, _token,
                              widget.moveIndex, updateLoading, widget.addData)
                          : null,
                      label: !_loading
                          ? Text(
                              "Create",
                              style: TextStyle(color: Colors.white),
                            )
                          : CircularProgressIndicator(
                              backgroundColor: Colors.white,
                              valueColor: AlwaysStoppedAnimation(Colors.teal),
                            ),
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
