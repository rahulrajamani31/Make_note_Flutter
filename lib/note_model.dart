class NoteModel {
  NoteModel({
    required this.body,
  });
  late final List<Body> body;
  
  NoteModel.fromJson(Map<String, dynamic> json){
    body = List.from(json['body']).map((e)=>Body.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['body'] = body.map((e)=>e.toJson()).toList();
    return _data;
  }

  map(NoteModel Function(dynamic item) param0) {}
}

class Body {
  Body({
    required this.title,
    required this.des,
    required this.date,
    required this.time,
    required this.unique,
  });
  late final String title;
  late final String des;
  late final String date;
  late final String time;
  late final String unique;
  
  Body.fromJson(Map<String, dynamic> json){
    title = json['title'];
    des = json['des'];
    date = json['date'];
    time = json['time'];
    unique = json['unique'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['title'] = title;
    _data['des'] = des;
    _data['date'] = date;
    _data['time'] = time;
    _data['unique'] = unique;
    return _data;
  }
}