import 'package:flutter/material.dart';
import 'package:fproject/project/components/models.dart';
import 'package:intl/intl.dart';

class BugView extends StatelessWidget {
  final Bugs data;
  const BugView({Key key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text('Bug',
            style: TextStyle(
                fontFamily: 'CrimsonTextRegular', fontWeight: FontWeight.bold)),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Center(
                  child: Text(
                data.bugs,
                style: TextStyle(
                    fontFamily: 'CrimsonTextRegular',
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              )),
              SizedBox(
                height: 10,
              ),
              Divider(
                height: 2,
                color: Colors.teal,
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
                          fontFamily: 'CrimsonTextRegular',
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
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
                          fontFamily: 'CrimsonTextRegular',
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                    Spacer(),
                    Text(data.requestedBy),
                  ]),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  child: Row(children: [
                    Text(
                      'DeadLine',
                      style: TextStyle(
                          fontFamily: 'CrimsonTextRegular',
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                    Spacer(),
                    Text(
                        DateFormat('yyyy/MM/dd')
                            .format(DateTime.parse(data.dueDate)),
                        style: TextStyle(
                            fontFamily: 'CrimsonTextRegular',
                            fontWeight: FontWeight.bold)),
                  ]),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  child: Row(children: [
                    Text(
                      'Assigned Date',
                      style: TextStyle(
                          fontFamily: 'CrimsonTextRegular',
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                    Spacer(),
                    Text(
                        DateFormat('yyyy/MM/dd')
                            .format(DateTime.parse(data.timestamp)),
                        style: TextStyle(
                            fontFamily: 'CrimsonTextRegular',
                            fontWeight: FontWeight.bold)),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
