import 'package:flutter/material.dart';

// ignore: must_be_immutable
class TodoEditChips extends StatefulWidget {
  List<String> todoeditchips = [];
  TodoEditChips({Key key, this.todoeditchips}) : super(key: key);

  @override
  _TodoEditChipsState createState() => _TodoEditChipsState();
}

Widget _titleContainer(String myTitle) {
  return Text(
    myTitle,
    style: TextStyle(
        color: Colors.black, fontSize: 24.0, fontWeight: FontWeight.bold),
  );
}

class _TodoEditChipsState extends State<TodoEditChips> {
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
                Chips(chipName: 'Now', todochips: widget.todoeditchips),
                Chips(chipName: 'Urgent', todochips: widget.todoeditchips),
                Chips(chipName: 'Today', todochips: widget.todoeditchips),
                Chips(chipName: 'Meeting', todochips: widget.todoeditchips),
                Chips(chipName: 'Work', todochips: widget.todoeditchips),
                Chips(chipName: 'Home', todochips: widget.todoeditchips),
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
  void initState() {
    super.initState();
    if (widget.todochips.indexOf(widget.chipName) != -1) {
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
            if (widget.todochips.indexOf(widget.chipName) != -1) {
              widget.todochips.remove(widget.chipName);
            } else {
              widget.todochips.add(widget.chipName);
            }
          }),
    );
  }
}
