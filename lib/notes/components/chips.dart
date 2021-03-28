import 'package:flutter/material.dart';

// ignore: must_be_immutable
class NoteChips extends StatefulWidget {
  List<String> noteChipsdata;
  NoteChips({Key key, this.noteChipsdata}) : super(key: key);

  @override
  _NoteChipsState createState() => _NoteChipsState();
}

Widget _titleContainer(String myTitle) {
  return Text(
    myTitle,
    style: TextStyle(
        color: Colors.black, fontSize: 24.0, fontWeight: FontWeight.bold),
  );
}

class _NoteChipsState extends State<NoteChips> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: _titleContainer('Choose Chips'),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            child: Wrap(
              spacing: 5.0,
              runSpacing: 3.0,
              children: <Widget>[
                Chips(chipName: 'Now', notechips: widget.noteChipsdata),
                Chips(chipName: 'Urgent', notechips: widget.noteChipsdata),
                Chips(chipName: 'Today', notechips: widget.noteChipsdata),
                Chips(chipName: 'Meeting', notechips: widget.noteChipsdata),
                Chips(chipName: 'Work', notechips: widget.noteChipsdata),
                Chips(chipName: 'Home', notechips: widget.noteChipsdata),
                Chips(chipName: 'School', notechips: widget.noteChipsdata),
              ],
            ),
          ),
        )
      ],
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
  var _isSelected = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FilterChip(
          label: Text(widget.chipName),
          labelStyle: TextStyle(
              color: Color(0xff6200ee),
              fontSize: 16.0,
              fontWeight: FontWeight.bold),
          selected: _isSelected,
          backgroundColor: Color(0xffededed),
          selectedColor: Color(0xffeadffd),
          onSelected: (isSelected) {
            setState(() {
              _isSelected = isSelected;
            });
            if (widget.notechips.indexOf(widget.chipName) != -1) {
              widget.notechips.remove(widget.chipName);
            } else {
              widget.notechips.add(widget.chipName);
            }
          }),
    );
  }
}
