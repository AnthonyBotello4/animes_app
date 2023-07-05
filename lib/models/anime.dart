class Anime {
  int? id;
  String? image;
  String? title;
  int? episodes;
  int? members;
  int? year;
  bool? isFavorite;

  Anime(
      {this.id,
        this.image,
        this.title,
        this.episodes,
        this.members,
        this.year,
        this.isFavorite
      });

  Anime.fromJson(Map<String, dynamic> json) {
    id = json['mal_id'];
    image = json['images']['jpg']['image_url'];
    //json['images'] != null ? new Images.fromJson(json['images']) : null;
    title = json['title'];
    episodes = json['episodes'];
    members = json['members'];
    year = json['year'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mal_id'] = this.id;
    data['images'] = this.image;
    data['title'] = this.title;
    data['episodes'] = this.episodes;
    data['members'] = this.members;
    data['year'] = this.year;
    return data;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'image': image,
      'year': year
    };
  }

}

class Images {
  Jpg? jpg;

  Images({this.jpg});

  Images.fromJson(Map<String, dynamic> json) {
    jpg = json['jpg'] != null ? new Jpg.fromJson(json['jpg']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.jpg != null) {
      data['jpg'] = this.jpg!.toJson();
    }
    return data;
  }
}

class Jpg {
  String? imageUrl;

  Jpg({this.imageUrl});

  Jpg.fromJson(Map<String, dynamic> json) {
    imageUrl = json['image_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image_url'] = this.imageUrl;
    return data;
  }
}
