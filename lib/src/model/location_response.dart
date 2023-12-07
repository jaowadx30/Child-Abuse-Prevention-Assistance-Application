// To parse this JSON data, do
//
//     final locationResponse = locationResponseFromJson(jsonString);

import 'dart:convert';

LocationResponse locationResponseFromJson(String str) =>
    LocationResponse.fromJson(json.decode(str));

String locationResponseToJson(LocationResponse data) =>
    json.encode(data.toJson());

class LocationResponse {
  LocationResponse({
    required this.place,
    required this.status,
  });

  late Place place;
  late int status;

  factory LocationResponse.fromJson(Map<String, dynamic> json) =>
      LocationResponse(
        place: Place.fromJson(json["place"]),
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "place": place.toJson(),
        "status": status,
      };
}

class Place {
  Place({
    required this.id,
    required this.distanceWithinMeters,
    required this.address,
    required this.area,
    required this.city,
  });

  int id;
  dynamic distanceWithinMeters;
  String address;
  String area;
  String city;

  factory Place.fromJson(Map<String, dynamic> json) => Place(
        id: json["id"],
        distanceWithinMeters: json["distance_within_meters"],
        address: json["address"],
        area: json["area"],
        city: json["city"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "distance_within_meters": distanceWithinMeters,
        "address": address,
        "area": area,
        "city": city,
      };
}
