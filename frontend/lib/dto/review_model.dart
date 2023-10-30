class Review {
  String id;
  String cosmeticName;
  String imageUrl;
  String review;
  String date;

  Review({
    required this.id,
    required this.cosmeticName,
    required this.imageUrl,
    required this.review,
    required this.date,
  });

  @override
  String toString() {
    return '''
Review {
  id: $id,
  cosmeticName: $cosmeticName,
  imageUrl: $imageUrl,
  review: $review,
  date: $date,
}''';
  }

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'],
      cosmeticName: json['cosmeticName'],
      imageUrl: json['imageUrl'],
      review: json['review'],
      date: json['date'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cosmeticName': cosmeticName,
      'imageUrl': imageUrl,
      'review': review,
      'date': date,
    };
  }
}
