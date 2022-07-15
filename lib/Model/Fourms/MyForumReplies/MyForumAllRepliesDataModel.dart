class MyAllForumRepliesDataModel {
  String? sId;
  String? userId;
  String? formId;
  String? reply;
  String? parentReplyId;
  int? type;
  String? status;
  String? createdAt;
  String? updatedAt;
  int? iV;
  Form? form;

  MyAllForumRepliesDataModel(
      {this.sId,
      this.userId,
      this.formId,
      this.reply,
      this.parentReplyId,
      this.type,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.iV,
      this.form});

  MyAllForumRepliesDataModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userId = json['user_id'];
    formId = json['form_id'];
    reply = json['reply'];
    parentReplyId = json['parent_reply_id'];
    type = json['type'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    form = json['form'] != null ? new Form.fromJson(json['form']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['user_id'] = this.userId;
    data['form_id'] = this.formId;
    data['reply'] = this.reply;
    data['parent_reply_id'] = this.parentReplyId;
    data['type'] = this.type;
    data['status'] = this.status;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    if (this.form != null) {
      data['form'] = this.form!.toJson();
    }
    return data;
  }
}

class Form {
  String? sId;
  String? userId;
  String? title;
  String? question;
  List<Media>? media;
  int? type;
  String? category;
  String? status;
  String? createdAt;
  int? iV;
  String? link;
  String? country;

  Form(
      {this.sId,
      this.userId,
      this.title,
      this.question,
      this.media,
      this.type,
      this.category,
      this.status,
      this.createdAt,
      this.iV,
      this.link,
      this.country});

  Form.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userId = json['user_id'];
    title = json['title'];
    question = json['question'];
    if (json['media'] != null) {
      media = <Media>[];
      json['media'].forEach((v) {
        media!.add(new Media.fromJson(v));
      });
    }
    type = json['type'];
    category = json['category'];
    status = json['status'];
    createdAt = json['createdAt'];
    iV = json['__v'];
    link = json['link'];
    country = json['country'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['user_id'] = this.userId;
    data['title'] = this.title;
    data['question'] = this.question;
    if (this.media != null) {
      data['media'] = this.media!.map((v) => v.toJson()).toList();
    }
    data['type'] = this.type;
    data['category'] = this.category;
    data['status'] = this.status;
    data['createdAt'] = this.createdAt;
    data['__v'] = this.iV;
    data['link'] = this.link;
    data['country'] = this.country;
    return data;
  }
}

class Metadata {
  int? limit;
  int? currentPage;
  int? totalDocs;
  double? totalPages;

  Metadata({this.limit, this.currentPage, this.totalDocs, this.totalPages});

  Metadata.fromJson(Map<String, dynamic> json) {
    limit = json['limit'];
    currentPage = json['currentPage'];
    totalDocs = json['totalDocs'];
    totalPages = json['totalPages'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['limit'] = this.limit;
    data['currentPage'] = this.currentPage;
    data['totalDocs'] = this.totalDocs;
    data['totalPages'] = this.totalPages;
    return data;
  }
}

class Media {
  String? path;
  String? type;
  String? sId;

  Media({this.path, this.type, this.sId});

  Media.fromJson(Map<String, dynamic> json) {
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
