class Item {
  int id;
  String user;
  List<Todochip> todochip;
  String title;
  String description;
  bool completed;
  String timestamp;
  bool isExpanded = false;

  Item({
    this.id,
    this.user,
    this.todochip,
    this.title,
    this.description,
    this.completed,
    this.timestamp,
    this.isExpanded,
  });

  Item.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    user = json['user'];
    if (json['todochip'] != null) {
      todochip = new List<Todochip>();
      json['todochip'].forEach((v) {
        todochip.add(new Todochip.fromJson(v));
      });
    }
    title = json['title'];
    description = json['description'];
    completed = json['completed'];
    timestamp = json['timestamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user'] = this.user;
    if (this.todochip != null) {
      data['todochip'] = this.todochip.map((v) => v.toJson()).toList();
    }
    data['title'] = this.title;
    data['description'] = this.description;
    data['completed'] = this.completed;
    data['timestamp'] = this.timestamp;
    return data;
  }
}

class Todochip {
  int id;
  String chips;
  int todochip;

  Todochip({this.id, this.chips, this.todochip});

  Todochip.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    chips = json['chips'];
    todochip = json['todochip'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['chips'] = this.chips;
    data['todochip'] = this.todochip;
    return data;
  }
}
