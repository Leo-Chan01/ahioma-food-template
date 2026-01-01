import 'package:flutter/foundation.dart';
import 'package:ahioma_food_template/features/checkout/data/models/add_address_response_model.dart';

/// Represents a storefront customer returned by the Ahioma API.
class CustomerModel {
  const CustomerModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.phoneNumber,
    this.avatarUrl,
    this.gender,
    this.dateOfBirth,
    this.createdAt,
    this.updatedAt,
    this.addresses,
  });

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    final id =
        json['id'] ?? json['_id'] ?? json['customerId'] ?? json['customer_id'];
    if (id == null) {
      throw StateError('Customer ID is required');
    }

    String readString(dynamic value) {
      if (value == null) return '';
      return value is String ? value : value.toString();
    }

    DateTime? parseDate(dynamic value) {
      if (value == null) return null;
      try {
        return DateTime.parse(value.toString());
      } catch (error) {
        if (kDebugMode) {
          debugPrint('[CustomerModel] Failed to parse date: $value');
        }
        return null;
      }
    }

    return CustomerModel(
      id: id.toString(),
      firstName: readString(
        json['firstName'] ?? json['first_name'] ?? json['first_name'],
      ),
      lastName: readString(
        json['lastName'] ?? json['last_name'] ?? json['surname'],
      ),
      email: readString(json['email']),
      phoneNumber:
          readString(
            json['phoneNumber'] ?? json['phone_number'] ?? json['phone'],
          ).trim().isEmpty
          ? null
          : readString(
              json['phoneNumber'] ?? json['phone_number'] ?? json['phone'],
            ),
      avatarUrl:
          readString(
            json['avatar'] ?? json['avatarUrl'] ?? json['profileImage'],
          ).trim().isEmpty
          ? null
          : readString(
              json['avatar'] ?? json['avatarUrl'] ?? json['profileImage'],
            ),
      gender: readString(json['gender']).trim().isEmpty
          ? null
          : readString(json['gender']),
      dateOfBirth: parseDate(
        json['dateOfBirth'] ?? json['date_of_birth'] ?? json['dob'],
      ),
      createdAt: parseDate(json['createdAt']),
      updatedAt: parseDate(json['updatedAt']),
      addresses: _parseAddresses(json['addresses']),
    );
  }

  static List<AddAddressResponseModel>? _parseAddresses(dynamic value) {
    if (value == null) return null;
    if (value is! List) return null;
    try {
      return value
          .map(
            (item) => AddAddressResponseModel.fromJson(
              item as Map<String, dynamic>,
            ),
          )
          .toList();
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[CustomerModel] Error parsing addresses: $e');
      }
      return null;
    }
  }

  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String? phoneNumber;
  final String? avatarUrl;
  final String? gender;
  final DateTime? dateOfBirth;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<AddAddressResponseModel>? addresses;

  String get fullName {
    final parts = <String>[
      if (firstName.trim().isNotEmpty) firstName.trim(),
      if (lastName.trim().isNotEmpty) lastName.trim(),
    ];
    if (parts.isEmpty) return email;
    return parts.join(' ');
  }
}
