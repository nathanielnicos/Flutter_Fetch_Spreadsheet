class FeedbackModel {
  String profilePicture;
  String name;
  String manga;
  String details;
  String url;

  FeedbackModel({this.profilePicture, this.name, this.manga, this.details, this.url});

  factory FeedbackModel.fromJson(dynamic json) {
    return FeedbackModel(
      profilePicture: "${json['profile_picture']}",
      name: "${json['name']}",
      manga: "${json['manga']}",
      details: "${json['details']}",
      url: "${json['url']}",
    );
  }

  Map toJson() => {
    "profile_picture": profilePicture,
    "name": name,
    "mange": manga,
    "details": details,
    "url": url,
  };
}