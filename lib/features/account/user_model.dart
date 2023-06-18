class UserInfo {
  String? id;
  String? username;
  String? email;
  String? occupation;
  String? company;
  String? bio;
  String? givenname;
  String? familyname;
  String? website;
  String? location;
  List<String>? interests;
  List<String>? lookingFor;
  List<Skills>? skills;
  List<Achievements>? achievements;
  List<Companies>? companies;
  List<Educations>? educations;
  List<Works>? works;
  List<Gallery>? gallery;
  String? imageURL;
  String? coverURL;

  UserInfo(
      {this.id,
      this.username,
      this.email,
      this.occupation,
      this.company,
      this.bio,
      this.givenname,
      this.familyname,
      this.website,
      this.location,
      this.interests,
      this.lookingFor,
      this.skills,
      this.achievements,
      this.companies,
      this.educations,
      this.works,
      this.gallery,
      this.imageURL,
      this.coverURL});

  UserInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    email = json['email'];
    occupation = json['occupation'];
    company = json['company'];
    bio = json['bio'];
    givenname = json['givenname'] == null ? '' : json['givenname'];
    familyname = json['familyname'] == null ? '' : json['familyname'];
    website = json['website'] == null ? '' : json['website'];
    location = json['location'] == null ? '' : json['location'];
    interests = json['interests'] == null
        ? ['']
        : List<String>.from(json['interests']?.map((x) => x.toString()));
    lookingFor = json['lookingFor'] == null
        ? ['']
        : List<String>.from(json['lookingFor']?.map((x) => x.toString()));
    if (json['skills'] != null) {
      skills = <Skills>[];
      json['skills'].forEach((v) {
        skills!.add(new Skills.fromJson(v));
      });
    } else {
      skills = [];
    }
    if (json['achievements'] != null) {
      achievements = <Achievements>[];
      json['achievements'].forEach((v) {
        achievements!.add(new Achievements.fromJson(v));
      });
    }
    if (json['companies'] != null) {
      companies = <Companies>[];
      json['companies'].forEach((v) {
        companies!.add(new Companies.fromJson(v));
      });
    }
    if (json['educations'] != null) {
      educations = <Educations>[];
      json['educations'].forEach((v) {
        educations!.add(new Educations.fromJson(v));
      });
    }
    if (json['works'] != null) {
      works = <Works>[];
      json['works'].forEach((v) {
        works!.add(new Works.fromJson(v));
      });
    }
    if (json['gallery'] != null) {
      gallery = <Gallery>[];
      json['gallery'].forEach((v) {
        gallery!.add(new Gallery.fromJson(v));
      });
    }
    imageURL = json['imageURL'];
    coverURL = json['coverURL'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['username'] = this.username;
    data['email'] = this.email;
    data['occupation'] = this.occupation;
    data['company'] = this.company;
    data['bio'] = this.bio;
    data['givenname'] = this.givenname;
    data['familyname'] = this.familyname;
    data['website'] = this.website;
    data['location'] = this.location;
    data['interests'] = this.interests;
    data['lookingFor'] = this.lookingFor;
    if (this.skills != null) {
      data['skills'] = this.skills!.map((v) => v.toJson()).toList();
    }
    if (this.achievements != null) {
      data['achievements'] = this.achievements!.map((v) => v.toJson()).toList();
    }
    if (this.companies != null) {
      data['companies'] = this.companies!.map((v) => v.toJson()).toList();
    }
    if (this.educations != null) {
      data['educations'] = this.educations!.map((v) => v.toJson()).toList();
    }
    if (this.works != null) {
      data['works'] = this.works!.map((v) => v.toJson()).toList();
    }
    if (this.gallery != null) {
      data['gallery'] = this.gallery!.map((v) => v.toJson()).toList();
    }
    data['imageURL'] = this.imageURL;
    data['coverURL'] = this.coverURL;
    return data;
  }
}

class Skills {
  String? skill;

  Skills({this.skill});

  Skills.fromJson(Map<String, dynamic> json) {
    skill = json['skill'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['skill'] = this.skill;
    return data;
  }
}

class Achievements {
  String? subject;
  String? description;

  Achievements({this.subject, this.description});

  Achievements.fromJson(Map<String, dynamic> json) {
    subject = json['subject'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['subject'] = this.subject;
    data['description'] = this.description;
    return data;
  }
}

class Companies {
  String? name;
  String? description;
  String? position;
  String? from;
  String? to;

  Companies({this.name, this.description, this.position, this.from, this.to});

  Companies.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    description = json['description'];
    position = json['position'];
    from = json['from'];
    to = json['to'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['description'] = this.description;
    data['position'] = this.position;
    data['from'] = this.from;
    data['to'] = this.to;
    return data;
  }
}

class Works {
  String? name;
  String? description;
  String? position;
  String? from;
  String? to;

  Works({this.name, this.description, this.position, this.from, this.to});

  Works.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    description = json['description'];
    position = json['position'];
    from = json['from'];
    to = json['to'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['description'] = this.description;
    data['position'] = this.position;
    data['from'] = this.from;
    data['to'] = this.to;
    return data;
  }
}

class Educations {
  String? school;
  String? degree;
  String? major;
  String? from;
  String? to;
  String? title;

  Educations(
      {this.school, this.degree, this.major, this.from, this.to, this.title});

  Educations.fromJson(Map<String, dynamic> json) {
    school = json['school'];
    degree = json['degree'];
    major = json['major'];
    from = json['from'];
    to = json['to'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['school'] = this.school;
    data['degree'] = this.degree;
    data['major'] = this.major;
    data['from'] = this.from;
    data['to'] = this.to;
    data['title'] = this.title;
    return data;
  }
}

class Gallery {
  String? type;
  String? url;

  Gallery({this.type, this.url});

  Gallery.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['url'] = this.url;
    return data;
  }
}
