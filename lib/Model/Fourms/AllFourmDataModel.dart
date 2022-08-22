import 'package:afro/Model/MediaModel.dart';

class AllFourmDataModel {
  String? sId;
  UserId? userId;
  String? title;
  String? question;
  List<MediaModel>? media;
  int? type;
  String? category;
  String? link;
  String? country;
  String? status;
  String? createdAt;
  String? updatedAt;
  int? iV;
  int? totalReplies;
  int? totalViews;
  int? totalLikes;
  int? totalDislikes;
  int? isLike;
  int? isDislike;

  AllFourmDataModel(
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
      this.totalLikes,
      this.totalDislikes,
      this.isLike,
      this.isDislike});

  AllFourmDataModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userId =
        json['user_id'] != null ? new UserId.fromJson(json['user_id']) : null;
    title = json['title'];
    question = json['question'];
    if (json['media'] != null) {
      media = <MediaModel>[];
      json['media'].forEach((v) {
        media!.add(new MediaModel.fromJson(v));
      });
    }
    type = json['type'];
    category = json['category'];
    link = json['link'];
    country = json['country'];
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    totalReplies = json['total_replies'];
    totalViews = json['total_views'];
    totalLikes = json['total_likes'];
    totalDislikes = json['total_dislikes'];
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
    data['category'] = this.category;
    data['link'] = this.link;
    data['country'] = this.country;
    data['status'] = this.status;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    data['total_replies'] = this.totalReplies;
    data['total_views'] = this.totalViews;
    data['total_likes'] = this.totalLikes;
    data['total_dislikes'] = this.totalDislikes;
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

