class DataModel {
  final List<PostItem> posts;
  final int total;
  final int skip;
  final int limit;

  DataModel({
    required this.posts,
    required this.total,
    required this.skip,
    required this.limit,
  });

  factory DataModel.fromJson(Map<String, dynamic> json) {
    final List posts = json["posts"];
    final List<PostItem> postItems = posts
        .map((e) => PostItem.fromJson(e))
        .toList();
    return DataModel(
      posts: postItems,
      total: json["total"],
      skip: json["skip"],
      limit: json["limit"],
    );
  }
}

class PostItem {
  final int id;
  final String title;
  final String body;
  final List tags;
  final Reactions reactions;
  final int views;
  final int userId;

  PostItem({
    required this.id,
    required this.title,
    required this.body,
    required this.tags,
    required this.reactions,
    required this.views,
    required this.userId,
  });

  PostItem.fromJson(Map<String, dynamic> json)
    : id = json["id"],
      title = json["title"],
      body = json["body"],
      tags = json["tags"],
      reactions = Reactions.fromJson(json["reactions"]),
      views = json["views"],
      userId = json["userId"];
}

class Reactions {
  final int likes;
  final int dislikes;

  Reactions({required this.likes, required this.dislikes});

  Reactions.fromJson(Map<String, dynamic> json)
    : likes = json["likes"],
      dislikes = json["dislikes"];
}
