class ReceivedRequestData {
  String? sId;
  String? userId;
  String? friendId;
  String? createdAt;
  String? updatedAt;
  int? iV;
  Friend? friend;

  ReceivedRequestData(
      {this.sId,
      this.userId,
      this.friendId,
      this.createdAt,
      this.updatedAt,
      this.iV,
      this.friend});

  ReceivedRequestData.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userId = json['user_id'];
    friendId = json['friend_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    friend =
        json['friend'] != null ? new Friend.fromJson(json['friend']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['user_id'] = this.userId;
    data['friend_id'] = this.friendId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    if (this.friend != null) {
      data['friend'] = this.friend!.toJson();
    }
    return data;
  }
}

class Friend {
  String? sId;
  String? profileImage;
  String? status;
  String? fullName;
  List<City>? city;
  List<Country>? country;
  List<State>? state;

  Friend(
      {this.sId,
      this.profileImage,
      this.status,
      this.fullName,
      this.city,
      this.country,
      this.state});

  Friend.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    profileImage = json['profile_image'];
    status = json['status'];
    fullName = json['full_name'];
    if (json['city'] != null) {
      city = <City>[];
      json['city'].forEach((v) {
        city!.add(new City.fromJson(v));
      });
    }
    if (json['country'] != null) {
      country = <Country>[];
      json['country'].forEach((v) {
        country!.add(new Country.fromJson(v));
      });
    }
    if (json['state'] != null) {
      state = <State>[];
      json['state'].forEach((v) {
        state!.add(new State.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['profile_image'] = this.profileImage;
    data['status'] = this.status;
    data['full_name'] = this.fullName;
    if (this.city != null) {
      data['city'] = this.city!.map((v) => v.toJson()).toList();
    }
    if (this.country != null) {
      data['country'] = this.country!.map((v) => v.toJson()).toList();
    }
    if (this.state != null) {
      data['state'] = this.state!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class City {
  String? sId;
  int? id;
  String? name;
  int? stateId;
  String? stateCode;
  String? stateName;
  int? countryId;
  String? countryCode;
  String? countryName;
  String? latitude;
  String? longitude;
  String? wikiDataId;
  String? title;
  String? status;

  City(
      {this.sId,
      this.id,
      this.name,
      this.stateId,
      this.stateCode,
      this.stateName,
      this.countryId,
      this.countryCode,
      this.countryName,
      this.latitude,
      this.longitude,
      this.wikiDataId,
      this.title,
      this.status});

  City.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    id = json['id'];
    name = json['name'];
    stateId = json['state_id'];
    stateCode = json['state_code'];
    stateName = json['state_name'];
    countryId = json['country_id'];
    countryCode = json['country_code'];
    countryName = json['country_name'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    wikiDataId = json['wikiDataId'];
    title = json['title'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['id'] = this.id;
    data['name'] = this.name;
    data['state_id'] = this.stateId;
    data['state_code'] = this.stateCode;
    data['state_name'] = this.stateName;
    data['country_id'] = this.countryId;
    data['country_code'] = this.countryCode;
    data['country_name'] = this.countryName;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['wikiDataId'] = this.wikiDataId;
    data['title'] = this.title;
    data['status'] = this.status;
    return data;
  }
}

class Country {
  String? sId;
  int? id;
  String? name;
  String? iso3;
  String? iso2;
  String? numericCode;
  String? phoneCode;
  String? capital;
  String? currency;
  String? currencyName;
  String? currencySymbol;
  String? tld;
  String? native;
  String? region;
  String? subregion;
  List<Timezones>? timezones;
  Translations? translations;
  String? latitude;
  String? longitude;
  String? emoji;
  String? emojiU;
  String? title;
  String? status;

  Country(
      {this.sId,
      this.id,
      this.name,
      this.iso3,
      this.iso2,
      this.numericCode,
      this.phoneCode,
      this.capital,
      this.currency,
      this.currencyName,
      this.currencySymbol,
      this.tld,
      this.native,
      this.region,
      this.subregion,
      this.timezones,
      this.translations,
      this.latitude,
      this.longitude,
      this.emoji,
      this.emojiU,
      this.title,
      this.status});

  Country.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    id = json['id'];
    name = json['name'];
    iso3 = json['iso3'];
    iso2 = json['iso2'];
    numericCode = json['numeric_code'];
    phoneCode = json['phone_code'];
    capital = json['capital'];
    currency = json['currency'];
    currencyName = json['currency_name'];
    currencySymbol = json['currency_symbol'];
    tld = json['tld'];
    native = json['native'];
    region = json['region'];
    subregion = json['subregion'];
    if (json['timezones'] != null) {
      timezones = <Timezones>[];
      json['timezones'].forEach((v) {
        timezones!.add(new Timezones.fromJson(v));
      });
    }
    translations = json['translations'] != null
        ? new Translations.fromJson(json['translations'])
        : null;
    latitude = json['latitude'];
    longitude = json['longitude'];
    emoji = json['emoji'];
    emojiU = json['emojiU'];
    title = json['title'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['id'] = this.id;
    data['name'] = this.name;
    data['iso3'] = this.iso3;
    data['iso2'] = this.iso2;
    data['numeric_code'] = this.numericCode;
    data['phone_code'] = this.phoneCode;
    data['capital'] = this.capital;
    data['currency'] = this.currency;
    data['currency_name'] = this.currencyName;
    data['currency_symbol'] = this.currencySymbol;
    data['tld'] = this.tld;
    data['native'] = this.native;
    data['region'] = this.region;
    data['subregion'] = this.subregion;
    if (this.timezones != null) {
      data['timezones'] = this.timezones!.map((v) => v.toJson()).toList();
    }
    if (this.translations != null) {
      data['translations'] = this.translations!.toJson();
    }
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['emoji'] = this.emoji;
    data['emojiU'] = this.emojiU;
    data['title'] = this.title;
    data['status'] = this.status;
    return data;
  }
}

class Timezones {
  String? zoneName;
  int? gmtOffset;
  String? gmtOffsetName;
  String? abbreviation;
  String? tzName;

  Timezones(
      {this.zoneName,
      this.gmtOffset,
      this.gmtOffsetName,
      this.abbreviation,
      this.tzName});

  Timezones.fromJson(Map<String, dynamic> json) {
    zoneName = json['zoneName'];
    gmtOffset = json['gmtOffset'];
    gmtOffsetName = json['gmtOffsetName'];
    abbreviation = json['abbreviation'];
    tzName = json['tzName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['zoneName'] = this.zoneName;
    data['gmtOffset'] = this.gmtOffset;
    data['gmtOffsetName'] = this.gmtOffsetName;
    data['abbreviation'] = this.abbreviation;
    data['tzName'] = this.tzName;
    return data;
  }
}

class Translations {
  String? kr;
  String? br;
  String? pt;
  String? nl;
  String? hr;
  String? fa;
  String? de;
  String? es;
  String? fr;
  String? ja;
  String? it;
  String? cn;

  Translations(
      {this.kr,
      this.br,
      this.pt,
      this.nl,
      this.hr,
      this.fa,
      this.de,
      this.es,
      this.fr,
      this.ja,
      this.it,
      this.cn});

  Translations.fromJson(Map<String, dynamic> json) {
    kr = json['kr'];
    br = json['br'];
    pt = json['pt'];
    nl = json['nl'];
    hr = json['hr'];
    fa = json['fa'];
    de = json['de'];
    es = json['es'];
    fr = json['fr'];
    ja = json['ja'];
    it = json['it'];
    cn = json['cn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['kr'] = this.kr;
    data['br'] = this.br;
    data['pt'] = this.pt;
    data['nl'] = this.nl;
    data['hr'] = this.hr;
    data['fa'] = this.fa;
    data['de'] = this.de;
    data['es'] = this.es;
    data['fr'] = this.fr;
    data['ja'] = this.ja;
    data['it'] = this.it;
    data['cn'] = this.cn;
    return data;
  }
}

class State {
  String? sId;
  int? id;
  String? name;
  int? countryId;
  String? countryCode;
  String? countryName;
  String? stateCode;
  Null? type;
  String? latitude;
  String? longitude;
  String? status;
  String? title;

  State(
      {this.sId,
      this.id,
      this.name,
      this.countryId,
      this.countryCode,
      this.countryName,
      this.stateCode,
      this.type,
      this.latitude,
      this.longitude,
      this.status,
      this.title});

  State.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    id = json['id'];
    name = json['name'];
    countryId = json['country_id'];
    countryCode = json['country_code'];
    countryName = json['country_name'];
    stateCode = json['state_code'];
    type = json['type'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    status = json['status'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['id'] = this.id;
    data['name'] = this.name;
    data['country_id'] = this.countryId;
    data['country_code'] = this.countryCode;
    data['country_name'] = this.countryName;
    data['state_code'] = this.stateCode;
    data['type'] = this.type;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['status'] = this.status;
    data['title'] = this.title;
    return data;
  }
}

class ReceivedMetadata {
  int? limit;
  int? currentPage;
  int? totalDocs;
  var totalPages;

  ReceivedMetadata(
      {this.limit, this.currentPage, this.totalDocs, this.totalPages});

  ReceivedMetadata.fromJson(Map<String, dynamic> json) {
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
