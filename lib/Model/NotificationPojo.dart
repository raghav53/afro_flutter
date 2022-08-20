class NotificationPojo {
  String? notificationCode;
  String? soundname;
  Body? body;

  NotificationPojo({this.notificationCode, this.soundname, this.body});

  NotificationPojo.fromJson(Map<String, dynamic> json) {
    notificationCode = json['notification_code'];
    soundname = json['soundname'];
    body = json['body'] != null ? new Body.fromJson(json['body']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['notification_code'] = this.notificationCode;
    data['soundname'] = this.soundname;
    if (this.body != null) {
      data['body'] = this.body!.toJson();
    }
    return data;
  }
}

class Body {
  Data? data;
  String? title;
  String? message;

  Body({this.data, this.title, this.message});

  Body.fromJson(Map<String, dynamic> json) {
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
  String? notification;
  String? createdAt;
  String? userId;
  bool? unread;
  int? iV;
  String? sId;
  String? tableId;
  String? type;
  String? senderId;
  String? updatedAt;
  String? token;

  Data(
      {this.notification,
      this.createdAt,
      this.userId,
      this.unread,
      this.iV,
      this.sId,
      this.tableId,
      this.type,
      this.senderId,
      this.updatedAt,
      this.token});

  Data.fromJson(Map<String, dynamic> json) {
    notification = json['notification'];
    createdAt = json['createdAt'];
    userId = json['user_id'];
    unread = json['unread'];
    iV = json['__v'];
    sId = json['_id'];
    tableId = json['table_id'];
    type = json['type'];
    senderId = json['sender_id'];
    updatedAt = json['updatedAt'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['notification'] = this.notification;
    data['createdAt'] = this.createdAt;
    data['user_id'] = this.userId;
    data['unread'] = this.unread;
    data['__v'] = this.iV;
    data['_id'] = this.sId;
    data['table_id'] = this.tableId;
    data['type'] = this.type;
    data['sender_id'] = this.senderId;
    data['updatedAt'] = this.updatedAt;
    data['token'] = this.token;
    return data;
  }
}