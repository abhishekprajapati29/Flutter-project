import 'dart:convert';

import 'package:fproject/Album/components/model.dart';
import 'package:fproject/File/components/model.dart';
import 'package:fproject/Video/components/model.dart';
import 'package:fproject/gettoken.dart';
import 'package:fproject/project/components/models.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<List<AlbumModel>> getUserAlbum(String token) async {
  var finaldata = <AlbumModel>[];
  await http.get(
      Uri.encodeFull("http://abhishekpraja.pythonanywhere.com/imagesall/"),
      headers: {
        "Accept": 'application/json',
        "Authorization": 'Token ' + token,
      }).then((value) {
    final jsonData = json.decode(value.body);
    for (var item in jsonData) {
      final data = AlbumModel(
        id: item['id'],
        user: item['user'],
        title: item['title'],
        timestamp: item['timestamp'],
        image: item['image'],
        imagelist: [],
        favourite: item['favourite'],
        imagelistsize: item['imagelistsize'],
        selected: item['selected'],
      );
      finaldata.add(data);
    }
  }).catchError((error) => print(error.response.toString()));
  return finaldata;
}

Future<AlbumModel> patchSelectedAlbum(
    String token, bool selected, int id) async {
  AlbumModel finaldata;
  await http.patch(
      Uri.encodeFull("http://abhishekpraja.pythonanywhere.com/imagesall/" +
          id.toString() +
          "/"),
      body: {
        'selected': selected == true ? 'true' : 'false'
      },
      headers: {
        "Accept": 'application/json',
        "Authorization": 'Token ' + token,
      }).then((value) {
    final jsonData = json.decode(value.body);
    finaldata = AlbumModel(
      id: jsonData['id'],
      user: jsonData['user'],
      title: jsonData['title'],
      timestamp: jsonData['timestamp'],
      image: jsonData['image'],
      imagelist: [],
      favourite: jsonData['favourite'],
      imagelistsize: jsonData['imagelistsize'],
      selected: jsonData['selected'],
    );
  }).catchError((error) => print(error.response.toString()));
  return finaldata;
}

Future<List<VideoModel>> getUserVideo(String token) async {
  var finaldata = <VideoModel>[];
  await http.get(
      Uri.encodeFull("https://abhishekpraja.pythonanywhere.com/videoall/"),
      headers: {
        "Accept": 'application/json',
        "Authorization": 'Token ' + token,
      }).then((value) {
    final jsonData = json.decode(value.body);
    for (var item in jsonData) {
      final data = VideoModel(
          id: item['id'],
          user: item['user'],
          title: item['title'],
          video: item['Video'],
          type: item['type'],
          size: item['size'],
          selected: item['selected'],
          timestamp: item['timestamp'],
          favourite: item['favourite']);
      finaldata.add(data);
    }
  }).catchError((error) => print(error.response.toString()));
  return finaldata;
}

Future<VideoModel> patchSelectedVideo(
    String token, bool selected, int id) async {
  VideoModel finaldata;
  await http.patch(
      Uri.encodeFull("https://abhishekpraja.pythonanywhere.com/videoall/" +
          id.toString() +
          "/"),
      body: {
        'selected': selected == true ? 'true' : 'false'
      },
      headers: {
        "Accept": 'application/json',
        "Authorization": 'Token ' + token,
      }).then((value) {
    final jsonData = json.decode(value.body);
    finaldata = VideoModel(
        id: jsonData['id'],
        user: jsonData['user'],
        title: jsonData['title'],
        video: jsonData['Video'],
        type: jsonData['type'],
        size: jsonData['size'],
        selected: jsonData['selected'],
        timestamp: jsonData['timestamp'],
        favourite: jsonData['favourite']);
  }).catchError((error) => print(error.response.toString()));
  return finaldata;
}

