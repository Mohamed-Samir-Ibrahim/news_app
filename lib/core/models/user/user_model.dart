import 'package:hive/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 1)
class UserModel extends HiveObject {
  @HiveField(0)
  final String uid;

  @HiveField(1)
  String email;

  @HiveField(2)
  final String password;

  @HiveField(3)
  String? username;

  @HiveField(4)
  String? phone;

  @HiveField(5)
  String? userImagePath;

  @HiveField(6)
  String? country;

  @HiveField(7)
  String? language;

  UserModel({
    required this.uid,
    required this.email,
    required this.password,
    this.username,
    this.phone,
    this.userImagePath,
    this.country,
    this.language,
  });

  @override
  String toString() {
    // TODO: implement toString
    return 'user: $uid , username: $username , email: $email , country: $country , language: $language';
  }
}
