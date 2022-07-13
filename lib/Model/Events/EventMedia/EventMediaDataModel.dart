class EventMediaDataModel {
  String? sId;
  String? eventId;
  String? userId;
  String? postId;
  String? path;
  String? type;
  String? status;
  String? createdAt;
  String? updatedAt;
  int? iV;

  EventMediaDataModel(
      {this.sId,
      this.eventId,
      this.userId,
      this.postId,
      this.path,
      this.type,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.iV});

  EventMediaDataModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    eventId = json['event_id'];
    userId = json['user_id'];
    postId = json['post_id'];
    path = json['path'];
    type = json['type'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['event_id'] = this.eventId;
    data['user_id'] = this.userId;
    data['post_id'] = this.postId;
    data['path'] = this.path;
    data['type'] = this.type;
    data['status'] = this.status;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}

class Metadata {
  int? totalDocs;
  int? limit;
  int? currentPage;
  var totalPages;

  Metadata({this.totalDocs, this.limit, this.currentPage, this.totalPages});

  Metadata.fromJson(Map<String, dynamic> json) {
    totalDocs = json['totalDocs'];
    limit = json['limit'];
    currentPage = json['currentPage'];
    totalPages = json['totalPages'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['totalDocs'] = this.totalDocs;
    data['limit'] = this.limit;
    data['currentPage'] = this.currentPage;
    data['totalPages'] = this.totalPages;
    return data;
  }
}
