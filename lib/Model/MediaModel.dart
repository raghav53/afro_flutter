class MediaModel {
  String? path; 
  String? type;
  String? sId;

  MediaModel({this.path, this.type, this.sId});

  MediaModel.fromJson(Map<String, dynamic> json) {
    path = json['path'];
    type = json['type'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['path'] = this.path;
    data['type'] = this.type;
    data['_id'] = this.sId;
    return data;
  }
}
