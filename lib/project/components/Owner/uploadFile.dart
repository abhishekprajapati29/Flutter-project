import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fproject/gettoken.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fproject/Team/model.dart';
import 'package:fproject/gettoken.dart';
import 'package:fproject/project/components/models.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'dart:io' as file;

import 'package:permission_handler/permission_handler.dart';

class UploadedFiles extends StatefulWidget {
  List<File> data;
  UserModel currentUserData;
  ProjectModel currentUserProjects;
  UploadedFiles(
      {Key key, this.data, this.currentUserData, this.currentUserProjects})
      : super(key: key);

  @override
  _UploadedFilesState createState() => _UploadedFilesState();
}

class _UploadedFilesState extends State<UploadedFiles> {
  ProjectModel currentUserProjects;
  List<File> data;
  bool loading = false;
  String _fileName = "";
  String _path;
  file.File _file;
  Map<String, String> _paths;
  List<file.File> _files;
  String _extension;
  bool _switchValue = false;
  bool _multiPick = false;
  bool _hasValidMime = false;
  FileType _pickingType;
  TextEditingController _controller = new TextEditingController();
  bool downloading = false;
  var progressString = "";
  int totalprogressString = 0;
  int totaldownloadprogress = 0;
  int runningdownloadprogress = 0;
  var downloadprogress = '';
  int downloadIndex = 0;
  int runningprogressString = 0;

  Future<void> downloadFile(String url, String name) async {
    var dio = Dio();

    try {
      if (await Permission.storage.request().isGranted) {
        await Permission.storage.request();
        Directory appDocDir = await getExternalStorageDirectory();
        await dio.download(url, "${appDocDir.path}/$name",
            onReceiveProgress: (rec, total) {
          print(
            "Rec: $rec , Total: $total, Download: ${(((rec / total) * 100) / 100).toStringAsFixed(1)}",
          );

          setState(() {
            downloading = true;
            totaldownloadprogress = total;
            runningdownloadprogress = rec;
            downloadprogress = ((rec / total) * 100).toStringAsFixed(0) + "%";
          });
        });
      }
    } catch (e) {
      print(e);
    }

    setState(() {
      downloading = false;
      downloadprogress = "Completed";
      downloadIndex = 0;
    });
    print("Download completed");
  }

  @override
  void initState() {
    super.initState();
    _controller.addListener(() => _extension = _controller.text);
    setState(() {
      currentUserProjects = widget.currentUserProjects;
      data = widget.data.where((element) => element.selected == true).toList();
    });
  }

  void _openFileExplorer(int id, String username) async {
    try {
      if (_multiPick) {
        _path = null;
        _files = null;
      } else {
        _paths = null;
        _file = await FilePicker.getFile(
            type: FileType.custom,
            allowedExtensions: ['pdf', 'zip', 'png', 'jpg', 'jpeg']);
        _path = _file.path;
        await getTokenPreferences().then((token) {
          createFile(token, {
            'name': _path.split('/').last,
            'length': _file.lengthSync(),
            'filepath': _file.path,
            'filename': _path.split('/').last,
            'id': id.toString(),
            'uploaded': username,
            'type': _path.split('.').last
          }).then((value) async {
            print(value.id);
            print(data.length);
            setState(() {
              data = value.file
                  .where((element) => element.selected == true)
                  .toList();
            });
            print(data.length);
          });
        });
        setState(() {
          _file = _file;
          _path = _path;
        });
      }
    } on PlatformException catch (e) {
      print("Unsupported operation" + e.toString());
    }
    if (!mounted) return;

    setState(() {
      _fileName = _path != null
          ? _path.split('/').last
          : _paths != null ? _paths.keys.toString() : '...';
    });
  }

