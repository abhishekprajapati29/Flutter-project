import 'package:flutter/material.dart';

// ignore: must_be_immutable
class TodoChips extends StatefulWidget {
  List<String> todochipsdata = [];
  TodoChips({Key key, this.todochipsdata}) : super(key: key);

  @override
  _TodoChipsState createState() => _TodoChipsState();
}

Widget _titleContainer(String myTitle) {
  return Text(
    myTitle,
    style: TextStyle(
        color: Colors.black, fontSize: 24.0, fontWeight: FontWeight.bold),
  );
}

class _TodoChipsState extends State<TodoChips> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: _titleContainer('Choose Badges'),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            child: Wrap(
              spacing: 5.0,
              runSpacing: 3.0,
              children: <Widget>[
                Chips(chipName: 'Now', todochips: widget.todochipsdata),
                Chips(chipName: 'Urgent', todochips: widget.todochipsdata),
                Chips(chipName: 'Today', todochips: widget.todochipsdata),
                Chips(chipName: 'Meeting', todochips: widget.todochipsdata),
                Chips(chipName: 'Work', todochips: widget.todochipsdata),
                Chips(chipName: 'Home', todochips: widget.todochipsdata),
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
  List<String> todochips;
  Chips({Key key, this.chipName, this.todochips}) : super(key: key);

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
            if (widget.todochips.indexOf(widget.chipName) != -1) {
              widget.todochips.remove(widget.chipName);
            } else {
              widget.todochips.add(widget.chipName);
            }
          }),
    );
  }
}
