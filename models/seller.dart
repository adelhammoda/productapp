import 'package:flutter/material.dart';

class Seller {
  final String bio;
  final String imageUrl;
  final String name;
  final TimeOfDay openingHour;
  final TimeOfDay closingHour;
  final List<String> productsType;
  final List<String> workDays;

  const Seller({ this.bio = '',
    required this.imageUrl,
    required this.name,
    required this.openingHour,
    required this.closingHour,
    required this.productsType,
    required this.workDays});

  static TimeOfDay fromString(String timeAsString) {
    final timeList = timeAsString.split('.');
    int hour = int.tryParse(timeList[0]) ?? 0;
    int minute = int.tryParse(timeList[1]) ?? 0;
    return TimeOfDay(hour: hour, minute: minute);
  }


  factory Seller.fromJSON(Map<String, dynamic> data){
   final startHour= Seller.fromString(data['openingHour']);
   final endHour=Seller.fromString(data['closingHour']);
    return Seller(
        bio: data['bio'],
        imageUrl: data['imageUrl'],
        name: data['name'],
        openingHour:startHour,
        closingHour: endHour,
        productsType: data['productType'],
        workDays: data['workDays']);
  }

  Map<String, dynamic> toJSON() {
    return {
      "bio": bio,
      "imageUrl": imageUrl,
      "name": name,
      "openingHour": _fromTime(openingHour),
      "closingHour": _fromTime(closingHour),
      "productsType": productsType,
      "workDays": workDays
    };
  }

  String _fromTime(TimeOfDay time) =>
      time.hour.toString() + '.' + time.minute.toString();

}