Future<List<FileModel>> getUserFile(String token) async {
  var finaldata = <FileModel>[];
  await http.get(
      Uri.encodeFull("https://abhishekpraja.pythonanywhere.com/fileall/"),
      headers: {
        "Accept": 'application/json',
        "Authorization": 'Token ' + token,
      }).then((value) {
    final jsonData = json.decode(value.body);
    for (var item in jsonData) {
      final data = FileModel(
          id: item['id'],
          user: item['user'],
          title: item['title'],
          file: item['file'],
          type: item['type'],
          size: item['size'],
          selected: item['selected'],
          timestamp: item['timestamp'],
          favourite: item['favourite']);
      finaldata.add(data);
    }
  }).catchError((error) => print(error.response.toString()));
  return finaldata;
}

Future<FileModel> patchSelectedFile(String token, bool selected, int id) async {
  FileModel finaldata;
  await http.patch(
      Uri.encodeFull("https://abhishekpraja.pythonanywhere.com/fileall/" +
          id.toString() +
          "/"),
      body: {
        'selected': selected == true ? 'true' : 'false'
      },
      headers: {
        "Accept": 'application/json',
        "Authorization": 'Token ' + token,
      }).then((value) {
    final jsonData = json.decode(value.body);
    finaldata = FileModel(
        id: jsonData['id'],
        user: jsonData['user'],
        title: jsonData['title'],
        file: jsonData['file'],
        type: jsonData['type'],
        size: jsonData['size'],
        selected: jsonData['selected'],
        timestamp: jsonData['timestamp'],
        favourite: jsonData['favourite']);
  }).catchError((error) => print(error.response.toString()));
  return finaldata;
}

