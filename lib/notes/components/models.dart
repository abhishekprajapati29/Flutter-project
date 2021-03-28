class NotesItem {
  int id;
  String user;
  List<Notechip> notechip;
  String noteTitle;
  String noteContent;
  String timestamp;

  NotesItem(
      {this.id,
      this.user,
      this.notechip,
      this.noteTitle,
      this.noteContent,
      this.timestamp});

  NotesItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    user = json['user'];
    if (json['notechip'] != null) {
      notechip = new List<Notechip>();
      json['notechip'].forEach((v) {
        notechip.add(new Notechip.fromJson(v));
      });
    }
    noteTitle = json['note_title'];
    noteContent = json['note_content'];
    timestamp = json['timestamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user'] = this.user;
    if (this.notechip != null) {
      data['notechip'] = this.notechip.map((v) => v.toJson()).toList();
    }
    data['note_title'] = this.noteTitle;
    data['note_content'] = this.noteContent;
    data['timestamp'] = this.timestamp;
    return data;
  }
}

class Notechip {
  int id;
  String noteChips;
  int notechip;

  Notechip({this.id, this.noteChips, this.notechip});

  Notechip.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    noteChips = json['note_chips'];
    notechip = json['notechip'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['note_chips'] = this.noteChips;
    data['notechip'] = this.notechip;
    return data;
  }
}
