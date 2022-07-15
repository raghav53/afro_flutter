class GroupCommentDataModel {
  String? sId;
  String? userId;
  String? groupId;
  String? groupPostId;
  String? comment;
  int? type;
  String? status;
  String? createdAt;
  String? updatedAt;
    bool? isShown = false;
  int? iV;
  User? user;
  int? totalReplies;

  GroupCommentDataModel(
      {this.sId,
      this.userId,
      this.groupId,
      this.groupPostId,
      this.comment,
      this.type,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.iV,
      this.user,
      this.totalReplies});

  GroupCommentDataModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userId = json['user_id'];
    groupId = json['group_id'];
    groupPostId = json['group_post_id'];
    comment = json['comment'];
    type = json['type'];
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
    data['group_id'] = this.groupId;
    data['group_post_id'] = this.groupPostId;
    data['comment'] = this.comment;
    data['type'] = this.type;
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
