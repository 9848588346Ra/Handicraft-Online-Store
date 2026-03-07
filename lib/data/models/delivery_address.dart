import 'package:flutter/material.dart';

enum AddressType {
  home,
  work,
  study,
}

extension AddressTypeExtension on AddressType {
  String get label {
    switch (this) {
      case AddressType.home:
        return 'Home';
      case AddressType.work:
        return 'Work';
      case AddressType.study:
        return 'Study';
    }
  }

  IconData get icon {
    switch (this) {
      case AddressType.home:
        return Icons.home_outlined;
      case AddressType.work:
        return Icons.work_outline;
      case AddressType.study:
        return Icons.school_outlined;
    }
  }

  Color get color {
    switch (this) {
      case AddressType.home:
        return const Color(0xFF4CAF50); // green
      case AddressType.work:
        return const Color(0xFF2196F3); // blue
      case AddressType.study:
        return const Color(0xFF9C27B0); // purple
    }
  }
}

class DeliveryAddress {
  final String id;
  final AddressType type;
  final String fullName;
  final String street;
  final String city;
  final String state;
  final String zip;
  final String phone;

  DeliveryAddress({
    required this.id,
    required this.type,
    required this.fullName,
    required this.street,
    required this.city,
    required this.state,
    required this.zip,
    required this.phone,
  });

  String get fullAddress => '$street, $city, $state $zip';
  String get shortSummary => '$street, $city';
  /// Format used for order placement (name, street, city, state zip, phone).
  String get orderAddressString => '$fullName, $street, $city, $state $zip, $phone';

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type.index,
        'fullName': fullName,
        'street': street,
        'city': city,
        'state': state,
        'zip': zip,
        'phone': phone,
      };

  factory DeliveryAddress.fromJson(Map<String, dynamic> json) => DeliveryAddress(
        id: json['id'] as String? ?? '',
        type: AddressType.values[json['type'] as int? ?? 0],
        fullName: json['fullName'] as String? ?? '',
        street: json['street'] as String? ?? '',
        city: json['city'] as String? ?? '',
        state: json['state'] as String? ?? '',
        zip: json['zip'] as String? ?? '',
        phone: json['phone'] as String? ?? '',
      );

  DeliveryAddress copyWith({
    String? id,
    AddressType? type,
    String? fullName,
    String? street,
    String? city,
    String? state,
    String? zip,
    String? phone,
  }) =>
      DeliveryAddress(
        id: id ?? this.id,
        type: type ?? this.type,
        fullName: fullName ?? this.fullName,
        street: street ?? this.street,
        city: city ?? this.city,
        state: state ?? this.state,
        zip: zip ?? this.zip,
        phone: phone ?? this.phone,
      );
}
