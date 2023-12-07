// To parse this JSON data, do
//
//     final linkshortResponse = linkshortResponseFromJson(jsonString);

import 'dart:convert';

LinkshortResponse linkshortResponseFromJson(String str) =>
    LinkshortResponse.fromJson(json.decode(str));

String linkshortResponseToJson(LinkshortResponse data) =>
    json.encode(data.toJson());

class LinkshortResponse {
  LinkshortResponse({
    required this.url,
  });

  Url url;

  factory LinkshortResponse.fromJson(Map<String, dynamic> json) =>
      LinkshortResponse(
        url: Url.fromJson(json["url"]),
      );

  Map<String, dynamic> toJson() => {
        "url": url.toJson(),
      };
}

class Url {
  Url({
    required this.status,
    required this.fullLink,
    required this.date,
    required this.shortLink,
    required this.title,
  });

  int status;
  String fullLink;
  DateTime date;
  String shortLink;
  String title;

  factory Url.fromJson(Map<String, dynamic> json) => Url(
        status: json["status"],
        fullLink: json["fullLink"],
        date: DateTime.parse(json["date"]),
        shortLink: json["shortLink"],
        title: json["title"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "fullLink": fullLink,
        "date":
            "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "shortLink": shortLink,
        "title": title,
      };
}