Future<List<ProjectModel>> getUserProject(String token) async {
  var finaldata = <ProjectModel>[];
  await http.get(
      Uri.encodeFull("https://abhishekpraja.pythonanywhere.com/create-all/"),
      headers: {
        "Accept": 'application/json',
        "Authorization": 'Token ' + token,
      }).then((value) {
    final jsonData = jsonDecode(utf8.decode(value.bodyBytes));
    for (var item in jsonData) {
      var prochipfinal = <Prochip>[];
      var taskfinal = <Task>[];
      var bugfinal = <Bugs>[];
      var filefinal = <File>[];
      var forumfinal = <Forums>[];
      var reportfinal = <Report>[];
      var activityfinal = <Activity>[];
      var promemfinal = <Promem>[];
      for (var pro in item['prochip']) {
        final data = Prochip(
            id: pro['id'],
            chips: pro['chips'],
            projectCreatechip: pro['projectCreatechip']);
        prochipfinal.add(data);
      }
      for (var tasks in item['task']) {
        final data = Task(
          id: tasks['id'],
          tasks: tasks['tasks'],
          status: tasks['status'],
          requestedBy: tasks['requested_by'],
          requestedTo: tasks['requested_to'],
          dueDate: tasks['due_date'],
          timestamp: tasks['timestamp'],
          projectId: tasks['project_id'],
        );
        taskfinal.add(data);
      }
      for (var bugs in item['bugs']) {
        final data = Bugs(
          id: bugs['id'],
          bugs: bugs['bugs'],
          status: bugs['status'],
          requestedBy: bugs['requested_by'],
          requestedTo: bugs['requested_to'],
          dueDate: bugs['due_date'],
          timestamp: bugs['timestamp'],
          projectId: bugs['project_id'],
        );
        bugfinal.add(data);
      }
      for (var file in item['file']) {
        final data = File(
          id: file['id'],
          files: file['files'],
          uploadedBy: file['uploaded_by'],
          title: file['title'],
          type: file['type'],
          selected: file['selected'],
          size: file['size'],
          timestamp: file['timestamp'],
          projectId: file['project_id'],
        );
        filefinal.add(data);
      }
      for (var forum in item['forums']) {
        final data = Forums(
            id: forum['id'],
            content: forum['content'],
            files: forum['files'],
            projectId: forum['project_id'],
            requestedBy: forum['requested_by'],
            timestamp: forum['timestamp']);
        forumfinal.add(data);
      }
      for (var report in item['report']) {
        final data = Report(
          id: report['id'],
          report: report['report'],
          postedBy: report['posted_by'],
          comment: report['comment'],
          status: report['status'],
          timestamp: report['timestamp'],
          projectId: report['project_id'],
        );
        reportfinal.add(data);
      }
      for (var activity in item['activity']) {
        final data = Activity(
          id: activity['id'],
          activity: activity['activity'],
          imageType: activity['image_type'],
          name: activity['name'],
          timestamp: activity['timestamp'],
          projectId: activity['project_id'],
        );
        activityfinal.add(data);
      }
      for (var mem in item['promem']) {
        final data = Promem(
          id: mem['id'],
          member: mem['member'],
          selected: mem['selected'],
          timestamp: mem['timestamp'],
          projectId: mem['project_id'],
        );
        promemfinal.add(data);
      }
      final data = ProjectModel(
          id: item['id'],
          userId: item['user_id'],
          username: item['username'],
          projectName: item['project_name'],
          mainApplication: item['main_application'],
          startDate: item['start_date'],
          endDate: item['end_date'],
          projectSize: item['project_size'],
          projectDescription: item['project_description'],
          preferenece: item['preferenece'],
          status: item['Status'],
          selected: item['selected'],
          promemCount: item['promem_count'],
          selectedFileCount: item['selected_file_count'],
          selectedFileSize: item['selected_file_size'],
          totalBugsCount: item['total_bugs_count'],
          successBugsCount: item['success_bugs_count'],
          totalTaskCount: item['total_task_count'],
          successTaskCount: item['success_task_count'],
          fileCount: item['file_count'],
          activityCount: item['activity_count'],
          reportCount: item['report_count'],
          successReportCount: item['success_report_count'],
          prochip: prochipfinal,
          task: taskfinal..sort((a, b) => b.id.compareTo(a.id)),
          bugs: bugfinal..sort((a, b) => b.id.compareTo(a.id)),
          fileSize: item['file_size'],
          file: filefinal,
          forums: forumfinal,
          report: reportfinal,
          activity: activityfinal,
          promem: promemfinal,
          isExpanded: false);
      finaldata.add(data);
    }
  }).catchError((error) => print(error.response.toString()));
  return finaldata;
}

