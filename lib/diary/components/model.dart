class DiaryModel {
  int id;
  String user;
  String title;
  String text;
  String postedDate;

  DiaryModel({this.id, this.user, this.title, this.text, this.postedDate});

  DiaryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    user = json['user'];
    title = json['title'];
    text = json['text'];
    postedDate = json['posted_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user'] = this.user;
    data['title'] = this.title;
    data['text'] = this.text;
    data['posted_date'] = this.postedDate;
    return data;
  }
}
