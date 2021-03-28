class MessageModel {
  int id;
  String user;
  String teamName;
  String files;
  String message;
  String timestamp;

  MessageModel(
      {this.id,
      this.user,
      this.teamName,
      this.files,
      this.message,
      this.timestamp});

  MessageModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    user = json['user'];
    teamName = json['teamName'];
    files = json['files'];
    message = json['message'];
    timestamp = json['timestamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user'] = this.user;
    data['teamName'] = this.teamName;
    data['files'] = this.files;
    data['message'] = this.message;
    data['timestamp'] = this.timestamp;
    return data;
  }
}
