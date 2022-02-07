class Quote {
  final String id;
  final String content;
  final String author;

  const Quote({
    required this.id,
    required this.content,
    required this.author,
  });

  factory Quote.fromJson(Map<String, dynamic> json) {
    return Quote(
      id: json['_id'],
      content: json['content'],
      author: json['author'],
    );
  }
}
