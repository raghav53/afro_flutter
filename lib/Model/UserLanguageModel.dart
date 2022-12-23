class UserLanguageModel {
  bool? success;
  int? code;
  String? message;
  List<LanguageData>? data;
  Metadata? metadata;

  UserLanguageModel(
      {this.success, this.code, this.message, this.data, this.metadata});

  UserLanguageModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    code = json['code'];
    message = json['message'];
    if (json['data'] != null) {
      data = <LanguageData>[];
      json['data'].forEach((v) {
        data!.add(new LanguageData.fromJson(v));
      });
    }
    metadata = json['metadata'] != null
        ? new Metadata.fromJson(json['metadata'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['code'] = this.code;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (this.metadata != null) {
      data['metadata'] = this.metadata!.toJson();
    }
    return data;
  }
}

class LanguageData {
  String? sId;
  String? userId;
  String? languageId;
  String? createdAt;
  String? updatedAt;
  int? iV;
  Language? language;

  LanguageData(
      {this.sId,
      this.userId,
      this.languageId,
      this.createdAt,
      this.updatedAt,
      this.iV,
      this.language});

  LanguageData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userId = json['user_id'];
    languageId = json['language_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    language = json['language'] != null
        ? new Language.fromJson(json['language'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['user_id'] = this.userId;
    data['language_id'] = this.languageId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    if (this.language != null) {
      data['language'] = this.language!.toJson();
    }
    return data;
  }
}

class Language {
  String? sId;
  String? title;
  int? popularity;

  Language({this.sId, this.title, this.popularity});

  Language.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    title = json['title'];
    popularity = json['popularity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['title'] = this.title;
    data['popularity'] = this.popularity;
    return data;
  }
}

class Metadata {
  Metadata.fromJson(Map<String, dynamic> json) {}

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    return data;
  }
}
