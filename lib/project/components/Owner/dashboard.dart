import 'package:carousel_slider/carousel_slider.dart';
import 'package:filesize/filesize.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';
import 'package:fproject/Team/model.dart';
import 'package:fproject/project/components/models.dart';

class Dashboard extends StatefulWidget {
  ProjectModel currentUserProjects;
  UserModel currentUserData;
  Dashboard({Key key, this.currentUserProjects, this.currentUserData})
      : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[200],
      child: ListView(
        children: <Widget>[
          SizedBox(height: 15.0),
          CarouselSlider(
            options: CarouselOptions(
              height: MediaQuery.of(context).size.height * 0.85,
              enlargeCenterPage: true,
              autoPlay: true,
              aspectRatio: 16 / 9,
              autoPlayCurve: Curves.fastOutSlowIn,
              enableInfiniteScroll: true,
              autoPlayAnimationDuration: Duration(milliseconds: 800),
              viewportFraction: 0.8,
            ),
            items: [
              Container(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    Card(
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.20,
                        margin: EdgeInsets.all(5.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.teal[800]),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Spacer(),
                            Row(
                              children: [
                                Spacer(),
                                Icon(
                                  FontAwesomeIcons.tasks,
                                  color: Colors.white,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'Tasks',
                                    style: TextStyle(
                                      fontFamily: 'CrimsonTextRegular',
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 35.0,
                                    ),
                                  ),
                                ),
                                Spacer(),
                              ],
                            ),
                            Spacer(),
                            Row(
                              children: [
                                Spacer(),
                                widget.currentUserData.username ==
                                        widget.currentUserProjects.username
                                    ? Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10,
                                            right: 10,
                                            top: 15,
                                            bottom: 15),
                                        child: Text(
                                          'Total: ${widget.currentUserProjects.totalTaskCount}',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'CrimsonTextRegular',
                                            fontSize: 20.0,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      )
                                    : Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10,
                                            right: 10,
                                            top: 15,
                                            bottom: 15),
                                        child: Text(
                                          'Total: ${widget.currentUserProjects.task.where((element) => element.requestedTo == widget.currentUserData.username).toList().length}',
                                          style: TextStyle(
                                            fontFamily: 'CrimsonTextRegular',
                                            color: Colors.white,
                                            fontSize: 20.0,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                Spacer(),
                                widget.currentUserData.username ==
                                        widget.currentUserProjects.username
                                    ? Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: Text(
                                          'Success: ${widget.currentUserProjects.successTaskCount}',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20.0,
                                            fontFamily: 'CrimsonTextRegular',
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      )
                                    : Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: Text(
                                          'Success: ${widget.currentUserProjects.task.where((element) => element.requestedTo == widget.currentUserData.username && element.status == 'Success').toList().length}',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'CrimsonTextRegular',
                                            fontSize: 20.0,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                Spacer(),
                              ],
                            ),
                            Spacer(),
                          ],
                        ),
                      ),
                    ),
                    widget.currentUserData.username ==
                            widget.currentUserProjects.username
                        ? Card(
                            elevation: 8,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            child: Container(
                                width: MediaQuery.of(context).size.width,
                                height:
                                    MediaQuery.of(context).size.height * 0.45,
                                margin: EdgeInsets.all(5.0),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    color: Colors.white70),
                                child: AnimatedCircularChart(
                                  duration: Duration(milliseconds: 1500),
                                  size: Size(
                                      MediaQuery.of(context).size.height * 0.40,
                                      MediaQuery.of(context).size.height *
                                          0.40),
                                  initialChartData: <CircularStackEntry>[
                                    new CircularStackEntry(
                                      <CircularSegmentEntry>[
                                        new CircularSegmentEntry(
                                          ((widget.currentUserProjects
                                                      .successTaskCount) *
                                                  100) /
                                              widget.currentUserProjects
                                                  .totalTaskCount,
                                          Colors.teal[800],
                                          rankKey: 'completed',
                                        ),
                                        new CircularSegmentEntry(
                                          ((widget.currentUserProjects
                                                          .totalTaskCount -
                                                      widget.currentUserProjects
                                                          .successTaskCount) *
                                                  100) /
                                              widget.currentUserProjects
                                                  .totalTaskCount,
                                          Colors.grey[200],
                                          rankKey: 'remaining',
                                        ),
                                      ],
                                      rankKey: 'progress',
                                    ),
                                  ],
                                  chartType: CircularChartType.Radial,
                                  percentageValues: true,
                                  holeLabel: (((widget.currentUserProjects
                                                      .successTaskCount) *
                                                  100) /
                                              widget.currentUserProjects
                                                  .totalTaskCount)
                                          .toStringAsFixed(1) +
                                      '%',
                                  labelStyle: new TextStyle(
                                    color: Colors.teal[800],
                                    fontFamily: 'CrimsonTextRegular',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24.0,
                                  ),
                                )),
                          )
                        : Card(
                            elevation: 8,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            child: Container(
                                width: MediaQuery.of(context).size.width,
                                height:
                                    MediaQuery.of(context).size.height * 0.45,
                                margin: EdgeInsets.all(5.0),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    color: Colors.white70),
                                child: AnimatedCircularChart(
                                  duration: Duration(milliseconds: 1500),
                                  size: Size(
                                      MediaQuery.of(context).size.height * 0.40,
                                      MediaQuery.of(context).size.height *
                                          0.40),
                                  initialChartData: <CircularStackEntry>[
                                    new CircularStackEntry(
                                      <CircularSegmentEntry>[
                                        new CircularSegmentEntry(
                                          ((widget.currentUserProjects.task
                                                      .where((element) =>
                                                          element.requestedTo ==
                                                              widget
                                                                  .currentUserData
                                                                  .username &&
                                                          element.status ==
                                                              'Success')
                                                      .toList()
                                                      .length) *
                                                  100) /
                                              widget.currentUserProjects.task
                                                  .where((element) =>
                                                      element.requestedTo ==
                                                      widget.currentUserData
                                                          .username)
                                                  .toList()
                                                  .length,
                                          Colors.teal[800],
                                          rankKey: 'completed',
                                        ),
                                        new CircularSegmentEntry(
                                          ((widget.currentUserProjects.task
                                                          .where((element) =>
                                                              element.requestedTo ==
                                                              widget
                                                                  .currentUserData
                                                                  .username)
                                                          .toList()
                                                          .length -
                                                      widget.currentUserProjects
                                                          .task
                                                          .where((element) =>
                                                              element.requestedTo ==
                                                                  widget
                                                                      .currentUserData
                                                                      .username &&
                                                              element.status ==
                                                                  'Success')
                                                          .toList()
                                                          .length) *
                                                  100) /
                                              widget.currentUserProjects.task
                                                  .where((element) =>
                                                      element.requestedTo ==
                                                      widget.currentUserData
                                                          .username)
                                                  .toList()
                                                  .length,
                                          Colors.grey[200],
                                          rankKey: 'remaining',
                                        ),
                                      ],
                                      rankKey: 'progress',
                                    ),
                                  ],
                                  chartType: CircularChartType.Radial,
                                  percentageValues: true,
                                  holeLabel: (((widget.currentUserProjects.task
                                                      .where((element) =>
                                                          element.requestedTo ==
                                                              widget
                                                                  .currentUserData
                                                                  .username &&
                                                          element.status ==
                                                              'Success')
                                                      .toList()
                                                      .length) *
                                                  100) /
                                              widget.currentUserProjects.task
                                                  .where((element) =>
                                                      element.requestedTo ==
                                                      widget.currentUserData
                                                          .username)
                                                  .toList()
                                                  .length)
                                          .toStringAsFixed(1) +
                                      '%',
                                  labelStyle: new TextStyle(
                                    color: Colors.teal[800],
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'CrimsonTextRegular',
                                    fontSize: 24.0,
                                  ),
                                )),
                          ),
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    Card(
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.20,
                        margin: EdgeInsets.all(5.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.teal[800]),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Spacer(),
                            Row(
                              children: [
                                Spacer(),
                                Icon(
                                  FontAwesomeIcons.bug,
                                  color: Colors.white,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'Bugs',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'CrimsonTextRegular',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 35.0,
                                    ),
                                  ),
                                ),
                                Spacer(),
                              ],
                            ),
                            Spacer(),
                            Row(
                              children: [
                                Spacer(),
                                widget.currentUserData.username ==
                                        widget.currentUserProjects.username
                                    ? Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: Text(
                                          'Total: ${widget.currentUserProjects.totalBugsCount}',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'CrimsonTextRegular',
                                            fontSize: 20.0,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      )
                                    : Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: Text(
                                          'Total: ${widget.currentUserProjects.bugs.where((element) => element.requestedTo == widget.currentUserData.username).toList().length}',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20.0,
                                            fontFamily: 'CrimsonTextRegular',
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                Spacer(),
                                widget.currentUserData.username ==
                                        widget.currentUserProjects.username
                                    ? Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: Text(
                                          'Success: ${widget.currentUserProjects.bugs.where((element) => element.requestedTo == widget.currentUserData.username && element.status == 'Success').toList().length}',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'CrimsonTextRegular',
                                            fontSize: 20.0,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      )
                                    : Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: Text(
                                          'Success: ${widget.currentUserProjects.successBugsCount}',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'CrimsonTextRegular',
                                            fontSize: 20.0,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                Spacer(),
                              ],
                            ),
                            Spacer(),
                          ],
                        ),
                      ),
                    ),
                    widget.currentUserData.username ==
                            widget.currentUserProjects.username
                        ? Card(
                            elevation: 8,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            child: Container(
                                width: MediaQuery.of(context).size.width,
                                height:
                                    MediaQuery.of(context).size.height * 0.45,
                                margin: EdgeInsets.all(5.0),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    color: Colors.white70),
                                child: AnimatedCircularChart(
                                  duration: Duration(milliseconds: 1500),
                                  size: Size(
                                      MediaQuery.of(context).size.height * 0.40,
                                      MediaQuery.of(context).size.height *
                                          0.40),
                                  initialChartData: <CircularStackEntry>[
                                    new CircularStackEntry(
                                      <CircularSegmentEntry>[
                                        new CircularSegmentEntry(
                                          ((widget.currentUserProjects
                                                      .successBugsCount) *
                                                  100) /
                                              widget.currentUserProjects
                                                  .totalBugsCount,
                                          Colors.teal[800],
                                          rankKey: 'completed',
                                        ),
                                        new CircularSegmentEntry(
                                          ((widget.currentUserProjects
                                                          .totalBugsCount -
                                                      widget.currentUserProjects
                                                          .successBugsCount) *
                                                  100) /
                                              widget.currentUserProjects
                                                  .totalBugsCount,
                                          Colors.grey[200],
                                          rankKey: 'remaining',
                                        ),
                                      ],
                                      rankKey: 'progress',
                                    ),
                                  ],
                                  chartType: CircularChartType.Radial,
                                  percentageValues: true,
                                  holeLabel: (((widget.currentUserProjects
                                                      .successBugsCount) *
                                                  100) /
                                              widget.currentUserProjects
                                                  .totalBugsCount)
                                          .toStringAsFixed(1) +
                                      '%',
                                  labelStyle: new TextStyle(
                                    color: Colors.teal[800],
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24.0,
                                    fontFamily: 'CrimsonTextRegular',
                                  ),
                                )),
                          )
                        : Card(
                            elevation: 8,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            child: Container(
                                width: MediaQuery.of(context).size.width,
                                height:
                                    MediaQuery.of(context).size.height * 0.45,
                                margin: EdgeInsets.all(5.0),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    color: Colors.white70),
                                child: AnimatedCircularChart(
                                  duration: Duration(milliseconds: 1500),
                                  size: Size(
                                      MediaQuery.of(context).size.height * 0.40,
                                      MediaQuery.of(context).size.height *
                                          0.40),
                                  initialChartData: <CircularStackEntry>[
                                    new CircularStackEntry(
                                      <CircularSegmentEntry>[
                                        new CircularSegmentEntry(
                                          ((widget.currentUserProjects.bugs
                                                      .where((element) =>
                                                          element.requestedTo ==
                                                              widget
                                                                  .currentUserData
                                                                  .username &&
                                                          element.status ==
                                                              'Success')
                                                      .toList()
                                                      .length) *
                                                  100) /
                                              widget.currentUserProjects.bugs
                                                  .where((element) =>
                                                      element.requestedTo ==
                                                      widget.currentUserData
                                                          .username)
                                                  .toList()
                                                  .length,
                                          Colors.teal[800],
                                          rankKey: 'completed',
                                        ),
                                        new CircularSegmentEntry(
                                          ((widget.currentUserProjects.bugs
                                                          .where((element) =>
                                                              element.requestedTo ==
                                                              widget
                                                                  .currentUserData
                                                                  .username)
                                                          .toList()
                                                          .length -
                                                      widget.currentUserProjects
                                                          .bugs
                                                          .where((element) =>
                                                              element.requestedTo ==
                                                                  widget
                                                                      .currentUserData
                                                                      .username &&
                                                              element.status ==
                                                                  'Success')
                                                          .toList()
                                                          .length) *
                                                  100) /
                                              widget.currentUserProjects.bugs
                                                  .where((element) =>
                                                      element.requestedTo ==
                                                      widget.currentUserData
                                                          .username)
                                                  .toList()
                                                  .length,
                                          Colors.grey[200],
                                          rankKey: 'remaining',
                                        ),
                                      ],
                                      rankKey: 'progress',
                                    ),
                                  ],
                                  chartType: CircularChartType.Radial,
                                  percentageValues: true,
                                  holeLabel: (((widget.currentUserProjects.bugs
                                                      .where((element) =>
                                                          element.requestedTo ==
                                                              widget
                                                                  .currentUserData
                                                                  .username &&
                                                          element.status ==
                                                              'Success')
                                                      .toList()
                                                      .length) *
                                                  100) /
                                              widget.currentUserProjects.bugs
                                                  .where((element) =>
                                                      element.requestedTo ==
                                                      widget.currentUserData
                                                          .username)
                                                  .toList()
                                                  .length)
                                          .toStringAsFixed(1) +
                                      '%',
                                  labelStyle: new TextStyle(
                                    color: Colors.teal[800],
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24.0,
                                    fontFamily: 'CrimsonTextRegular',
                                  ),
                                )),
                          ),
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    Card(
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.20,
                        margin: EdgeInsets.all(5.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.teal[800]),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Spacer(),
                            Row(
                              children: [
                                Spacer(),
                                Icon(
                                  Icons.cloud_upload,
                                  color: Colors.white,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Uploaded's",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'CrimsonTextRegular',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 35.0,
                                    ),
                                  ),
                                ),
                                Spacer(),
                              ],
                            ),
                            Spacer(),
                            Row(
                              children: [
                                Spacer(),
                                Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Text(
                                    'Me: ${widget.currentUserProjects.file.where((element) => element.uploadedBy == widget.currentUserData.username).toList().length}',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'CrimsonTextRegular',
                                      fontSize: 20.0,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Spacer(),
                                Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Text(
                                    'Others: ${widget.currentUserProjects.file.where((element) => element.uploadedBy != widget.currentUserData.username).toList().length}',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'CrimsonTextRegular',
                                      fontSize: 20.0,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Spacer(),
                              ],
                            ),
                            Spacer(),
                          ],
                        ),
                      ),
                    ),
                    Card(
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.45,
                          margin: EdgeInsets.all(5.0),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: Colors.white70),
                          child: AnimatedCircularChart(
                            duration: Duration(milliseconds: 1500),
                            size: Size(
                                MediaQuery.of(context).size.height * 0.40,
                                MediaQuery.of(context).size.height * 0.40),
                            initialChartData: <CircularStackEntry>[
                              new CircularStackEntry(
                                <CircularSegmentEntry>[
                                  new CircularSegmentEntry(
                                    (widget.currentUserProjects.fileSize *
                                            100) /
                                        widget.currentUserProjects.projectSize,
                                    Colors.teal[800],
                                    rankKey: 'completed',
                                  ),
                                  new CircularSegmentEntry(
                                    100 -
                                        (widget.currentUserProjects.fileSize *
                                                100) /
                                            widget.currentUserProjects
                                                .projectSize,
                                    Colors.grey[200],
                                    rankKey: 'remaining',
                                  ),
                                ],
                                rankKey: 'progress',
                              ),
                            ],
                            chartType: CircularChartType.Radial,
                            percentageValues: true,
                            holeLabel: (widget.currentUserProjects.fileSize !=
                                        null
                                    ? filesize(
                                            widget.currentUserProjects.fileSize,
                                            0)
                                        .toString()
                                    : '0 B') +
                                '/' +
                                filesize(widget.currentUserProjects.projectSize)
                                    .toString(),
                            labelStyle: new TextStyle(
                              color: Colors.teal[800],
                              fontWeight: FontWeight.bold,
                              fontFamily: 'CrimsonTextRegular',
                              fontSize: 18.0,
                            ),
                          )),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
