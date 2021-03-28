import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:fproject/DashBoard/models.dart';
import 'package:fproject/gettoken.dart';

import 'models.dart';
import 'package:http/http.dart' as http;

Future<List<ProjectModel>> getCurrentUserProjects(String token) async {
  final String url = 'http://abhishekpraja.pythonanywhere.com/create/';
  final finaldata = <ProjectModel>[];
  await http.get(Uri.encodeFull(url), headers: {
    "Accept": 'application/json',
    "Authorization": 'Token ' + token,
  }).then((value) {
    if (value.statusCode == 200) {
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
            forums: forumfinal..sort((a, b) => b.id.compareTo(a.id)),
            report: reportfinal,
            activity: activityfinal,
            promem: promemfinal,
            isExpanded: false);
        finaldata.add(data);
      }
    }
  });
  return finaldata;
}

Future<ProjectModel> getCurrentProjectForum(String token, int id) async {
  final String url = 'http://abhishekpraja.pythonanywhere.com/create-all/' +
      id.toString() +
      '/';
  ProjectModel finaldata;
  await http.get(Uri.encodeFull(url), headers: {
    "Accept": 'application/json',
    "Authorization": 'Token ' + token,
  }).then((value) {
    if (value.statusCode == 200) {
      final item = json.decode(utf8.decode(value.bodyBytes));
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
          forums: forumfinal..sort((a, b) => b.id.compareTo(a.id)),
          report: reportfinal,
          activity: activityfinal,
          promem: promemfinal,
          isExpanded: false);
    }
  });
  return finaldata;
}

Future<List<ProjectModel>> getAllCurrentUserProjects(String token) async {
  final String url = 'http://abhishekpraja.pythonanywhere.com/create-all/';
  final finaldata = <ProjectModel>[];
  await http.get(Uri.encodeFull(url), headers: {
    "Accept": 'application/json',
    "Authorization": 'Token ' + token,
  }).then((value) {
    if (value.statusCode == 200) {
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
    }
  });
  return finaldata;
}

Future<ProjectModel> addTask(String token, ProjectModel currentProject,
    String text, String date, String status, String assignedTo) async {
  ProjectModel finaldata;
  await http.post(
      Uri.encodeFull('http://abhishekpraja.pythonanywhere.com/project-task/'),
      body: {
        'tasks': text,
        'status': status,
        'requested_by': currentProject.username,
        'requested_to': assignedTo,
        'due_date': date,
        'project_id': currentProject.id.toString(),
      },
      headers: {
        "Accept": 'application/json',
        "Authorization": 'Token ' + token,
      }).then((value) {
    print(value.body);
    final tasks = json.decode(utf8.decode(value.bodyBytes));
    var collection = <Task>[];

    for (var item in currentProject.task) {
      collection.add(item);
    }
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
    collection.add(data);

    finaldata = ProjectModel(
        id: currentProject.id,
        userId: currentProject.userId,
        username: currentProject.username,
        projectName: currentProject.projectName,
        mainApplication: currentProject.mainApplication,
        startDate: currentProject.startDate,
        endDate: currentProject.endDate,
        projectSize: currentProject.projectSize,
        projectDescription: currentProject.projectDescription,
        preferenece: currentProject.preferenece,
        status: currentProject.status,
        selected: currentProject.selected,
        promemCount: currentProject.promemCount,
        selectedFileCount: currentProject.selectedFileCount,
        selectedFileSize: currentProject.selectedFileCount,
        totalBugsCount: currentProject.totalBugsCount,
        successBugsCount: currentProject.successBugsCount,
        totalTaskCount: currentProject.totalTaskCount,
        successTaskCount: currentProject.successTaskCount,
        fileCount: currentProject.fileCount,
        activityCount: currentProject.activityCount,
        reportCount: currentProject.reportCount,
        successReportCount: currentProject.successReportCount,
        prochip: currentProject.prochip,
        task: collection..sort((a, b) => b.id.compareTo(a.id)),
        bugs: currentProject.bugs..sort((a, b) => b.id.compareTo(a.id)),
        fileSize: currentProject.fileSize,
        file: currentProject.file,
        forums: currentProject.forums,
        report: currentProject.report,
        activity: currentProject.activity,
        promem: currentProject.promem,
        isExpanded: false);
  }).catchError((value) => print(value));
  return finaldata;
}

