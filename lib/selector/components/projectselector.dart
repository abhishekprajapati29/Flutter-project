import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fproject/project/components/models.dart';

import '../../gettoken.dart';
import 'api_response.dart';

class ProjectSelector extends StatefulWidget {
  List<ProjectModel> projects;
  bool initLoading;
  Function handleproject;
  Function handleIncrementspace;
  Function handleDecrementspace;
  bool selected;
  ProjectSelector(
      {Key key,
      this.projects,
      this.initLoading,
      this.handleproject,
      this.selected,
      this.handleDecrementspace,
      this.handleIncrementspace})
      : super(key: key);

  @override
  _ProjectSelectorState createState() => _ProjectSelectorState();
}

class _ProjectSelectorState extends State<ProjectSelector> {
  int id = -1;

  @override
  Widget build(BuildContext context) {
    return !widget.initLoading
        ? widget.projects.length > 0
            ? ListView.builder(
                itemCount: widget.projects.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 6,
                    child: ListTile(
                        title: Text(widget.projects[index].projectName),
                        leading: Icon(
                          FontAwesomeIcons.projectDiagram,
                          color: Colors.grey,
                        ),
                        trailing: widget.selected
                            ? widget.projects[index].id != id
                                ? Checkbox(
                                    value: widget.projects[index].selected,
                                    onChanged: (bool value) {
                                      setState(() {
                                        id = widget.projects[index].id;
                                      });
                                      getTokenPreferences().then((token) {
                                        patchSelectedProject(token, value,
                                                widget.projects[index].id)
                                            .then((value1) {
                                          final videolist = widget.projects
                                              .where((element) =>
                                                  element.id != value1.id)
                                              .toList();
                                          widget.handleproject([
                                            ...videolist,
                                            value1
                                          ]..sort(
                                              (a, b) => a.id.compareTo(b.id)));
                                          if (value1.selected == true) {
                                            widget.handleIncrementspace(
                                                value1.projectSize);
                                          } else {
                                            widget.handleDecrementspace(
                                                value1.projectSize);
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
                child: Text('No Projects'),
              )
        : Center(child: SpinKitFoldingCube(color: Colors.teal));
  }
}
