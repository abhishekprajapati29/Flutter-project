import 'package:fproject/Team/model.dart';
import 'package:fproject/project/components/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class Overview extends StatefulWidget {
  ProjectModel currentUserProjects;
  UserModel currentUserData;
  Overview({Key key, this.currentUserData, this.currentUserProjects})
      : super(key: key);

  @override
  _OverviewState createState() => _OverviewState();
}

class _OverviewState extends State<Overview> {
  @override
  Widget build(BuildContext context) {
    print(widget.currentUserProjects.projectDescription);
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: Colors.grey[200],
      child: SingleChildScrollView(
        child: Html(data: widget.currentUserProjects.projectDescription),
      ),
    );
  }
}