Future<ProjectModel> editTask(String token, ProjectModel currentProject,
    String text, String date, String status, int id) async {
  ProjectModel finaldata;
  await http.patch(
      Uri.encodeFull(
          'http://abhishekpraja.pythonanywhere.com/project-task-owner/' +
              id.toString() +
              '/'),
      body: {
        'tasks': text,
        'status': status,
        'due_date': date,
      },
      headers: {
        "Accept": 'application/json',
        "Authorization": 'Token ' + token,
      }).then((value) {
    print(value.body);
    final tasks = json.decode(value.body);
    var collection = <Task>[];

    for (var item in currentProject.task) {
      if (item.id != id) {
        collection.add(item);
      }
    }
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
    collection.add(data);
    collection.sort((a, b) => b.id.compareTo(a.id));

    finaldata = ProjectModel(
        id: currentProject.id,
        userId: currentProject.userId,
        username: currentProject.username,
        projectName: currentProject.projectName,
        mainApplication: currentProject.mainApplication,
        startDate: currentProject.startDate,
        endDate: currentProject.endDate,
        projectSize: currentProject.projectSize,
        projectDescription: currentProject.projectDescription,
        preferenece: currentProject.preferenece,
        status: currentProject.status,
        selected: currentProject.selected,
        promemCount: currentProject.promemCount,
        selectedFileCount: currentProject.selectedFileCount,
        selectedFileSize: currentProject.selectedFileCount,
        totalBugsCount: currentProject.totalBugsCount,
        successBugsCount: currentProject.successBugsCount,
        totalTaskCount: currentProject.totalTaskCount,
        successTaskCount: currentProject.successTaskCount,
        fileCount: currentProject.fileCount,
        activityCount: currentProject.activityCount,
        reportCount: currentProject.reportCount,
        successReportCount: currentProject.successReportCount,
        prochip: currentProject.prochip,
        task: collection..sort((a, b) => b.id.compareTo(a.id)),
        bugs: currentProject.bugs..sort((a, b) => b.id.compareTo(a.id)),
        fileSize: currentProject.fileSize,
        file: currentProject.file,
        forums: currentProject.forums,
        report: currentProject.report,
        activity: currentProject.activity,
        promem: currentProject.promem,
        isExpanded: false);
  }).catchError((value) => print(value));
  return finaldata;
}

Future<ProjectModel> editTaskMember(
    String token, ProjectModel currentProject, String status, int id) async {
  ProjectModel finaldata;
  await http.patch(
      Uri.encodeFull('http://abhishekpraja.pythonanywhere.com/project-task/' +
          id.toString() +
          '/'),
      body: {
        'status': status,
      },
      headers: {
        "Accept": 'application/json',
        "Authorization": 'Token ' + token,
      }).then((value) {
    print(value.body);
    final tasks = json.decode(value.body);
    var collection = <Task>[];

    for (var item in currentProject.task) {
      if (item.id != id) {
        collection.add(item);
      }
    }
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
    collection.add(data);
    collection.sort((a, b) => b.id.compareTo(a.id));

    finaldata = ProjectModel(
        id: currentProject.id,
        userId: currentProject.userId,
        username: currentProject.username,
        projectName: currentProject.projectName,
        mainApplication: currentProject.mainApplication,
        startDate: currentProject.startDate,
        endDate: currentProject.endDate,
        projectSize: currentProject.projectSize,
        projectDescription: currentProject.projectDescription,
        preferenece: currentProject.preferenece,
        status: currentProject.status,
        selected: currentProject.selected,
        promemCount: currentProject.promemCount,
        selectedFileCount: currentProject.selectedFileCount,
        selectedFileSize: currentProject.selectedFileCount,
        totalBugsCount: currentProject.totalBugsCount,
        successBugsCount: currentProject.successBugsCount,
        totalTaskCount: currentProject.totalTaskCount,
        successTaskCount: currentProject.successTaskCount,
        fileCount: currentProject.fileCount,
        activityCount: currentProject.activityCount,
        reportCount: currentProject.reportCount,
        successReportCount: currentProject.successReportCount,
        prochip: currentProject.prochip,
        task: collection..sort((a, b) => b.id.compareTo(a.id)),
        bugs: currentProject.bugs..sort((a, b) => b.id.compareTo(a.id)),
        fileSize: currentProject.fileSize,
        file: currentProject.file,
        forums: currentProject.forums,
        report: currentProject.report,
        activity: currentProject.activity,
        promem: currentProject.promem,
        isExpanded: false);
  }).catchError((value) => print(value));
  return finaldata;
}

