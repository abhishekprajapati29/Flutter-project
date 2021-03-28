import 'package:flutter/material.dart';
import 'package:fproject/Team/model.dart';
import 'package:fproject/project/components/api_response.dart';
import 'package:fproject/project/components/models.dart';
import 'package:intl/intl.dart';
import 'package:fproject/gettoken.dart';

class Reports extends StatelessWidget {
  final List<Report> data;
  const Reports({Key key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text('Report'),
        backgroundColor: Colors.teal,
        actions: [],
      ),
      body: Container(
        color: Colors.grey[200],
        child: ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              return Container(
                height: 80,
                width: double.maxFinite,
                child: Card(
                  color: Colors.white,
                  elevation: 5,
                  child: ListTile(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return ReportView(data: data[index]);
                        },
                      ));
                    },
                    title: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Text(data[index].report.capitalize(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                    subtitle: Text(
                        " By:- ${data[index].postedBy} (${data[index].status})"),
                    trailing: Text(DateFormat('yyyy/MM/dd')
                        .format(DateTime.parse(data[index].timestamp))),
                  ),
                ),
              );
            }),
      ),
    );
  }
}

class ReportMember extends StatefulWidget {
  List<Report> data;
  UserModel user;
  Function handleProjectData;
  Function handleProjectData1;
  ProjectModel currentUserProjects;

  ReportMember(
      {Key key,
      this.data,
      this.handleProjectData,
      this.handleProjectData1,
      this.user,
      this.currentUserProjects})
      : super(key: key);

  @override
  _ReportMemberState createState() => _ReportMemberState();
}

class _ReportMemberState extends State<ReportMember> {
  List<Report> data;

  handleProjectData2(ProjectModel values) {
    setState(() {
      data = values.report
          .where((element) => element.postedBy == widget.user.username)
          .toList();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      data = widget.data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text('Report'),
        backgroundColor: Colors.teal,
        actions: [],
      ),
      body: Container(
        color: Colors.grey[200],
        child: ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              return Container(
                height: 80,
                width: double.maxFinite,
                child: Card(
                  color: Colors.white,
                  elevation: 5,
                  child: ListTile(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (context) {
                          return ReportView(data: data[index]);
                        },
                      ));
                    },
                    title: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Text(data[index].report.capitalize(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                    subtitle: Text(
                        " By:- ${data[index].postedBy} (${data[index].status})"),
                    trailing: Text(DateFormat('yyyy/MM/dd')
                        .format(DateTime.parse(data[index].timestamp))),
                  ),
                ),
              );
            }),
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.teal,
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return WriteReport(
                  data: widget.currentUserProjects,
                  user: widget.user,
                  handleProjectData1: widget.handleProjectData1,
                  handleProjectData: widget.handleProjectData,
                  handleProjectData2: handleProjectData2);
            }));
          }),
    );
  }
}

class ReportView extends StatelessWidget {
  final Report data;
  const ReportView({Key key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          title: Text('Report Detail'),
          backgroundColor: Colors.teal,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Center(
                    child: Text(
                  data.report,
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
                        'Status',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Spacer(),
                      Text(data.status),
                    ]),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    child: Row(children: [
                      Text(
                        'Assigned By',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Spacer(),
                      Text(data.postedBy),
                    ]),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    child: Row(children: [
                      Text(
                        'Date',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Spacer(),
                      Text(
                        DateFormat('yyyy/MM/dd')
                            .format(DateTime.parse(data.timestamp)),
                      ),
                    ]),
                  ),
                ),
                Divider(
                  height: 2,
                  color: Colors.blue,
                ),
                Center(
                    child: Text(
                  'Description',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                )),
                SizedBox(
                  height: 10,
                ),
                Center(
                    child: Text(
                  data.comment,
                  style: TextStyle(fontSize: 20),
                )),
                Divider(
                  height: 2,
                  color: Colors.blue,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

enum SingingCharacter { Success, Hold, Pending, Error }

class WriteReport extends StatefulWidget {
  ProjectModel data;
  UserModel user;
  Function handleProjectData;
  Function handleProjectData1;
  Function handleProjectData2;
  WriteReport(
      {Key key,
      this.data,
      this.user,
      this.handleProjectData,
      this.handleProjectData1,
      this.handleProjectData2})
      : super(key: key);

  @override
  _WriteReportState createState() => _WriteReportState();
}

class _WriteReportState extends State<WriteReport> {
  TextEditingController reportController = new TextEditingController();
  TextEditingController commentController = new TextEditingController();
  SingingCharacter report = SingingCharacter.Pending;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Report'),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.edit,
                      color: Colors.teal,
                      size: 40,
                    ),
                    onPressed: () {},
                  ),
                  SizedBox(
                    height: 18.0,
                  ),
                  TextField(
                    controller: reportController,
                    keyboardType: TextInputType.text,
                    cursorColor: Colors.black,
                    style: TextStyle(color: Colors.black),
                    decoration: new InputDecoration(
                      border: new OutlineInputBorder(
                          borderSide: new BorderSide(color: Colors.black)),
                      hintText: 'Write Report ...',
                      labelText: 'Report',
                    ),
                  ),
                  SizedBox(
                    height: 18.0,
                  ),
                  Text('Status',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  SizedBox(
                    height: 18.0,
                  ),
                  Container(
                    child: Column(
                      children: [
                        ListTile(
                          title: const Text('Success'),
                          leading: Radio(
                            value: SingingCharacter.Success,
                            groupValue: report,
                            onChanged: (SingingCharacter value) {
                              setState(() {
                                report = value;
                              });
                            },
                          ),
                        ),
                        ListTile(
                          title: const Text('Hold'),
                          leading: Radio(
                            value: SingingCharacter.Hold,
                            groupValue: report,
                            onChanged: (SingingCharacter value) {
                              setState(() {
                                report = value;
                              });
                            },
                          ),
                        ),
                        ListTile(
                          title: const Text('Pending'),
                          leading: Radio(
                            value: SingingCharacter.Pending,
                            groupValue: report,
                            onChanged: (SingingCharacter value) {
                              setState(() {
                                report = value;
                              });
                            },
                          ),
                        ),
                        ListTile(
                          title: const Text('Error'),
                          leading: Radio(
                            value: SingingCharacter.Error,
                            groupValue: report,
                            onChanged: (SingingCharacter value) {
                              print(value);
                              setState(() {
                                report = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 18.0,
                  ),
                  TextField(
                    controller: commentController,
                    keyboardType: TextInputType.text,
                    cursorColor: Colors.black,
                    style: TextStyle(color: Colors.black),
                    decoration: new InputDecoration(
                      border: new OutlineInputBorder(
                          borderSide: new BorderSide(color: Colors.black)),
                      hintText: 'Description',
                      labelText: 'Description',
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      onPressed: () async {
                        await getTokenPreferences().then((token) async {
                          await sendReport(
                            token,
                            widget.user.username,
                            widget.data,
                            reportController.text,
                            commentController.text,
                            report.toString().substring(17),
                          ).then((value) async {
                            await widget.handleProjectData(value);
                            await widget.handleProjectData1(value);
                            await widget.handleProjectData2(value);
                            Navigator.pop(context);
                          });
                        });
                      },
                      color: Colors.teal,
                      child:
                          Text('Submit', style: TextStyle(color: Colors.white)))
                ],
              ),
            ),
          ),
          color: Colors.grey[200],
        ),
      ),
    );
  }
}
