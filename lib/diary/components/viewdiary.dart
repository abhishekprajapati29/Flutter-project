import 'package:flutter/material.dart';
import 'package:fproject/diary/components/model.dart';

class ViewDiary extends StatefulWidget {
  DiaryModel editData;
  ViewDiary({Key key, this.editData}) : super(key: key);

  @override
  _ViewDiaryState createState() => _ViewDiaryState();
}

class _ViewDiaryState extends State<ViewDiary> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View'),
        backgroundColor: Colors.teal,
      ),
      backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  widget.editData.title,
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic),
                ),
              ),
              Divider(
                color: Colors.blue,
                thickness: 3,
              ),
              Padding(
                padding: const EdgeInsets.all(6.0),
                child: Text(widget.editData.text,
                    style:
                        TextStyle(fontSize: 20, fontStyle: FontStyle.normal)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
