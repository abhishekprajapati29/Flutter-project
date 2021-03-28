import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fproject/DashBoard/api_response.dart';
import 'package:fproject/Team/api_response.dart';
import 'package:fproject/project/components/api_response.dart';
import 'package:fproject/setting/components/plans.dart';

import '../gettoken.dart';
import 'models.dart';

class Invites extends StatefulWidget {
  Invites({Key key}) : super(key: key);

  @override
  _InvitesState createState() => _InvitesState();
}

class _InvitesState extends State<Invites> {
  List<ProjectInvoice> invite;
  bool loading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      loading = true;
    });
    getTokenPreferences().then((token) async {
      await getAllProjectInvites(token).then((value) {
        setState(() {
          invite = value;
          loading = false;
        });
      });
    });
  }

  handleCancel(int id) {
    final data = invite.where((element) => element.id != id).toList();
    setState(() {
      invite = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Invite'),
        backgroundColor: Colors.teal,
      ),
      backgroundColor: Colors.white,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: !loading
              ? invite.length > 0
                  ? SingleChildScrollView(
                      child: Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: ListView.builder(
                        itemCount: invite.length,
                        itemBuilder: (context, index) {
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              children: [
                                ListTile(
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(
                                      builder: (context) {
                                        return InviteView(
                                            data: invite[index],
                                            handleCancel: handleCancel);
                                      },
                                    ));
                                  },
                                  leading: Icon(
                                    FontAwesomeIcons.envelopeOpenText,
                                    color: Colors.grey,
                                    size: 30,
                                  ),
                                  title: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Text(
                                      invite[index].invoice.capitalize(),
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  trailing: Icon(
                                    Icons.arrow_right,
                                    color: Colors.grey,
                                  ),
                                ),
                                Divider(
                                  thickness: 5,
                                )
                              ],
                            ),
                          );
                        },
                      ),
                    ))
                  : Center(
                      child: Text('No Invites'),
                    )
              : SpinKitFoldingCube(color: Colors.teal),
        ),
      ),
    );
  }
}

class InviteView extends StatelessWidget {
  final ProjectInvoice data;
  final Function handleCancel;
  const InviteView({Key key, this.data, this.handleCancel}) : super(key: key);

  _handleRequest(BuildContext context) {
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Invite'),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Center(
                  child: Text(
                data.invoice.capitalize(),
                style: TextStyle(fontSize: 25),
              )),
              SizedBox(
                height: 10,
              ),
              Divider(
                height: 2,
                color: Colors.blue,
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  child: Row(children: [
                    Text(
                      'Message by',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Spacer(),
                    Text(data.requestedBy.capitalize()),
                  ]),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  child: Row(children: [
                    Text(
                      'Message',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Spacer(),
                    Text(data.message.capitalize()),
                  ]),
                ),
              ),
              Divider(
                height: 2,
                color: Colors.blue,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 5,
        color: Colors.teal,
        child: Container(
          height: 50,
          child: Row(
            children: [
              Spacer(),
              FlatButton(
                  onPressed: () async {
                    await getTokenPreferences().then((token) async {
                      await deleteInvite(token, data.id).then((id) {
                        Navigator.pop(context);
                        handleCancel(id);
                      });
                    });
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: Colors.white),
                  )),
              Spacer(),
              VerticalDivider(
                color: Colors.white,
              ),
              Spacer(),
              FlatButton(
                  onPressed: () async {
                    await getTokenPreferences().then((token) async {
                      await projectDetail(token, data.projectNumber)
                          .then((projectdetail) async {
                        await getUserPreferences().then((users) async {
                          if (projectdetail.promem.length < users.noOfMember) {
                            await joinTeam(data, token).then((_) {
                              Navigator.pop(context);
                              Navigator.pop(context);
                              Navigator.popAndPushNamed(context, '/dashboard');
                            });
                          } else {
                            _handleRequest(context);
                          }
                        });
                      });
                    });
                  },
                  child: Text('Submit', style: TextStyle(color: Colors.white))),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
