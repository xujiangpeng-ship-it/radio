class Station {
  final String id;
  final String name;
  final String country;
  final String language;
  final String url;
  final String? streamUrl;
  final String? genre;
  final String? description;
  final String? logoUrl;
  final int bitRate;
  final bool isFavorite;

  Station({
    required this.id,
    required this.name,
    required this.country,
    required this.language,
    required this.url,
    this.streamUrl,
    this.genre,
    this.description,
    this.logoUrl,
    this.bitRate = 128,
    this.isFavorite = false,
  });

  factory Station.fromJson(Map<String, dynamic> json) {
    return Station(
      id: json['id'] as String,
      name: json['name'] as String,
      country: json['country'] as String,
      language: json['language'] as String,
      url: json['url'] as String,
      streamUrl: json['stream_url'] as String?,
      genre: json['genre'] as String?,
      description: json['description'] as String?,
      logoUrl: json['logo_url'] as String?,
      bitRate: json['bit_rate'] as int? ?? 128,
      isFavorite: json['is_favorite'] as bool? ?? false,
    );
  }
}
