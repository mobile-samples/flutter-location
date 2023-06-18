class Article {
  Article(
    this.authorId,
    this.content,
    this.description,
    this.id,
    this.name,
    this.status,
    this.tags,
    this.title,
    this.type,
  );

  String authorId;
  String content;
  String? description;
  String id;
  String? name;
  String status;
  List<String>? tags;
  String title;
  String type;

  factory Article.fromJson(Map<String, dynamic> json) => Article(
        json['authorId'],
        json['content'],
        json['description'] != null ? json['description'] : null,
        json['id'],
        json['name'],
        json['status'],
        json['tags'] == null ? null : json['tags'].cast<String>(),
        json['title'] ?? '',
        json['type'],
      );
}
