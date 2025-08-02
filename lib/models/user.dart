// lib/models/user.dart
class User {
  final String id;
  final String username;
  final String email;
  final String? firstName;    // ✨ THÊM MỚI
  final String? lastName;     // ✨ THÊM MỚI
  final String? profilePictureUrl;
  final String? phoneNumber;
  final String? address1;
  final String? address2;
  final String? city;
  final String? country;
  final String? postalCode;
  final String? state;
  final String? googleId;
  final String? password;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  User({
    required this.id,
    required this.username,
    required this.email,
    this.firstName,           // ✨ THÊM MỚI
    this.lastName,            // ✨ THÊM MỚI
    this.profilePictureUrl,
    this.phoneNumber,
    this.address1,
    this.address2,
    this.city,
    this.country,
    this.postalCode,
    this.state,
    this.googleId,
    this.password,
    this.createdAt,
    this.updatedAt,
  });

  // ✨ Getter để lấy tên đầy đủ
  String get fullName {
    if (firstName != null && lastName != null) {
      return '$firstName $lastName'.trim();
    } else if (firstName != null) {
      return firstName!;
    } else if (lastName != null) {
      return lastName!;
    }
    return username; // Fallback về username nếu không có họ tên
  }

  // Factory từ JSON (API)
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      username: json['name'] as String,
      email: json['email'] as String,
      firstName: json['firstName'] as String?,        // ✨ THÊM MỚI
      lastName: json['lastName'] as String?,          // ✨ THÊM MỚI
      profilePictureUrl: json['profilePictureUrl'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      address1: json['address1'] as String?,
      address2: json['address2'] as String?,
      city: json['city'] as String?,
      country: json['country'] as String?,
      postalCode: json['postalCode'] as String?,
      state: json['state'] as String?,
      googleId: json['googleId'] as String?,
    );
  }

  // Factory từ Database Map
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] as String,
      username: map['username'] as String,
      email: map['email'] as String,
      firstName: map['first_name'] as String?,        // ✨ THÊM MỚI
      lastName: map['last_name'] as String?,          // ✨ THÊM MỚI
      profilePictureUrl: map['profile_picture_url'] as String?,
      phoneNumber: map['phone_number'] as String?,
      address1: map['address1'] as String?,
      address2: map['address2'] as String?,
      city: map['city'] as String?,
      country: map['country'] as String?,
      postalCode: map['postal_code'] as String?,
      state: map['state'] as String?,
      googleId: map['google_id'] as String?,
      createdAt: map['created_at'] != null 
          ? DateTime.parse(map['created_at']) 
          : null,
      updatedAt: map['updated_at'] != null 
          ? DateTime.parse(map['updated_at']) 
          : null,
    );
  }

  // Chuyển sang JSON (API)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': username,
      'email': email,
      'firstName': firstName,                         // ✨ THÊM MỚI
      'lastName': lastName,                           // ✨ THÊM MỚI
      'profilePictureUrl': profilePictureUrl,
      'phoneNumber': phoneNumber,
      'address1': address1,
      'address2': address2,
      'city': city,
      'country': country,
      'postalCode': postalCode,
      'state': state,
      'googleId': googleId,
    };
  }

  // Chuyển sang Map (Database)
  Map<String, dynamic> toMap({bool includePassword = false}) {
    final map = {
      'id': id,
      'username': username,
      'email': email,
      'first_name': firstName,                        // ✨ THÊM MỚI
      'last_name': lastName,                          // ✨ THÊM MỚI
      'profile_picture_url': profilePictureUrl,
      'phone_number': phoneNumber,
      'address1': address1,
      'address2': address2,
      'city': city,
      'country': country,
      'postal_code': postalCode,
      'state': state,
      'google_id': googleId,
      'created_at': createdAt?.toIso8601String() ?? DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    };
    
    if (includePassword && password != null) {
      map['password_hash'] = password!;
    }
    
    return map;
  }

  // Copy with method để update
  User copyWith({
    String? id,
    String? username,
    String? email,
    String? firstName,          // ✨ THÊM MỚI
    String? lastName,           // ✨ THÊM MỚI
    String? profilePictureUrl,
    String? phoneNumber,
    String? address1,
    String? address2,
    String? city,
    String? country,
    String? postalCode,
    String? state,
    String? googleId,
    String? password,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,        // ✨ THÊM MỚI
      lastName: lastName ?? this.lastName,           // ✨ THÊM MỚI
      profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address1: address1 ?? this.address1,
      address2: address2 ?? this.address2,
      city: city ?? this.city,
      country: country ?? this.country,
      postalCode: postalCode ?? this.postalCode,
      state: state ?? this.state,
      googleId: googleId ?? this.googleId,
      password: password ?? this.password,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
