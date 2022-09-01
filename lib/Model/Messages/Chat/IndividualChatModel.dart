class IndividualChatMessage {
  List<ChatList>? list;
  Metadata? metadata;

  IndividualChatMessage({this.list, this.metadata});

  IndividualChatMessage.fromJson(Map<String, dynamic> json) {
    if (json['list'] != null) {
      list = <ChatList>[];
      json['list'].forEach((v) {
        list!.add(new ChatList.fromJson(v));
      });
    }
    metadata = json['metadata'] != null
        ? new Metadata.fromJson(json['metadata'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.list != null) {
      data['list'] = this.list!.map((v) => v.toJson()).toList();
    }
    if (this.metadata != null) {
      data['metadata'] = this.metadata!.toJson();
    }
    return data;
  }
}

class ChatList {
  String? sId;
  String? senderId;
  String? receiverId;
  String? message;
  String? media;
  int? mediaType;
  bool? unread;
  int? type;
  bool? isBlock;
  String? blockBy;
  String? createdAt;
  String? updatedAt;
  int? iV;

  ChatList(
      {this.sId,
      this.senderId,
      this.receiverId,
      this.message,
      this.media,
      this.mediaType,
      this.unread,
      this.type,
      this.isBlock,
      this.blockBy,
      this.createdAt,
      this.updatedAt,
      this.iV});

  ChatList.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    senderId = json['sender_id'];
    receiverId = json['receiver_id'];
    message = json['message'];
    media = json['media'];
    mediaType = json['media_type'];
    unread = json['unread'];
    type = json['type'];
    isBlock = json['isBlock'];
    blockBy = json['blockBy'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['sender_id'] = this.senderId;
    data['receiver_id'] = this.receiverId;
    data['message'] = this.message;
    data['media'] = this.media;
    data['media_type'] = this.mediaType;
    data['unread'] = this.unread;
    data['type'] = this.type;
    data['isBlock'] = this.isBlock;
    data['blockBy'] = this.blockBy;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}

class Metadata {
  String? limit;
  String? currentPage;
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