Future<ProjectModel> deleteTask(
    int id, String token, ProjectModel currentProject) async {
  ProjectModel finaldata;
  await http.delete(
      Uri.encodeFull(
          'http://abhishekpraja.pythonanywhere.com/project-task-owner/' +
              id.toString() +
              '/'),
      headers: {
        "Accept": 'application/json',
        "Authorization": 'Token ' + token,
      }).then((value) {
    var collection = <Task>[];

    for (var item in currentProject.task) {
      if (item.id != id) {
        collection.add(item);
      }
    }
    collection.sort((a, b) => b.id.compareTo(a.id));

    finaldata = ProjectModel(
        id: currentProject.id,
        userId: currentProject.userId,
        username: currentProject.username,
        projectName: currentProject.projectName,
        mainApplication: currentProject.mainApplication,
        startDate: currentProject.startDate,
        endDate: currentProject.endDate,
        projectSize: currentProject.projectSize,
        projectDescription: currentProject.projectDescription,
        preferenece: currentProject.preferenece,
        status: currentProject.status,
        selected: currentProject.selected,
        promemCount: currentProject.promemCount,
        selectedFileCount: currentProject.selectedFileCount,
        selectedFileSize: currentProject.selectedFileCount,
        totalBugsCount: currentProject.totalBugsCount,
        successBugsCount: currentProject.successBugsCount,
        totalTaskCount: currentProject.totalTaskCount,
        successTaskCount: currentProject.successTaskCount,
        fileCount: currentProject.fileCount,
        activityCount: currentProject.activityCount,
        reportCount: currentProject.reportCount,
        successReportCount: currentProject.successReportCount,
        prochip: currentProject.prochip,
        task: collection..sort((a, b) => b.id.compareTo(a.id)),
        bugs: currentProject.bugs..sort((a, b) => b.id.compareTo(a.id)),
        fileSize: currentProject.fileSize,
        file: currentProject.file,
        forums: currentProject.forums,
        report: currentProject.report,
        activity: currentProject.activity,
        promem: currentProject.promem,
        isExpanded: false);
  }).catchError((value) => print(value));
  return finaldata;
}

