import 'package:flutter/material.dart';
import 'package:fproject/notes/components/models.dart';

class ViewNote extends StatefulWidget {
  NotesItem editData;
  ViewNote({Key key, this.editData}) : super(key: key);

  @override
  _ViewNoteState createState() => _ViewNoteState();
}

class _ViewNoteState extends State<ViewNote> {
  List<String> edited = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    for (var item in widget.editData.notechip) {
      edited.add(item.noteChips);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View'),
        backgroundColor: Colors.teal,
      ),
      backgroundColor: Colors.white,
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
                  widget.editData.noteTitle,
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
              Container(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Chips(chipName: 'Now', notechips: edited),
                      Chips(chipName: 'Urgent', notechips: edited),
                      Chips(chipName: 'Today', notechips: edited),
                      Chips(chipName: 'Meeting', notechips: edited),
                      Chips(chipName: 'Work', notechips: edited),
                      Chips(chipName: 'Home', notechips: edited),
                      Chips(chipName: 'School', notechips: edited),
                    ],
                  ),
                ),
              ),
              Divider(
                color: Colors.blue,
                thickness: 3,
              ),
              Padding(
                padding: const EdgeInsets.all(6.0),
                child: Text(widget.editData.noteContent,
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

class Chips extends StatefulWidget {
  final String chipName;
  List<String> notechips;
  Chips({Key key, this.chipName, this.notechips}) : super(key: key);

  @override
  _ChipsState createState() => _ChipsState();
}

class _ChipsState extends State<Chips> {
  var _isSelected = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: widget.notechips.indexOf(widget.chipName) != -1
          ? FilterChip(
              label: Text(widget.chipName),
              labelStyle: TextStyle(
                  color: Color(0xff6200ee),
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold),
              selected: true,
              backgroundColor: Color(0xffededed),
              selectedColor: Color(0xffeadffd),
              onSelected: (isSelected) {})
          : null,
    );
  }
}
