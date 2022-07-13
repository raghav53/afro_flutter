class EventPostDataModel {
  String? sId;
  String? eventId;
  String? userId;
  String? caption;
  List<Media>? media;
  String? status;
  String? createdAt;
  String? updatedAt;
  int? iV;
  User? user;
  int? totalComments;
  int? totalLikes;
  int? totalDislikes;
  int? isLike;
  int? isDislike;

  EventPostDataModel(
      {this.sId,
      this.eventId,
      this.userId,
      this.caption,
      this.media,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.iV,
      this.user,
      this.totalComments,
      this.totalLikes,
      this.totalDislikes,
      this.isLike,
      this.isDislike});

  EventPostDataModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    eventId = json['event_id'];
    userId = json['user_id'];
    caption = json['caption'];
    if (json['media'] != null) {
      media = <Media>[];
      json['media'].forEach((v) {
        media!.add(new Media.fromJson(v));
      });
    }
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    totalComments = json['total_comments'];
    totalLikes = json['total_likes'];
    totalDislikes = json['total_dislikes'];
    isLike = json['is_like'];
    isDislike = json['is_dislike'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['event_id'] = this.eventId;
    data['user_id'] = this.userId;
    data['caption'] = this.caption;
    if (this.media != null) {
      data['media'] = this.media!.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    data['total_comments'] = this.totalComments;
    data['total_likes'] = this.totalLikes;
    data['total_dislikes'] = this.totalDislikes;
    data['is_like'] = this.isLike;
    data['is_dislike'] = this.isDislike;
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

class User {
  String? sId;
  String? profileImage;
  String? fullName;

  User({this.sId, this.profileImage, this.fullName});

  User.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    profileImage = json['profile_image'];
    fullName = json['full_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['profile_image'] = this.profileImage;
    data['full_name'] = this.fullName;
    return data;
  }
}

class PostMetadata {
  int? limit;
  int? currentPage;
  int? totalDocs;
  var totalPages;

  PostMetadata({this.limit, this.currentPage, this.totalDocs, this.totalPages});

  PostMetadata.fromJson(Map<String, dynamic> json) {
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