  Future<ProjectModel> createFile(String token, data) async {
    print(token);
    print(data['filename']);
    print(data['name']);
    print(data['id']);
    ProjectModel finaldata;
    print(data['filepath']);
    var dio = new Dio();
    dio.options.headers[file.HttpHeaders.authorizationHeader] =
        "Token " + token;
    FormData formData = FormData.fromMap({
      "title": data['name'],
      "files": await MultipartFile.fromFile(data['filepath'],
          filename: data['name']),
      'type': data['type'],
      'size': data['length'],
      "project_id": data['id'],
      "selected": true,
      "uploaded_by": data['uploaded']
    });
    await dio.post(
      "http://abhishekpraja.pythonanywhere.com/project-file-all/",
      data: formData,
      onSendProgress: (rec, total) {
        print("Rec: $rec , Total: $total");

        setState(() {
          totalprogressString = total;
          runningprogressString = rec;
          progressString = ((rec / total) * 100).toStringAsFixed(0) + "%";
        });
      },
    ).then((value) async {
      final json = value.data;
      var collection = <File>[];

      for (var item in currentUserProjects.file) {
        collection.add(item);
      }
      final data = File(
        id: json['id'],
        files: json['files'],
        uploadedBy: json['uploaded_by'],
        title: json['title'],
        type: json['type'],
        selected: json['selected'],
        timestamp: json['timestamp'],
        size: json['size'],
        projectId: json['project_id'],
      );
      collection.add(data);
      collection.sort((a, b) => b.id.compareTo(a.id));

      finaldata = ProjectModel(
          id: currentUserProjects.id,
          userId: currentUserProjects.userId,
          username: currentUserProjects.username,
          projectName: currentUserProjects.projectName,
          mainApplication: currentUserProjects.mainApplication,
          startDate: currentUserProjects.startDate,
          endDate: currentUserProjects.endDate,
          projectSize: currentUserProjects.projectSize,
          projectDescription: currentUserProjects.projectDescription,
          preferenece: currentUserProjects.preferenece,
          status: currentUserProjects.status,
          selected: currentUserProjects.selected,
          promemCount: currentUserProjects.promemCount,
          selectedFileCount: currentUserProjects.selectedFileCount + 1,
          selectedFileSize:
              currentUserProjects.selectedFileCount + json['size'],
          totalBugsCount: currentUserProjects.totalBugsCount,
          successBugsCount: currentUserProjects.successBugsCount,
          totalTaskCount: currentUserProjects.totalTaskCount,
          successTaskCount: currentUserProjects.successTaskCount,
          fileCount: currentUserProjects.fileCount + 1,
          activityCount: currentUserProjects.activityCount,
          reportCount: currentUserProjects.reportCount,
          successReportCount: currentUserProjects.successReportCount,
          prochip: currentUserProjects.prochip,
          task: currentUserProjects.task,
          bugs: currentUserProjects.bugs,
          fileSize: currentUserProjects.fileSize + json['size'],
          file: collection,
          forums: currentUserProjects.forums,
          report: currentUserProjects.report,
          activity: currentUserProjects.activity,
          promem: currentUserProjects.promem,
          isExpanded: false);
    }).catchError((error) => print(error.response.toString()));
    return finaldata;
  }

  loadingchange() {
    this.setState(() {
      loading = !loading;
    });
  }

  @override
  Widget build(BuildContext context) {
    print(data.toString());
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text("File's"),
      ),
      body: ListView.builder(
        padding:
            const EdgeInsets.only(bottom: kFloatingActionButtonMargin + 48),
        itemCount: data.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
            child: Container(
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      padding: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(40)),
                        // shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      child: filterImageList
                                  .indexOf(data[index].title.split('.').last) !=
                              -1
                          ? CircleAvatar(
                              radius: 30,
                              backgroundImage: NetworkImage(data[index].files),
                            )
                          : filterFileList.indexOf(
                                      data[index].title.split('.').last) !=
                                  -1
                              ? Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(15, 15, 15, 15),
                                  child: Icon(Icons.picture_as_pdf, size: 30),
                                )
                              : filterVideoList.indexOf(
                                          data[index].title.split('.').last) !=
                                      -1
                                  ? Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          15, 15, 15, 15),
                                      child:
                                          Icon(Icons.video_library, size: 30),
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          15, 15, 15, 15),
                                      child: Icon(FontAwesomeIcons.image,
                                          size: 30),
                                    ),
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: <Widget>[
                            Text(
                              data[index].title.length > 10
                                  ? data[index].title.substring(0, 10) + ' ...'
                                  : data[index].title,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              alignment: Alignment.topLeft,
                              child: Text(
                                'Uploaded By:- ${data[index].uploadedBy}',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.black54,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                            ),
                          ],
                        ),
                        !downloading
                            ? IconButton(
                                icon: Icon(Icons.file_download),
                                onPressed: () {
                                  setState(() {
                                    downloadIndex = index;
                                  });
                                  downloadFile(
                                      data[index].files, data[index].title);
                                })
                            : index == downloadIndex
                                ? CircularPercentIndicator(
                                    progressColor: Colors.teal,
                                    percent: double.parse(
                                        (((runningdownloadprogress /
                                                        totaldownloadprogress) *
                                                    100) /
                                                100)
                                            .toStringAsFixed(1)),
                                    animation: false,
                                    radius: 50.0,
                                    lineWidth: 6,
                                    center: Text(downloadprogress),
                                    circularStrokeCap: CircularStrokeCap.round,
                                  )
                                : IconButton(
                                    icon: Icon(Icons.file_download),
                                    onPressed: () {
                                      setState(() {
                                        downloadIndex = index;
                                      });
                                      downloadFile(
                                          data[index].files, data[index].title);
                                    })
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        child: Icon(Icons.add),
        onPressed: () => _openFileExplorer(
            widget.currentUserProjects.id, widget.currentUserData.username),
      ),
    );
  }
}
