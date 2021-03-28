import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fproject/DashBoard/models.dart';
import 'package:fproject/project/components/models.dart';
import 'package:fproject/setting/components/plans.dart';
import '../../gettoken.dart';
import 'api_response.dart';

class TeamProjectOverview extends StatefulWidget {
  ProjectModel projectOverview;
  Function handleInvites;
  Function handleInvites1;
  List<ProjectInvoice> invites;
  TeamProjectOverview(
      {Key key,
      this.projectOverview,
      this.handleInvites,
      this.invites,
      this.handleInvites1})
      : super(key: key);

  @override
  _TeamProjectOverviewState createState() => _TeamProjectOverviewState();
}

class _TeamProjectOverviewState extends State<TeamProjectOverview> {
  TextEditingController message = new TextEditingController();
  bool requestLoading = false;
  List<ProjectInvoice> invites;

  _handleRequestMessage() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Project Join Request!'),
            content: TextField(
              controller: message,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(hintText: "Write a Message"),
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              new FlatButton(
                child: new Text('Send'),
                onPressed: () async {
                  Navigator.pop(context);
                  setState(() {
                    requestLoading = true;
                  });
                  await getTokenPreferences().then((token) async {
                    await getUserPreferences().then((user) async {
                      await postProjectInvites(token, widget.projectOverview,
                              message.text, user.username)
                          .then((value) {
                        widget.handleInvites(value);
                        widget.handleInvites1(value);
                        handleInvites(value);
                        setState(() {
                          requestLoading = false;
                        });
                      });
                    });
                  });
                },
              )
            ],
          );
        });
  }

  _handleRequest() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text("Alert", style: TextStyle(color: Colors.red)),
            content: Text(
                "Maximum Project Create Limit Exceeded. Upgrade your Plan for more Project."),
            actions: [
              CupertinoDialogAction(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              CupertinoDialogAction(
                child: Text('Upgrade'),
                onPressed: () async {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return Plans();
                    },
                  ));
                },
              ),
            ],
          );
        });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      invites = widget.invites;
    });
  }

  handleInvites(ProjectInvoice data) {
    setState(() {
      invites = [...invites, data];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Project Overview'),
          centerTitle: true,
          backgroundColor: Colors.teal),
      backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Html(data: widget.projectOverview.projectDescription),
      ),
      bottomNavigationBar: Container(
          color: Colors.teal,
          width: MediaQuery.of(context).size.width,
          height: 50,
          child: FlatButton.icon(
              onPressed: invites
                          .where((element) =>
                              element.projectNameToJoin ==
                              widget.projectOverview.projectName)
                          .toList()
                          .length ==
                      0
                  ? !requestLoading
                      ? () {
                          getUserPreferences().then((user) {
                            if (user.projectCount >= user.noOfProject) {
                              _handleRequest();
                            } else {
                              _handleRequestMessage();
                            }
                          });
                        }
                      : null
                  : null,
              icon: Icon(
                Icons.send,
                color: Colors.white,
              ),
              label: invites
                          .where((element) =>
                              element.projectNameToJoin ==
                              widget.projectOverview.projectName)
                          .toList()
                          .length ==
                      0
                  ? !requestLoading
                      ? Text(
                          'Request To Join',
                          style: TextStyle(color: Colors.white),
                        )
                      : Center(child: SpinKitFoldingCube(color: Colors.teal))
                  : Text(
                      'Requested',
                      style: TextStyle(color: Colors.grey[200]),
                    ))),
    );
  }
}
