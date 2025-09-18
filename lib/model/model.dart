import 'package:isar/isar.dart';

part 'model.g.dart';

@collection
class AuthUserData {
  Id id = Isar.autoIncrement;

  String? uid;
  String? name;
  String? email;
  String? photoUrl;
  String? token;

  AuthUserData({
    this.uid,
    this.name,
    this.email,
    this.photoUrl,
    this.token,
  });

  factory AuthUserData.fromFirebaseUser({
    required String uid,
    String? name,
    String? email,
    String? photoUrl,
    String? token,
  }) {
    return AuthUserData(
      uid: uid,
      name: name,
      email: email,
      photoUrl: photoUrl,
      token: token
    );
  }
}