Future<ProjectModel> addBug(String token, ProjectModel currentProject,
    String text, String date, String status, String assignedTo) async {
  ProjectModel finaldata;
  await http.post(
      Uri.encodeFull('http://abhishekpraja.pythonanywhere.com/project-bugs/'),
      body: {
        'bugs': text,
        'status': status,
        'requested_by': currentProject.username,
        'requested_to': assignedTo,
        'due_date': date,
        'project_id': currentProject.id.toString(),
      },
      headers: {
        "Accept": 'application/json',
        "Authorization": 'Token ' + token,
      }).then((value) {
    print(value.body);
    final bugs = json.decode(value.body);
    var collection = <Bugs>[];

    for (var item in currentProject.bugs) {
      collection.add(item);
    }
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
    collection.add(data);

    finaldata = ProjectModel(
        id: currentProject.id,
        userId: currentProject.userId,
        username: currentProject.username,
        projectName: currentProject.projectName,
        mainApplication: currentProject.mainApplication,
        startDate: currentProject.startDate,
        endDate: currentProject.endDate,
        projectSize: currentProject.projectSize,
        projectDescription: currentProject.projectDescription,
        preferenece: currentProject.preferenece,
        status: currentProject.status,
        selected: currentProject.selected,
        promemCount: currentProject.promemCount,
        selectedFileCount: currentProject.selectedFileCount,
        selectedFileSize: currentProject.selectedFileCount,
        totalBugsCount: currentProject.totalBugsCount,
        successBugsCount: currentProject.successBugsCount,
        totalTaskCount: currentProject.totalTaskCount,
        successTaskCount: currentProject.successTaskCount,
        fileCount: currentProject.fileCount,
        activityCount: currentProject.activityCount,
        reportCount: currentProject.reportCount,
        successReportCount: currentProject.successReportCount,
        prochip: currentProject.prochip,
        task: currentProject.task..sort((a, b) => b.id.compareTo(a.id)),
        bugs: collection..sort((a, b) => b.id.compareTo(a.id)),
        fileSize: currentProject.fileSize,
        file: currentProject.file,
        forums: currentProject.forums,
        report: currentProject.report,
        activity: currentProject.activity,
        promem: currentProject.promem,
        isExpanded: false);
  }).catchError((value) => print(value));
  return finaldata;
}

Future<ProjectModel> editBug(String token, ProjectModel currentProject,
    String text, String date, String status, int id) async {
  ProjectModel finaldata;
  await http.patch(
      Uri.encodeFull(
          'http://abhishekpraja.pythonanywhere.com/project-bugs-owner/' +
              id.toString() +
              '/'),
      body: {
        'bugs': text,
        'status': status,
        'due_date': date,
      },
      headers: {
        "Accept": 'application/json',
        "Authorization": 'Token ' + token,
      }).then((value) {
    print(value.body);
    final bugs = json.decode(value.body);
    var collection = <Bugs>[];

    for (var item in currentProject.bugs) {
      if (item.id != id) {
        collection.add(item);
      }
    }
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
    collection.add(data);
    collection.sort((a, b) => b.id.compareTo(a.id));

    finaldata = ProjectModel(
        id: currentProject.id,
        userId: currentProject.userId,
        username: currentProject.username,
        projectName: currentProject.projectName,
        mainApplication: currentProject.mainApplication,
        startDate: currentProject.startDate,
        endDate: currentProject.endDate,
        projectSize: currentProject.projectSize,
        projectDescription: currentProject.projectDescription,
        preferenece: currentProject.preferenece,
        status: currentProject.status,
        selected: currentProject.selected,
        promemCount: currentProject.promemCount,
        selectedFileCount: currentProject.selectedFileCount,
        selectedFileSize: currentProject.selectedFileCount,
        totalBugsCount: currentProject.totalBugsCount,
        successBugsCount: currentProject.successBugsCount,
        totalTaskCount: currentProject.totalTaskCount,
        successTaskCount: currentProject.successTaskCount,
        fileCount: currentProject.fileCount,
        activityCount: currentProject.activityCount,
        reportCount: currentProject.reportCount,
        successReportCount: currentProject.successReportCount,
        prochip: currentProject.prochip,
        task: currentProject.task..sort((a, b) => b.id.compareTo(a.id)),
        bugs: collection..sort((a, b) => b.id.compareTo(a.id)),
        fileSize: currentProject.fileSize,
        file: currentProject.file,
        forums: currentProject.forums,
        report: currentProject.report,
        activity: currentProject.activity,
        promem: currentProject.promem,
        isExpanded: false);
  }).catchError((value) => print(value));
  return finaldata;
}

