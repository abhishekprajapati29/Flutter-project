import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fproject/File/components/model.dart';
import 'package:fproject/selector/components/api_response.dart';

import '../../gettoken.dart';

class FileSelector extends StatefulWidget {
  List<FileModel> files;
  bool initLoading;
  Function handlefile;
  Function handleIncrementspace;
  Function handleDecrementspace;
  bool selected;
  FileSelector(
      {Key key,
      this.files,
      this.initLoading,
      this.selected,
      this.handlefile,
      this.handleDecrementspace,
      this.handleIncrementspace})
      : super(key: key);

  @override
  _FileSelectorState createState() => _FileSelectorState();
}

class _FileSelectorState extends State<FileSelector> {
  int id = -1;

  @override
  Widget build(BuildContext context) {
    return !widget.initLoading
        ? widget.files.length > 0
            ? ListView.builder(
                itemCount: widget.files.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 6,
                    child: ListTile(
                        title: Text(widget.files[index].title),
                        leading: Icon(
                          FontAwesomeIcons.fileAlt,
                          color: Colors.grey,
                        ),
                        trailing: widget.selected
                            ? widget.files[index].id != id
                                ? Checkbox(
                                    value: widget.files[index].selected,
                                    onChanged: (bool value) {
                                      setState(() {
                                        id = widget.files[index].id;
                                      });
                                      getTokenPreferences().then((token) {
                                        patchSelectedFile(token, value,
                                                widget.files[index].id)
                                            .then((value1) {
                                          final filelist = widget.files
                                              .where((element) =>
                                                  element.id != value1.id)
                                              .toList();
                                          widget.handlefile([
                                            ...filelist,
                                            value1
                                          ]..sort(
                                              (a, b) => a.id.compareTo(b.id)));
                                          if (value1.selected == true) {
                                            widget.handleIncrementspace(
                                                value1.size);
                                          } else {
                                            widget.handleDecrementspace(
                                                value1.size);
                                          }
                                          setState(() {
                                            id = -1;
                                          });
                                        });
                                      });
                                    })
                                : CircularProgressIndicator(
                                    backgroundColor: Colors.teal,
                                    valueColor:
                                        AlwaysStoppedAnimation(Colors.white),
                                  )
                            : null),
                  );
                })
            : Center(
                child: Text('No Files'),
              )
        : Center(child: SpinKitFoldingCube(color: Colors.teal));
  }
}
