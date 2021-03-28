class PostModel {
  int id;
  String user;
  String postedId;
  String img;
  String content;
  String timestamp;
  List<PostComment> postComment;
  int commentCount;

  PostModel(
      {this.id,
      this.user,
      this.postedId,
      this.img,
      this.content,
      this.timestamp,
      this.postComment,
      this.commentCount});

  PostModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    user = json['user'];
    postedId = json['posted_id'];
    img = json['img'];
    content = json['content'];
    timestamp = json['timestamp'];
    if (json['post_comment'] != null) {
      postComment = new List<PostComment>();
      json['post_comment'].forEach((v) {
        postComment.add(new PostComment.fromJson(v));
      });
    }
    commentCount = json['comment_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user'] = this.user;
    data['posted_id'] = this.postedId;
    data['img'] = this.img;
    data['content'] = this.content;
    data['timestamp'] = this.timestamp;
    if (this.postComment != null) {
      data['post_comment'] = this.postComment.map((v) => v.toJson()).toList();
    }
    data['comment_count'] = this.commentCount;
    return data;
  }
}

class PostComment {
  int id;
  String commentContent;
  String commentedBy;
  String commentTimestamp;
  int user;

  PostComment(
      {this.id,
      this.commentContent,
      this.commentedBy,
      this.commentTimestamp,
      this.user});

  PostComment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    commentContent = json['comment_content'];
    commentedBy = json['commented_by'];
    commentTimestamp = json['comment_timestamp'];
    user = json['user'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['comment_content'] = this.commentContent;
    data['commented_by'] = this.commentedBy;
    data['comment_timestamp'] = this.commentTimestamp;
    data['user'] = this.user;
    return data;
  }
}

class MessageModelDrawer {
  int id;
  String message;
  String messageBy;
  String timestamp;
  int user;

  MessageModelDrawer(
      {this.id, this.message, this.messageBy, this.timestamp, this.user});

  MessageModelDrawer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    message = json['message'];
    messageBy = json['message_by'];
    timestamp = json['timestamp'];
    user = json['user'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['message'] = this.message;
    data['message_by'] = this.messageBy;
    data['timestamp'] = this.timestamp;
    data['user'] = this.user;
    return data;
  }
}

class NotificationModelDrawer {
  int id;
  String postedBy;
  String content;
  String timestamp;
  int user;

  NotificationModelDrawer(
      {this.id, this.postedBy, this.content, this.timestamp, this.user});

  NotificationModelDrawer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    postedBy = json['posted_by'];
    content = json['content'];
    timestamp = json['timestamp'];
    user = json['user'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['posted_by'] = this.postedBy;
    data['content'] = this.content;
    data['timestamp'] = this.timestamp;
    data['user'] = this.user;
    return data;
  }
}

class InviteModelDrawer {
  int id;
  int user;
  String invoice;
  int requestedBy;

  InviteModelDrawer({this.id, this.user, this.invoice, this.requestedBy});

  InviteModelDrawer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    user = json['user'];
    invoice = json['invoice'];
    requestedBy = json['requested_by'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user'] = this.user;
    data['invoice'] = this.invoice;
    data['requested_by'] = this.requestedBy;
    return data;
  }
}

class ProjectInvoice {
  int id;
  String requestedBy;
  String invoice;
  String message;
  String projectNameToJoin;
  int projectNumber;
  String timestamp;
  int user;

  ProjectInvoice(
      {this.id,
      this.requestedBy,
      this.invoice,
      this.message,
      this.projectNameToJoin,
      this.projectNumber,
      this.timestamp,
      this.user});

  ProjectInvoice.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    requestedBy = json['requested_by'];
    invoice = json['invoice'];
    message = json['message'];
    projectNameToJoin = json['project_name_to_join'];
    projectNumber = json['project_number'];
    timestamp = json['timestamp'];
    user = json['user'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['requested_by'] = this.requestedBy;
    data['invoice'] = this.invoice;
    data['message'] = this.message;
    data['project_name_to_join'] = this.projectNameToJoin;
    data['project_number'] = this.projectNumber;
    data['timestamp'] = this.timestamp;
    data['user'] = this.user;
    return data;
  }
}