Future<ProjectModel> editBugMember(
    String token, ProjectModel currentProject, String status, int id) async {
  ProjectModel finaldata;
  await http.patch(
      Uri.encodeFull('http://abhishekpraja.pythonanywhere.com/project-bugs/' +
          id.toString() +
          '/'),
      body: {
        'status': status,
      },
      headers: {
        "Accept": 'application/json',
        "Authorization": 'Token ' + token,
      }).then((value) {
    print(value.body);
    final bugs = json.decode(value.body);
    var collection = <Bugs>[];

    for (var item in currentProject.bugs) {
      if (item.id != id) {
        collection.add(item);
      }
    }
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
    collection.add(data);
    collection.sort((a, b) => b.id.compareTo(a.id));

    finaldata = ProjectModel(
        id: currentProject.id,
        userId: currentProject.userId,
        username: currentProject.username,
        projectName: currentProject.projectName,
        mainApplication: currentProject.mainApplication,
        startDate: currentProject.startDate,
        endDate: currentProject.endDate,
        projectSize: currentProject.projectSize,
        projectDescription: currentProject.projectDescription,
        preferenece: currentProject.preferenece,
        status: currentProject.status,
        selected: currentProject.selected,
        promemCount: currentProject.promemCount,
        selectedFileCount: currentProject.selectedFileCount,
        selectedFileSize: currentProject.selectedFileCount,
        totalBugsCount: currentProject.totalBugsCount,
        successBugsCount: currentProject.successBugsCount,
        totalTaskCount: currentProject.totalTaskCount,
        successTaskCount: currentProject.successTaskCount,
        fileCount: currentProject.fileCount,
        activityCount: currentProject.activityCount,
        reportCount: currentProject.reportCount,
        successReportCount: currentProject.successReportCount,
        prochip: currentProject.prochip,
        task: currentProject.task..sort((a, b) => b.id.compareTo(a.id)),
        bugs: collection..sort((a, b) => b.id.compareTo(a.id)),
        fileSize: currentProject.fileSize,
        file: currentProject.file,
        forums: currentProject.forums,
        report: currentProject.report,
        activity: currentProject.activity,
        promem: currentProject.promem,
        isExpanded: false);
  }).catchError((value) => print(value));
  return finaldata;
}

Future<ProjectModel> sendReport(
    String token,
    String username,
    ProjectModel currentProject,
    String report,
    String comment,
    String status) async {
  ProjectModel finaldata;
  await http.post(
      Uri.encodeFull('http://abhishekpraja.pythonanywhere.com/project-report/'),
      body: {
        'report': report,
        'status': status,
        'comment': comment,
        'posted_by': username,
        'project_id': currentProject.id.toString()
      },
      headers: {
        "Accept": 'application/json',
        "Authorization": 'Token ' + token,
      }).then((value) {
    print(value.body);
    final jsonReport = json.decode(value.body);
    var collection = <Report>[];
    final reportData = Report(
        id: jsonReport['id'],
        comment: jsonReport['comment'],
        postedBy: jsonReport['posted_by'],
        projectId: jsonReport['project_id'],
        report: jsonReport['report'],
        status: jsonReport['status'],
        timestamp: jsonReport['timestamp']);
    collection.add(reportData);
    for (var item in currentProject.report) {
      collection.add(item);
    }
    collection..sort((a, b) => b.id.compareTo(a.id));

    finaldata = ProjectModel(
        id: currentProject.id,
        userId: currentProject.userId,
        username: currentProject.username,
        projectName: currentProject.projectName,
        mainApplication: currentProject.mainApplication,
        startDate: currentProject.startDate,
        endDate: currentProject.endDate,
        projectSize: currentProject.projectSize,
        projectDescription: currentProject.projectDescription,
        preferenece: currentProject.preferenece,
        status: currentProject.status,
        selected: currentProject.selected,
        promemCount: currentProject.promemCount,
        selectedFileCount: currentProject.selectedFileCount,
        selectedFileSize: currentProject.selectedFileCount,
        totalBugsCount: currentProject.totalBugsCount,
        successBugsCount: currentProject.successBugsCount,
        totalTaskCount: currentProject.totalTaskCount,
        successTaskCount: currentProject.successTaskCount,
        fileCount: currentProject.fileCount,
        activityCount: currentProject.activityCount,
        reportCount: currentProject.reportCount,
        successReportCount: currentProject.successReportCount,
        prochip: currentProject.prochip,
        task: currentProject.task..sort((a, b) => b.id.compareTo(a.id)),
        bugs: currentProject.bugs..sort((a, b) => b.id.compareTo(a.id)),
        fileSize: currentProject.fileSize,
        file: currentProject.file,
        forums: currentProject.forums,
        report: collection,
        activity: currentProject.activity,
        promem: currentProject.promem,
        isExpanded: false);
  }).catchError((value) => print(value));
  return finaldata;
}

