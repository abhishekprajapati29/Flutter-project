import 'package:flutter/material.dart';

// ignore: must_be_immutable
class NoteEditChips extends StatefulWidget {
  List<String> editChip = [];
  NoteEditChips({Key key, this.editChip}) : super(key: key);

  @override
  _NoteEditChipsState createState() => _NoteEditChipsState();
}

Widget _titleContainer(String myTitle) {
  return Text(
    myTitle,
    style: TextStyle(
        color: Colors.black, fontSize: 24.0, fontWeight: FontWeight.bold),
  );
}

class _NoteEditChipsState extends State<NoteEditChips> {
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
                Chips(chipName: 'Now', notechips: widget.editChip),
                Chips(chipName: 'Urgent', notechips: widget.editChip),
                Chips(chipName: 'Today', notechips: widget.editChip),
                Chips(chipName: 'Meeting', notechips: widget.editChip),
                Chips(chipName: 'Work', notechips: widget.editChip),
                Chips(chipName: 'Home', notechips: widget.editChip),
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
  void initState() {
    super.initState();
    if (widget.notechips.indexOf(widget.chipName) != -1) {
      setState(() {
        this._isSelected = true;
      });
    }
  }

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
