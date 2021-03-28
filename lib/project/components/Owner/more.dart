import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fproject/Team/model.dart';
import 'package:fproject/project/components/MemberForum/MemberForum.dart';
import 'package:fproject/project/components/Owner/report.dart';
import 'package:fproject/project/components/Owner/uploadFile.dart';
import 'package:fproject/project/components/models.dart';
import 'package:intl/intl.dart';

import 'activity.dart';
import 'members.dart';

class More extends StatefulWidget {
  ProjectModel currentUserProjects;
  UserModel currentUserData;
  List<UserModel> allUser;
  Function handleProjectData;
  Function handleProjectData1;
  More(
      {Key key,
      this.currentUserData,
      this.currentUserProjects,
      this.allUser,
      this.handleProjectData,
      this.handleProjectData1})
      : super(key: key);

  @override
  _MoreState createState() => _MoreState();
}

class _MoreState extends State<More> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              widget.currentUserData.username ==
                      widget.currentUserProjects.username
                  ? ListTile(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return Reports(
                                data: widget.currentUserProjects.report
                                  ..sort((a, b) => b.id.compareTo(a.id)));
                          },
                        ));
                      },
                      leading: Icon(
                        FontAwesomeIcons.fileInvoice,
                      ),
                      title: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text('Report',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.arrow_right),
                        onPressed: null,
                      ),
                    )
                  : ListTile(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return ReportMember(
                                data: widget.currentUserProjects.report
                                    .where((element) =>
                                        element.postedBy ==
                                        widget.currentUserData.username)
                                    .toList(),
                                user: widget.currentUserData,
                                currentUserProjects: widget.currentUserProjects,
                                handleProjectData: widget.handleProjectData,
                                handleProjectData1: widget.handleProjectData1);
                          },
                        ));
                      },
                      leading: Icon(
                        FontAwesomeIcons.fileInvoice,
                      ),
                      title: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text('Write Today Report',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.arrow_right),
                        onPressed: null,
                      ),
                    ),
              Divider(
                thickness: 5,
              ),
              ListTile(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return UploadedFiles(
                          currentUserProjects: widget.currentUserProjects,
                          data: widget.currentUserProjects.file,
                          currentUserData: widget.currentUserData);
                    },
                  ));
                },
                leading: Icon(
                  Icons.cloud_upload,
                ),
                title: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Text("Uploaded File's",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                trailing: IconButton(
                  icon: Icon(Icons.arrow_right),
                  onPressed: null,
                ),
              ),
              Divider(
                thickness: 5,
              ),
              widget.currentUserData.username ==
                      widget.currentUserProjects.username
                  ? ListTile(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return Activitys(
                                data: widget.currentUserProjects.activity
                                  ..sort((a, b) => b.id.compareTo(a.id)));
                          },
                        ));
                      },
                      leading: Icon(FontAwesomeIcons.fileSignature),
                      title: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text('Activity',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.arrow_right),
                        onPressed: null,
                      ),
                    )
                  : Container(),
              widget.currentUserData.username ==
                      widget.currentUserProjects.username
                  ? Divider(
                      thickness: 5,
                    )
                  : Container(),
              ListTile(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return MemberForums(
                          data: widget.currentUserProjects.forums,
                          handleProjectData: widget.handleProjectData,
                          handleProjectData1: widget.handleProjectData1,
                          currentUserProjects: widget.currentUserProjects,
                          allUser: widget.allUser);
                    },
                  ));
                },
                leading: Icon(FontAwesomeIcons.comment),
                title: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Text('Project Member Forum',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                trailing: IconButton(
                  icon: Icon(Icons.arrow_right),
                  onPressed: null,
                ),
              ),
              Divider(
                thickness: 5,
              ),
              ListTile(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return Members(
                          data: widget.currentUserProjects.promem,
                          allUser: widget.allUser);
                    },
                  ));
                },
                leading: Icon(FontAwesomeIcons.users),
                title: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Text('Members',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                trailing: IconButton(
                  icon: Icon(Icons.arrow_right),
                  onPressed: null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