Future<ProjectModel> deleteBug(
    int id, String token, ProjectModel currentProject) async {
  ProjectModel finaldata;
  await http.delete(
      Uri.encodeFull(
          'http://abhishekpraja.pythonanywhere.com/project-bugs-owner/' +
              id.toString() +
              '/'),
      headers: {
        "Accept": 'application/json',
        "Authorization": 'Token ' + token,
      }).then((value) {
    var collection = <Bugs>[];

    for (var item in currentProject.bugs) {
      if (item.id != id) {
        collection.add(item);
      }
    }
    collection.sort((a, b) => b.id.compareTo(a.id));

    finaldata = ProjectModel(
        id: currentProject.id,
        userId: currentProject.userId,
        username: currentProject.username,
        projectName: currentProject.projectName,
        mainApplication: currentProject.mainApplication,
        startDate: currentProject.startDate,
        endDate: currentProject.endDate,
        projectSize: currentProject.projectSize,
        projectDescription: currentProject.projectDescription,
        preferenece: currentProject.preferenece,
        status: currentProject.status,
        selected: currentProject.selected,
        promemCount: currentProject.promemCount,
        selectedFileCount: currentProject.selectedFileCount,
        selectedFileSize: currentProject.selectedFileCount,
        totalBugsCount: currentProject.totalBugsCount,
        successBugsCount: currentProject.successBugsCount,
        totalTaskCount: currentProject.totalTaskCount,
        successTaskCount: currentProject.successTaskCount,
        fileCount: currentProject.fileCount,
        activityCount: currentProject.activityCount,
        reportCount: currentProject.reportCount,
        successReportCount: currentProject.successReportCount,
        prochip: currentProject.prochip,
        task: currentProject.task..sort((a, b) => b.id.compareTo(a.id)),
        bugs: collection..sort((a, b) => b.id.compareTo(a.id)),
        fileSize: currentProject.fileSize,
        file: currentProject.file,
        forums: currentProject.forums,
        report: currentProject.report,
        activity: currentProject.activity,
        promem: currentProject.promem,
        isExpanded: false);
  }).catchError((value) => print(value));
  return finaldata;
}

