import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fproject/gettoken.dart';
import 'package:intl/intl.dart';

import 'api_response.dart';
import 'models.dart';

class Messages extends StatefulWidget {
  Messages({Key key}) : super(key: key);

  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  List<MessageModelDrawer> messages;
  bool loading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      loading = true;
    });
    getTokenPreferences().then((token) async {
      await getAllMessages(token).then((value) {
        setState(() {
          messages = value;
          loading = false;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Messages'),
        backgroundColor: Colors.teal,
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: !loading
              ? messages.length > 0
                  ? SingleChildScrollView(
                      child: Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: ListView.builder(
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              children: [
                                ListTile(
                                  onTap: () {
                                    Navigator.push(context, MaterialPageRoute(
                                      builder: (context) {
                                        return MessageView(
                                            data: messages[index]);
                                      },
                                    ));
                                  },
                                  leading: Icon(
                                    Icons.message,
                                    color: Colors.grey,
                                    size: 30,
                                  ),
                                  title: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Text(
                                      messages[index].message,
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
                                              messages[index].timestamp)),
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
                      child: Text('No Messages'),
                    )
              : SpinKitFoldingCube(
                  color: Colors.teal,
                ),
        ),
      ),
    );
  }
}

class MessageView extends StatelessWidget {
  final MessageModelDrawer data;
  const MessageView({Key key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Message'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Center(
                  child: Text(
                data.message.capitalize(),
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
                    Text(data.messageBy.capitalize()),
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
