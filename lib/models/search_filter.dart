import 'package:flutter/foundation.dart';

class Searchfilter {
  double originLat;
  double originLng;
  double destinationLat;
  double destinationLng;
  int? seatsAvailable;
  DateTime? departureDate;
  double? price;

  Searchfilter({
    required this.originLat,
    required this.originLng,
    required this.destinationLat,
    required this.destinationLng,
    this.seatsAvailable,
    this.departureDate,
    this.price,
  });

  factory Searchfilter.fromJson(Map<String, dynamic> json) {
    return Searchfilter(
      originLat: json['originLat'],
      originLng: json['originLng'],
      destinationLat: json['destinationLat'],
      destinationLng: json['destinationLng'],
      seatsAvailable: json['seatsAvailable'],
      departureDate: DateTime.parse(json['departureDate']),
      price: json['price'],
    );
  }

  //convert current object to json string
  Map<String, dynamic> toJson() {
    return {
      'originLat': originLat,
      'originLng': originLng,
      'destinationLat': destinationLat,
      'destinationLng': destinationLng,
      'seatsAvailable': seatsAvailable,
      'departureDate': departureDate?.toUtc().toIso8601String(),
      'price': price,
    };
  }

  static DateTime parseDate(String? dateTimeStr) {
    try {
      return DateTime.parse(dateTimeStr!);
    } catch (e) {
      print('Error parsing date: $e');
      return DateTime.now();
    }
  }
}