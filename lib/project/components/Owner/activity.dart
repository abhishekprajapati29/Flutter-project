import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fproject/project/components/models.dart';
import 'package:fproject/gettoken.dart';

class Activitys extends StatelessWidget {
  final List<Activity> data;
  const Activitys({Key key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          backgroundColor: Colors.teal,
          title: Text("Activity's"),
        ),
        body: ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  Container(
                      height: 70,
                      width: double.maxFinite,
                      color: Colors.white,
                      child: ListTile(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              return ActivityView(data: data[index]);
                            },
                          ));
                        },
                        title: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Text(data[index].activity.capitalize(),
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        subtitle: Text(DateFormat('yyyy/MM/dd')
                            .format(DateTime.parse(data[index].timestamp))),
                        trailing: IconButton(
                          icon: Icon(Icons.arrow_right),
                          onPressed: null,
                        ),
                      )),
                  Divider(
                    thickness: 5,
                  ),
                ],
              );
            }));
  }
}

class ActivityView extends StatelessWidget {
  final Activity data;
  const ActivityView({Key key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          title: Text('Activity Detail'),
          backgroundColor: Colors.teal,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Center(
                    child: Text(
                  data.activity.capitalize(),
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
                        'Type',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Spacer(),
                      Text(data.imageType),
                    ]),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    child: Row(children: [
                      Text(
                        'Member',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Spacer(),
                      Text(data.name),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
