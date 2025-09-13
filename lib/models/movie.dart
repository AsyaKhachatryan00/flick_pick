import 'dart:convert';
import 'dart:typed_data';

class Movie {
  final String id;
  final String title;
  final Uint8List? poster;
  final String genre;
  final String directors;
  final String desc;
  bool watched;

  Movie({
    required this.id,
    required this.title,
    this.poster,
    required this.desc,
    required this.genre,
    required this.directors,
    this.watched = true,
  });
  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'],
      title: json['title'] as String,
      poster: json['poster'] != null
          ? Uint8List.fromList(json['poster'].cast<int>().toList())
          : null,
      desc: json['desc'] as String,
      genre: json['genre'] as String,
      directors: json['directors'] as String,
      watched: json['watched'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'poster': poster,
      'desc': desc,
      'genre': genre,
      'directors': directors,
      'watched': watched,
    };
  }

  String encode() => jsonEncode(toJson());

  static Movie decode(String jsonString) =>
      Movie.fromJson(jsonDecode(jsonString));
}
