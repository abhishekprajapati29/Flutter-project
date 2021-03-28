class ProjectModel {
  int id;
  String userId;
  String username;
  String projectName;
  String mainApplication;
  String startDate;
  String endDate;
  int projectSize;
  String projectDescription;
  String preferenece;
  String status;
  bool selected;
  int selectedFileCount;
  int selectedFileSize;
  int promemCount;
  int totalTaskCount;
  int successTaskCount;
  int totalBugsCount;
  int successBugsCount;
  int fileCount;
  int activityCount;
  int reportCount;
  int successReportCount;
  List<Prochip> prochip;
  List<Task> task;
  List<Bugs> bugs;
  int fileSize;
  List<File> file;
  List<Forums> forums;
  List<Report> report;
  List<Activity> activity;
  List<Promem> promem;
  bool isExpanded = false;

  ProjectModel(
      {this.id,
      this.userId,
      this.username,
      this.projectName,
      this.mainApplication,
      this.startDate,
      this.endDate,
      this.projectSize,
      this.projectDescription,
      this.preferenece,
      this.status,
      this.selected,
      this.selectedFileCount,
      this.selectedFileSize,
      this.promemCount,
      this.totalTaskCount,
      this.successTaskCount,
      this.totalBugsCount,
      this.successBugsCount,
      this.fileCount,
      this.activityCount,
      this.reportCount,
      this.successReportCount,
      this.prochip,
      this.task,
      this.bugs,
      this.fileSize,
      this.file,
      this.forums,
      this.report,
      this.activity,
      this.promem,
      this.isExpanded});

  ProjectModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    username = json['username'];
    projectName = json['project_name'];
    mainApplication = json['main_application'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    projectSize = json['project_size'];
    projectDescription = json['project_description'];
    preferenece = json['preferenece'];
    status = json['Status'];
    selected = json['selected'];
    selectedFileCount = json['selected_file_count'];
    selectedFileSize = json['selected_file_size'];
    promemCount = json['promem_count'];
    totalTaskCount = json['total_task_count'];
    successTaskCount = json['success_task_count'];
    totalBugsCount = json['total_bugs_count'];
    successBugsCount = json['success_bugs_count'];
    fileCount = json['file_count'];
    activityCount = json['activity_count'];
    reportCount = json['report_count'];
    successReportCount = json['success_report_count'];
    if (json['prochip'] != null) {
      prochip = new List<Prochip>();
      json['prochip'].forEach((v) {
        prochip.add(new Prochip.fromJson(v));
      });
    }
    if (json['task'] != null) {
      task = new List<Task>();
      json['task'].forEach((v) {
        task.add(new Task.fromJson(v));
      });
    }
    if (json['bugs'] != null) {
      bugs = new List<Bugs>();
      json['bugs'].forEach((v) {
        bugs.add(new Bugs.fromJson(v));
      });
    }
    fileSize = json['file_size'];
    if (json['file'] != null) {
      file = new List<File>();
      json['file'].forEach((v) {
        file.add(new File.fromJson(v));
      });
    }
    if (json['forums'] != null) {
      forums = new List<Forums>();
      json['forums'].forEach((v) {
        forums.add(new Forums.fromJson(v));
      });
    }
    if (json['report'] != null) {
      report = new List<Report>();
      json['report'].forEach((v) {
        report.add(new Report.fromJson(v));
      });
    }
    if (json['activity'] != null) {
      activity = new List<Activity>();
      json['activity'].forEach((v) {
        activity.add(new Activity.fromJson(v));
      });
    }
    if (json['promem'] != null) {
      promem = new List<Promem>();
      json['promem'].forEach((v) {
        promem.add(new Promem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['username'] = this.username;
    data['project_name'] = this.projectName;
    data['main_application'] = this.mainApplication;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['project_size'] = this.projectSize;
    data['project_description'] = this.projectDescription;
    data['preferenece'] = this.preferenece;
    data['Status'] = this.status;
    data['selected'] = this.selected;
    data['selected_file_count'] = this.selectedFileCount;
    data['selected_file_size'] = this.selectedFileSize;
    data['promem_count'] = this.promemCount;
    data['total_task_count'] = this.totalTaskCount;
    data['success_task_count'] = this.successTaskCount;
    data['total_bugs_count'] = this.totalBugsCount;
    data['success_bugs_count'] = this.successBugsCount;
    data['file_count'] = this.fileCount;
    data['activity_count'] = this.activityCount;
    data['report_count'] = this.reportCount;
    data['success_report_count'] = this.successReportCount;
    if (this.prochip != null) {
      data['prochip'] = this.prochip.map((v) => v.toJson()).toList();
    }
    if (this.task != null) {
      data['task'] = this.task.map((v) => v.toJson()).toList();
    }
    if (this.bugs != null) {
      data['bugs'] = this.bugs.map((v) => v.toJson()).toList();
    }
    data['file_size'] = this.fileSize;
    if (this.file != null) {
      data['file'] = this.file.map((v) => v.toJson()).toList();
    }
    if (this.forums != null) {
      data['forums'] = this.forums.map((v) => v.toJson()).toList();
    }
    if (this.report != null) {
      data['report'] = this.report.map((v) => v.toJson()).toList();
    }
    if (this.activity != null) {
      data['activity'] = this.activity.map((v) => v.toJson()).toList();
    }
    if (this.promem != null) {
      data['promem'] = this.promem.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Prochip {
  int id;
  String chips;
  int projectCreatechip;

  Prochip({this.id, this.chips, this.projectCreatechip});

  Prochip.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    chips = json['chips'];
    projectCreatechip = json['ProjectCreatechip'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['chips'] = this.chips;
    data['ProjectCreatechip'] = this.projectCreatechip;
    return data;
  }
}

class Task {
  int id;
  String tasks;
  String status;
  String requestedBy;
  String requestedTo;
  String dueDate;
  String timestamp;
  int projectId;

  Task(
      {this.id,
      this.tasks,
      this.status,
      this.requestedBy,
      this.requestedTo,
      this.dueDate,
      this.timestamp,
      this.projectId});

  Task.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    tasks = json['tasks'];
    status = json['status'];
    requestedBy = json['requested_by'];
    requestedTo = json['requested_to'];
    dueDate = json['due_date'];
    timestamp = json['timestamp'];
    projectId = json['project_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['tasks'] = this.tasks;
    data['status'] = this.status;
    data['requested_by'] = this.requestedBy;
    data['requested_to'] = this.requestedTo;
    data['due_date'] = this.dueDate;
    data['timestamp'] = this.timestamp;
    data['project_id'] = this.projectId;
    return data;
  }
}

class Bugs {
  int id;
  String bugs;
  String status;
  String requestedBy;
  String requestedTo;
  String dueDate;
  String timestamp;
  int projectId;

  Bugs(
      {this.id,
      this.bugs,
      this.status,
      this.requestedBy,
      this.requestedTo,
      this.dueDate,
      this.timestamp,
      this.projectId});

  Bugs.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    bugs = json['bugs'];
    status = json['status'];
    requestedBy = json['requested_by'];
    requestedTo = json['requested_to'];
    dueDate = json['due_date'];
    timestamp = json['timestamp'];
    projectId = json['project_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['bugs'] = this.bugs;
    data['status'] = this.status;
    data['requested_by'] = this.requestedBy;
    data['requested_to'] = this.requestedTo;
    data['due_date'] = this.dueDate;
    data['timestamp'] = this.timestamp;
    data['project_id'] = this.projectId;
    return data;
  }
}

class File {
  int id;
  String files;
  String uploadedBy;
  String title;
  String type;
  bool selected;
  int size;
  String timestamp;
  int projectId;

  File(
      {this.id,
      this.files,
      this.uploadedBy,
      this.title,
      this.type,
      this.selected,
      this.size,
      this.timestamp,
      this.projectId});

  File.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    files = json['files'];
    uploadedBy = json['uploaded_by'];
    title = json['title'];
    type = json['type'];
    selected = json['selected'];
    size = json['size'];
    timestamp = json['timestamp'];
    projectId = json['project_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['files'] = this.files;
    data['uploaded_by'] = this.uploadedBy;
    data['title'] = this.title;
    data['type'] = this.type;
    data['selected'] = this.selected;
    data['size'] = this.size;
    data['timestamp'] = this.timestamp;
    data['project_id'] = this.projectId;
    return data;
  }
}

class Forums {
  int id;
  String files;
  String content;
  String requestedBy;
  String timestamp;
  int projectId;

  Forums(
      {this.id,
      this.files,
      this.content,
      this.requestedBy,
      this.timestamp,
      this.projectId});

  Forums.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    files = json['files'];
    content = json['content'];
    requestedBy = json['requested_by'];
    timestamp = json['timestamp'];
    projectId = json['project_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['files'] = this.files;
    data['content'] = this.content;
    data['requested_by'] = this.requestedBy;
    data['timestamp'] = this.timestamp;
    data['project_id'] = this.projectId;
    return data;
  }
}

class Report {
  int id;
  String report;
  String postedBy;
  String comment;
  String status;
  String timestamp;
  int projectId;

  Report(
      {this.id,
      this.report,
      this.postedBy,
      this.comment,
      this.status,
      this.timestamp,
      this.projectId});

  Report.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    report = json['report'];
    postedBy = json['posted_by'];
    comment = json['comment'];
    status = json['status'];
    timestamp = json['timestamp'];
    projectId = json['project_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['report'] = this.report;
    data['posted_by'] = this.postedBy;
    data['comment'] = this.comment;
    data['status'] = this.status;
    data['timestamp'] = this.timestamp;
    data['project_id'] = this.projectId;
    return data;
  }
}

class Activity {
  int id;
  String activity;
  String imageType;
  String name;
  String timestamp;
  int projectId;

  Activity(
      {this.id,
      this.activity,
      this.imageType,
      this.name,
      this.timestamp,
      this.projectId});

  Activity.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    activity = json['activity'];
    imageType = json['image_type'];
    name = json['name'];
    timestamp = json['timestamp'];
    projectId = json['project_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['activity'] = this.activity;
    data['image_type'] = this.imageType;
    data['name'] = this.name;
    data['timestamp'] = this.timestamp;
    data['project_id'] = this.projectId;
    return data;
  }
}

class Promem {
  int id;
  String member;
  bool selected;
  String timestamp;
  int projectId;

  Promem({this.id, this.member, this.selected, this.timestamp, this.projectId});

  Promem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    member = json['member'];
    selected = json['selected'];
    timestamp = json['timestamp'];
    projectId = json['project_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['member'] = this.member;
    data['selected'] = this.selected;
    data['timestamp'] = this.timestamp;
    data['project_id'] = this.projectId;
    return data;
  }
}
