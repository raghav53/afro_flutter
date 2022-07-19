class JoinedGroupDataModel {
  String? sId;
  String? groupId;
  String? memberId;
  String? role;
  String? createdAt;
  String? updatedAt;
  int? iV;
  Group? group;

  JoinedGroupDataModel(
      {this.sId,
      this.groupId,
      this.memberId,
      this.role,
      this.createdAt,
      this.updatedAt,
      this.iV,
      this.group});

  JoinedGroupDataModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    groupId = json['group_id'];
    memberId = json['member_id'];
    role = json['role'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    group = json['group'] != null ? new Group.fromJson(json['group']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['group_id'] = this.groupId;
    data['member_id'] = this.memberId;
    data['role'] = this.role;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    if (this.group != null) {
      data['group'] = this.group!.toJson();
    }
    return data;
  }
}

class Group {
  String? sId;
  String? title;
  String? userId;
  String? category;
  String? country;
  String? state;
  String? city;
  int? privacy;
  String? about;
  String? profileImage;
  String? coverImage;
  String? status;
  String? createdAt;
  int? iV;
  int? totalMembers;

  Group(
      {this.sId,
      this.title,
      this.userId,
      this.category,
      this.country,
      this.state,
      this.city,
      this.privacy,
      this.about,
      this.profileImage,
      this.coverImage,
      this.status,
      this.createdAt,
      this.iV,
      this.totalMembers});

  Group.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    title = json['title'];
    userId = json['user_id'];
    category = json['category'];
    country = json['country'];
    state = json['state'];
    city = json['city'];
    privacy = json['privacy'];
    about = json['about'];
    profileImage = json['profile_image'];
    coverImage = json['cover_image'];
    status = json['status'];
    createdAt = json['createdAt'];
    iV = json['__v'];
    totalMembers = json['total_members'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['title'] = this.title;
    data['user_id'] = this.userId;
    data['category'] = this.category;
    data['country'] = this.country;
    data['state'] = this.state;
    data['city'] = this.city;
    data['privacy'] = this.privacy;
    data['about'] = this.about;
    data['profile_image'] = this.profileImage;
    data['cover_image'] = this.coverImage;
    data['status'] = this.status;
    data['createdAt'] = this.createdAt;
    data['__v'] = this.iV;
    data['total_members'] = this.totalMembers;
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
