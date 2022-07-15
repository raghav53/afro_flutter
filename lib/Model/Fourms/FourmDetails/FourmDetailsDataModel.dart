
class FourmDetailsDataModel {
  String? sId;
  UserId? userId;
  String? title;
  String? question;
  List<Media>? media;
  int? type;
  Category? category;
  String? link;
  String? country;
  String? status;
  String? createdAt;
  String? updatedAt;
  int? iV;
  int? totalReplies;
  int? totalViews;
  int? isLike;
  int? isDislike;

  FourmDetailsDataModel(
      {this.sId,
      this.userId,
      this.title,
      this.question,
      this.media,
      this.type,
      this.category,
      this.link,
      this.country,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.iV,
      this.totalReplies,
      this.totalViews,
      this.isLike,
      this.isDislike});

  FourmDetailsDataModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userId =
        json['user_id'] != null ? new UserId.fromJson(json['user_id']) : null;
    title = json['title'];
    question = json['question'];
    if (json['media'] != null) {
      media = <Media>[];
      json['media'].forEach((v) {
        media!.add(new Media.fromJson(v));
      });
    }
    type = json['type'];
    category = json['category'] != null
        ? new Category.fromJson(json['category'])
        : null;
    link = json['link'];
    country = json['country'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    totalReplies = json['total_replies'];
    totalViews = json['total_views'];
    isLike = json['is_like'];
    isDislike = json['is_dislike'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    if (this.userId != null) {
      data['user_id'] = this.userId!.toJson();
    }
    data['title'] = this.title;
    data['question'] = this.question;
    if (this.media != null) {
      data['media'] = this.media!.map((v) => v.toJson()).toList();
    }
    data['type'] = this.type;
    if (this.category != null) {
      data['category'] = this.category!.toJson();
    }
    data['link'] = this.link;
    data['country'] = this.country;
    data['status'] = this.status;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    data['total_replies'] = this.totalReplies;
    data['total_views'] = this.totalViews;
    data['is_like'] = this.isLike;
    data['is_dislike'] = this.isDislike;
    return data;
  }
}

class UserId {
  String? sId;
  String? profileImage;
  String? status;
  String? fullName;
  String? id;

  UserId({this.sId, this.profileImage, this.status, this.fullName, this.id});

  UserId.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    profileImage = json['profile_image'];
    status = json['status'];
    fullName = json['full_name'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['profile_image'] = this.profileImage;
    data['status'] = this.status;
    data['full_name'] = this.fullName;
    data['id'] = this.id;
    return data;
  }
}

class Category {
  String? sId;
  String? title;

  Category({this.sId, this.title});

  Category.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['title'] = this.title;
    return data;
  }
}

class Metadata {
  Metadata();

  Metadata.fromJson(Map<String, dynamic> json) {}

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
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