Future<ProjectModel> patchSelectedProject(
    String token, bool selected, int id) async {
  ProjectModel finaldata;
  await http.patch(
      Uri.encodeFull("https://abhishekpraja.pythonanywhere.com/create-all/" +
          id.toString() +
          "/"),
      body: {
        'selected': selected == true ? 'true' : 'false'
      },
      headers: {
        "Accept": 'application/json',
        "Authorization": 'Token ' + token,
      }).then((value) {
    final item = jsonDecode(utf8.decode(value.bodyBytes));
    var prochipfinal = <Prochip>[];
    var taskfinal = <Task>[];
    var bugfinal = <Bugs>[];
    var filefinal = <File>[];
    var forumfinal = <Forums>[];
    var reportfinal = <Report>[];
    var activityfinal = <Activity>[];
    var promemfinal = <Promem>[];
    for (var pro in item['prochip']) {
      final data = Prochip(
          id: pro['id'],
          chips: pro['chips'],
          projectCreatechip: pro['projectCreatechip']);
      prochipfinal.add(data);
    }
    for (var tasks in item['task']) {
      final data = Task(
        id: tasks['id'],
        tasks: tasks['tasks'],
        status: tasks['status'],
        requestedBy: tasks['requested_by'],
        requestedTo: tasks['requested_to'],
        dueDate: tasks['due_date'],
        timestamp: tasks['timestamp'],
        projectId: tasks['project_id'],
      );
      taskfinal.add(data);
    }
    for (var bugs in item['bugs']) {
      final data = Bugs(
        id: bugs['id'],
        bugs: bugs['bugs'],
        status: bugs['status'],
        requestedBy: bugs['requested_by'],
        requestedTo: bugs['requested_to'],
        dueDate: bugs['due_date'],
        timestamp: bugs['timestamp'],
        projectId: bugs['project_id'],
      );
      bugfinal.add(data);
    }
    for (var file in item['file']) {
      final data = File(
        id: file['id'],
        files: file['files'],
        uploadedBy: file['uploaded_by'],
        title: file['title'],
        type: file['type'],
        selected: file['selected'],
        size: file['size'],
        timestamp: file['timestamp'],
        projectId: file['project_id'],
      );
      filefinal.add(data);
    }
    for (var forum in item['forums']) {
      final data = Forums(
          id: forum['id'],
          content: forum['content'],
          files: forum['files'],
          projectId: forum['project_id'],
          requestedBy: forum['requested_by'],
          timestamp: forum['timestamp']);
      forumfinal.add(data);
    }
    for (var report in item['report']) {
      final data = Report(
        id: report['id'],
        report: report['report'],
        postedBy: report['posted_by'],
        comment: report['comment'],
        status: report['status'],
        timestamp: report['timestamp'],
        projectId: report['project_id'],
      );
      reportfinal.add(data);
    }
    for (var activity in item['activity']) {
      final data = Activity(
        id: activity['id'],
        activity: activity['activity'],
        imageType: activity['image_type'],
        name: activity['name'],
        timestamp: activity['timestamp'],
        projectId: activity['project_id'],
      );
      activityfinal.add(data);
    }
    for (var mem in item['promem']) {
      final data = Promem(
        id: mem['id'],
        member: mem['member'],
        selected: mem['selected'],
        timestamp: mem['timestamp'],
        projectId: mem['project_id'],
      );
      promemfinal.add(data);
    }
    finaldata = ProjectModel(
        id: item['id'],
        userId: item['user_id'],
        username: item['username'],
        projectName: item['project_name'],
        mainApplication: item['main_application'],
        startDate: item['start_date'],
        endDate: item['end_date'],
        projectSize: item['project_size'],
        projectDescription: item['project_description'],
        preferenece: item['preferenece'],
        status: item['Status'],
        selected: item['selected'],
        promemCount: item['promem_count'],
        selectedFileCount: item['selected_file_count'],
        selectedFileSize: item['selected_file_size'],
        totalBugsCount: item['total_bugs_count'],
        successBugsCount: item['success_bugs_count'],
        totalTaskCount: item['total_task_count'],
        successTaskCount: item['success_task_count'],
        fileCount: item['file_count'],
        activityCount: item['activity_count'],
        reportCount: item['report_count'],
        successReportCount: item['success_report_count'],
        prochip: prochipfinal,
        task: taskfinal..sort((a, b) => b.id.compareTo(a.id)),
        bugs: bugfinal..sort((a, b) => b.id.compareTo(a.id)),
        fileSize: item['file_size'],
        file: filefinal,
        forums: forumfinal,
        report: reportfinal,
        activity: activityfinal,
        promem: promemfinal,
        isExpanded: false);
  }).catchError((error) => print(error.response.toString()));
  return finaldata;
}

Future<void> handleSubmitFinal(String token) async {
  await getUserPreferences().then((value) async {
    await http.patch(
        Uri.encodeFull(
            'https://abhishekpraja.pythonanywhere.com/userprofile/${value.id.toString()}/'),
        body: {
          'selected': 'false'
        },
        headers: {
          "Accept": 'application/json',
          "Authorization": 'Token ' + token,
        }).then((value) async {
      final jsonData = jsonDecode(value.body);
      SharedPreferences pref = await SharedPreferences.getInstance();
      pref.setBool('selected', jsonData['selected']);
    });
  });
}
