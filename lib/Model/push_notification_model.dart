class PushNotificationModel {
  Data? data;
  String? title;
  String? message;

  PushNotificationModel({this.data, this.title, this.message});

  PushNotificationModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    title = json['title'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['title'] = this.title;
    data['message'] = this.message;
    return data;
  }
}

class Data {
  bool? isBlock;
  UserData? userData;
  String? thumb;
  bool? unread;
  String? receiverId;
  String? media;
  String? message;
  String? type;
  String? tableId;
  String? senderId;
  String? token;
  String? createdAt;
  int? mediaType;
  int? iV;
  String? sId;
  String? blockBy;
  String? updatedAt;

  Data(
      {this.isBlock,
        this.userData,
        this.thumb,
        this.unread,
        this.receiverId,
        this.media,
        this.message,
        this.type,
        this.tableId,
        this.senderId,
        this.token,
        this.createdAt,
        this.mediaType,
        this.iV,
        this.sId,
        this.blockBy,
        this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    isBlock = json['isBlock'];
    userData = json['userData'] != null
        ? new UserData.fromJson(json['userData'])
        : null;
    thumb = json['thumb'];
    unread = json['unread'];
    receiverId = json['receiver_id'];
    media = json['media'];
    message = json['message'];
    type = json['type'];
    tableId = json['table_id'];
    senderId = json['sender_id'];
    token = json['token'];
    createdAt = json['createdAt'];
    mediaType = json['media_type'];
    iV = json['__v'];
    sId = json['_id'];
    blockBy = json['blockBy'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['isBlock'] = this.isBlock;
    if (this.userData != null) {
      data['userData'] = this.userData!.toJson();
    }
    data['thumb'] = this.thumb;
    data['unread'] = this.unread;
    data['receiver_id'] = this.receiverId;
    data['media'] = this.media;
    data['message'] = this.message;
    data['type'] = this.type;
    data['table_id'] = this.tableId;
    data['sender_id'] = this.senderId;
    data['token'] = this.token;
    data['createdAt'] = this.createdAt;
    data['media_type'] = this.mediaType;
    data['__v'] = this.iV;
    data['_id'] = this.sId;
    data['blockBy'] = this.blockBy;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}

class UserData {
  String? profileImage;
  String? fullName;
  String? sId;
  String? id;

  UserData({this.profileImage, this.fullName, this.sId, this.id});

  UserData.fromJson(Map<String, dynamic> json) {
    profileImage = json['profile_image'];
    fullName = json['full_name'];
    sId = json['_id'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['profile_image'] = this.profileImage;
    data['full_name'] = this.fullName;
    data['_id'] = this.sId;
    data['id'] = this.id;
    return data;
  }
}