import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fproject/DashBoard/api_response.dart';
import 'package:intl/intl.dart';
import 'package:fproject/DashBoard/models.dart';
import 'package:fproject/gettoken.dart';

class Notify extends StatefulWidget {
  Notify({Key key}) : super(key: key);

  @override
  _NotifyState createState() => _NotifyState();
}

class _NotifyState extends State<Notify> {
  List<NotificationModelDrawer> notification;
  bool loading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      loading = true;
    });
    getTokenPreferences().then((token) async {
      await getAllNotification(token).then((value) {
        setState(() {
          notification = value;
          loading = false;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notification'),
        backgroundColor: Colors.teal,
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: !loading
              ? notification.length > 0
                  ? SingleChildScrollView(
                      child: Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: ListView.builder(
                        itemCount: notification.length,
                        itemBuilder: (context, index) {
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              children: [
                                ListTile(
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(
                                      builder: (context) {
                                        return NotificationView(
                                            data: notification[index]);
                                      },
                                    ));
                                  },
                                  leading: Icon(
                                    FontAwesomeIcons.bell,
                                    color: Colors.grey,
                                    size: 30,
                                  ),
                                  title: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Text(
                                      notification[index].content,
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  subtitle: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Text(
                                      DateFormat('yyyy/MM/dd').format(
                                          DateTime.parse(
                                              notification[index].timestamp)),
                                      style: TextStyle(fontSize: 15),
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
                      child: Text('No Notification'),
                    )
              : SpinKitFoldingCube(color: Colors.teal),
        ),
      ),
    );
  }
}

class NotificationView extends StatelessWidget {
  final NotificationModelDrawer data;
  const NotificationView({Key key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Notification'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Center(
                  child: Text(
                data.content.capitalize(),
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
                      'Message By',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Spacer(),
                    Text(data.postedBy.capitalize()),
                  ]),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  child: Row(children: [
                    Text(
                      'Date',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
            ],
          ),
        ),
      ),
    );
  }
}
