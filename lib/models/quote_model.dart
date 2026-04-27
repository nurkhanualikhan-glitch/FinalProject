class QuoteModel {
  final String text;
  final String author;

  const QuoteModel({
    required this.text,
    required this.author,
  });

  factory QuoteModel.fromJson(Map<String, dynamic> json) {
    return QuoteModel(
      text: json['quote'] ?? json['q'] ?? '',
      author: json['author'] ?? json['a'] ?? 'Unknown',
    );
  }
}