Future<ProjectModel> createProject(String token, data) async {
  final String url = 'http://abhishekpraja.pythonanywhere.com/create/';
  ProjectModel finaldata;
  var prochipfinal = <Prochip>[];
  var filefinal = <File>[];
  var activityfinal = <Activity>[];
  print(token);
  var promemfinal = <Promem>[];
  await http.post(Uri.encodeFull(url), body: {
    'project_name': data['projectName'],
    'main_application': data['application'],
    'start_date': data['startDate'],
    'end_date': data['endDate'],
    'project_size': data['storage'].toString(),
    'project_description': data['description'],
    'preferenece': data['preferences'],
    'selected': 'true',
  }, headers: {
    "Accept": 'application/json',
    "Authorization": 'Token ' + token,
  }).then((value) async {
    final jsonData = jsonDecode(value.body);
    await http.post(
        Uri.encodeFull(
            'http://abhishekpraja.pythonanywhere.com/project-activity/'),
        body: {
          'activity':
              '${jsonData["username"]} has Created a Project (" ${jsonData["project_name"]}")',
          'image_type': 'create',
          'name': jsonData['username'],
          'project_id': jsonData['id'].toString()
        },
        headers: {
          "Accept": 'application/json',
          "Authorization": 'Token ' + token,
        }).then((value1) {
      final jsonActivity = jsonDecode(value1.body);
      final data = Activity(
        id: jsonActivity['id'],
        activity: jsonActivity['activity'],
        imageType: jsonActivity['image_type'],
        name: jsonActivity['name'],
        timestamp: jsonActivity['timestamp'],
        projectId: jsonActivity['project_id'],
      );
      activityfinal.add(data);
    });
    for (var item in data['tags']) {
      await http.post(
          Uri.encodeFull(
              'http://abhishekpraja.pythonanywhere.com/project-chip/'),
          body: {
            'ProjectCreatechip': jsonData['id'].toString(),
            'chips': item,
          },
          headers: {
            "Accept": 'application/json',
            "Authorization": 'Token ' + token,
          }).then((value1) {
        final jsonChip = jsonDecode(value1.body);
        final data = Prochip(
            id: jsonChip['id'],
            chips: jsonChip['chips'],
            projectCreatechip: jsonChip['projectCreatechip']);
        prochipfinal.add(data);
      });
    }

    await http.post(
        Uri.encodeFull(
            'http://abhishekpraja.pythonanywhere.com/project-member/'),
        body: {
          'member': jsonData['username'],
          'project_id': jsonData['id'].toString(),
        },
        headers: {
          "Accept": 'application/json',
          "Authorization": 'Token ' + token,
        }).then((value1) {
      final jsonPro = jsonDecode(value1.body);
      final data = Promem(
        id: jsonPro['id'],
        member: jsonPro['member'],
        selected: jsonPro['selected'] == "true" ? true : false,
        timestamp: jsonPro['timestamp'],
        projectId: jsonPro['project_id'],
      );
      promemfinal.add(data);
    });
    if (data['filename'].length > 0) {
      var dio = new Dio();
      dio.options.headers[HttpHeaders.authorizationHeader] = "Token " + token;
      FormData formData = FormData.fromMap({
        "uploaded_by": jsonData['username'],
        "files": await MultipartFile.fromFile(data['filepath'],
            filename: data['filename']),
        "title": data['filename'],
        "type": data['filename'].toString().split('.').last,
        "size": data['filelength'].toString(),
        "project_id": jsonData['id'].toString(),
      });
      await dio
          .post(
        "http://abhishekpraja.pythonanywhere.com/project-file/",
        data: formData,
      )
          .then((value1) async {
        final jsonFile = value1.data;
        final data = File(
          id: jsonFile['id'],
          files: jsonFile['files'],
          uploadedBy: jsonFile['uploaded_by'],
          title: jsonFile['title'],
          type: jsonFile['type'],
          selected: jsonFile['files'] == "true" ? true : false,
          size: jsonFile['size'],
          timestamp: jsonFile['files'],
          projectId: jsonFile['project_id'],
        );
        filefinal.add(data);
      }).catchError((error) => print(error.response.toString()));
    }

    finaldata = ProjectModel(
        id: jsonData['id'],
        userId: jsonData['user_id'],
        username: jsonData['username'],
        projectName: jsonData['project_name'],
        mainApplication: jsonData['main_application'],
        startDate: jsonData['start_date'],
        endDate: jsonData['end_date'],
        projectSize: jsonData['project_size'],
        projectDescription: jsonData['project_description'],
        preferenece: jsonData['preferenece'],
        status: jsonData['Status'],
        selected: true,
        promemCount: 1,
        selectedFileCount: 1,
        selectedFileSize: data['filelength'],
        totalBugsCount: 0,
        successBugsCount: 0,
        totalTaskCount: 0,
        successTaskCount: 0,
        fileCount: 1,
        activityCount: 1,
        reportCount: 0,
        successReportCount: 0,
        prochip: prochipfinal,
        task: [],
        bugs: [],
        fileSize: data['filelength'],
        file: filefinal,
        forums: [],
        report: [],
        activity: activityfinal,
        promem: promemfinal,
        isExpanded: false);
  }).catchError((error) => print(error.response.toString()));
  return finaldata;
}

