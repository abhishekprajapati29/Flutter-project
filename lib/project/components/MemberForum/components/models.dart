class MessageModel {
  int id;
  String user;
  String teamName;
  String message;
  String timestamp;

  MessageModel(
      {this.id, this.user, this.teamName, this.message, this.timestamp});

  MessageModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    user = json['user'];
    teamName = json['teamName'];
    message = json['message'];
    timestamp = json['timestamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user'] = this.user;
    data['teamName'] = this.teamName;
    data['message'] = this.message;
    data['timestamp'] = this.timestamp;
    return data;
  }
}
