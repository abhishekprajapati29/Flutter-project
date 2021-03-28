import 'package:flutter/material.dart';
import 'package:fproject/project/components/models.dart';
import 'package:intl/intl.dart';

class TaskView extends StatelessWidget {
  final Task data;
  const TaskView({Key key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text('Task',
            style: TextStyle(
                fontFamily: 'CrimsonTextRegular', fontWeight: FontWeight.bold)),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Center(
                    child: Text(
                  data.tasks,
                  style:
                      TextStyle(fontSize: 20, fontFamily: 'CrimsonTextRegular'),
                )),
                SizedBox(
                  height: 10,
                ),
                Divider(
                  height: 2,
                  thickness: 1,
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
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'CrimsonTextRegular'),
                      ),
                      Spacer(),
                      Text(
                        data.status,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: 'CrimsonTextRegular'),
                      ),
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
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'CrimsonTextRegular'),
                      ),
                      Spacer(),
                      Text(
                        data.requestedBy,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: 'CrimsonTextRegular'),
                      ),
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
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'CrimsonTextRegular'),
                      ),
                      Spacer(),
                      Text(
                        DateFormat('yyyy/MM/dd')
                            .format(DateTime.parse(data.dueDate)),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: 'CrimsonTextRegular'),
                      ),
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
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'CrimsonTextRegular'),
                      ),
                      Spacer(),
                      Text(
                          DateFormat('yyyy/MM/dd')
                              .format(DateTime.parse(data.timestamp)),
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'CrimsonTextRegular')),
                    ]),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
