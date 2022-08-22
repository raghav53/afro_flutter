import 'package:afro/Model/MediaModel.dart';

class MyAllThreadsDataModel {
  String? sId;
  String? userId;
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
  int? isLike;
  int? isDislike;

  MyAllThreadsDataModel(
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

  MyAllThreadsDataModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userId = json['user_id'];
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
    isLike = json['is_like'];
    isDislike = json['is_dislike'];
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
