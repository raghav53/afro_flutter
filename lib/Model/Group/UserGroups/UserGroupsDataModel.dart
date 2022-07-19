class UsersGroupsDataModel {
  String? sId;
  String? title;
  UserId? userId;
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
  String? updatedAt;
  int? iV;
  String? id;
  int? totalMembers;

  UsersGroupsDataModel(
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
      this.updatedAt,
      this.iV,
      this.id,
      this.totalMembers});

  UsersGroupsDataModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    title = json['title'];
    userId =
        json['user_id'] != null ? new UserId.fromJson(json['user_id']) : null;
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
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    id = json['id'];
    totalMembers = json['total_members'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['title'] = this.title;
    if (this.userId != null) {
      data['user_id'] = this.userId!.toJson();
    }
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
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    data['id'] = this.id;
    data['total_members'] = this.totalMembers;
    return data;
  }
}

class UserId {
  String? sId;
  String? profileImage;
  String? fullName;
  String? id;

  UserId({this.sId, this.profileImage, this.fullName, this.id});

  UserId.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    profileImage = json['profile_image'];
    fullName = json['full_name'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['profile_image'] = this.profileImage;
    data['full_name'] = this.fullName;
    data['id'] = this.id;
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