Future<List<ProjectModel>> teamProjectList(String token) async {
  final projectList = <ProjectModel>[];
  var userLists = <String>[];
  await getUserPreferences().then((currentuser) async {
    final teamName = currentuser.teamName;
    final currentUsername = currentuser.username;
    await http.get(
        Uri.encodeFull(
            'https://abhishekpraja.pythonanywhere.com/userprofileList/?profile__teamName=$teamName'),
        headers: {
          "Accept": 'application/json',
          "Authorization": 'Token ' + token,
        }).then((users) async {
      if (users.statusCode == 200) {
        final userdata = json.decode(utf8.decode(users.bodyBytes));
        for (var item in userdata) {
          if (item['username'] != currentUsername) {
            userLists.add(item['username']);
          }
        }
        print(userLists.length);
        await http.get(
            Uri.encodeFull(
                'https://abhishekpraja.pythonanywhere.com/create-all-user/'),
            headers: {
              "Accept": 'application/json',
              "Authorization": 'Token ' + token,
            }).then((projects) async {
          if (projects.statusCode == 200) {
            final projectData = json.decode(projects.body);
            for (var item in projectData) {
              if (userLists.indexOf(item['username']) != -1 &&
                  item['preferenece'] == 'Team') {
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
                projectList.add(data);
              }
            }
          }
        });
      }
    });
  });
  return projectList;
}

Future<ProjectInvoice> postProjectInvites(
    String token, ProjectModel project, String message, String username) async {
  ProjectInvoice finaldata;
  await http.post(
      Uri.encodeFull(
          'https://abhishekpraja.pythonanywhere.com/list-project-invoice/'),
      body: {
        'requested_by': username,
        'invoice':
            '$username want to join the project name ${project.projectName}',
        'message': message,
        'project_name_to_join': project.projectName,
        'project_number': project.id.toString(),
        'user': project.userId.toString(),
      },
      headers: {
        "Accept": 'application/json',
        "Authorization": 'Token ' + token,
      }).then((value) {
    final jsonData = jsonDecode(value.body);
    finaldata = ProjectInvoice(
        id: jsonData['id'],
        requestedBy: jsonData['requested_by'],
        invoice: jsonData['invoice'],
        message: jsonData['message'],
        projectNameToJoin: jsonData['project_name_to_join'],
        projectNumber: jsonData['project_number'],
        timestamp: jsonData['timestamp'],
        user: jsonData['user']);
  });
  return finaldata;
}

Future<List<ProjectInvoice>> getAllProjectInvitesAll(String token) async {
  var finaldata = <ProjectInvoice>[];
  await http.get(
      Uri.encodeFull(
          'https://abhishekpraja.pythonanywhere.com/list-project-invoice-all/'),
      headers: {
        "Accept": 'application/json',
        "Authorization": 'Token ' + token,
      }).then((value) {
    if (value.statusCode == 200) {
      final jsonData = jsonDecode(value.body);
      for (var json in jsonData) {
        final data = ProjectInvoice(
            id: json['id'],
            requestedBy: json['requested_by'],
            invoice: json['invoice'],
            message: json['message'],
            projectNameToJoin: json['project_name_to_join'],
            projectNumber: json['project_number'],
            timestamp: json['timestamp'],
            user: json['user']);
        finaldata.add(data);
      }
    }
  });
  return finaldata;
}

Future<ProjectModel> projectDetail(String token, int id) async {
  final String url =
      'http://abhishekpraja.pythonanywhere.com/create/${id.toString()}/';
  ProjectModel finaldata;
  await http.get(Uri.encodeFull(url), headers: {
    "Accept": 'application/json',
    "Authorization": 'Token ' + token,
  }).then((value) async {
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
