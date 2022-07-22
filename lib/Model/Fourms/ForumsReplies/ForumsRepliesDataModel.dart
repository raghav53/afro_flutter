class ForumsRepliesDataModel {
  String? sId;
  String? userId;
  String? formId;
  String? reply;
  int? type;
  String? status;
  String? createdAt;
  String? parentReplyId;
  bool? parentRepliesShow = false;
  String? updatedAt;
  int? iV;
  User? user;
  int? totalReplies;

  ForumsRepliesDataModel(
      {this.sId,
      this.userId,
      this.formId,
      this.reply,
      this.type,
      this.status,
      this.parentReplyId,
      this.createdAt,
      this.updatedAt,
      this.iV,
      this.user,
      this.totalReplies});

  ForumsRepliesDataModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userId = json['user_id'];
    formId = json['form_id'];
    reply = json['reply'];
    type = json['type'];
    parentReplyId = json['parent_reply_id'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    totalReplies = json['total_replies'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['user_id'] = this.userId;
    data['form_id'] = this.formId;
    data['reply'] = this.reply;
    data['type'] = this.type;
    data['parent_reply_id'] = this.parentReplyId;
    data['status'] = this.status;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    data['total_replies'] = this.totalReplies;
    return data;
  }
}

class User {
  String? sId;
  String? profileImage;
  String? status;
  String? fullName;

  User({this.sId, this.profileImage, this.status, this.fullName});

  User.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    profileImage = json['profile_image'];
    status = json['status'];
    fullName = json['full_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['profile_image'] = this.profileImage;
    data['status'] = this.status;
    data['full_name'] = this.fullName;
    return data;
  }
}

class Metadata {
  int? limit;
  int? currentPage;
  int? totalDocs;
  var totalPages;

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
