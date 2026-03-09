import 'package:equatable/equatable.dart';

class AuthUserModel extends Equatable {
  final String id;
  final String name;
  final String email;
  final String? token;
  final String? phone;
  final String? avatarUrl;

  const AuthUserModel({
    required this.id,
    required this.name,
    required this.email,
    this.token,
    this.phone,
    this.avatarUrl,
  });

  AuthUserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? token,
    String? phone,
    String? avatarUrl,
  }) {
    return AuthUserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      token: token ?? this.token,
      phone: phone ?? this.phone,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'token': token,
        'phone': phone,
        'avatarUrl': avatarUrl,
      };

  factory AuthUserModel.fromJson(Map<String, dynamic> json) => AuthUserModel(
        id: json['id'] as String,
        name: json['name'] as String,
        email: json['email'] as String,
        token: json['token'] as String?,
        phone: json['phone'] as String?,
        avatarUrl: json['avatarUrl'] as String?,
      );

  String get initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : 'U';
  }

  @override
  List<Object?> get props => [id, name, email, token, phone, avatarUrl];
}
