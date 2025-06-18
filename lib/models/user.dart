class User {
  final String id;
  final String name;
  final String email;
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

  User({
    required this.id,
    required this.name,
    required this.email,
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
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      profilePictureUrl: json['profilePictureUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'profilePictureUrl': profilePictureUrl,
    };
  }

  //dữ liệu mẫu cho người dùng
  static User sampleUser = User(
    id: '1',
    name: 'John Doe',
    email: 'johndoe@example.com',
    profilePictureUrl: 'https://example.com/profile.jpg',
    phoneNumber: '123-456-7890',
    address1: '123 Main Street',
    address2: 'Apt 4B',
    city: 'New York',
    country: 'USA',
    postalCode: '10001',
    state: 'NY',
    googleId: 'google123',
    password: 'password123',
  );
}
