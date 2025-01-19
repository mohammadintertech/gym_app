class User {
  String? username;
  String? password;
  String? isAdmin;

  User({this.isAdmin, this.password, this.username});

  User.fromJson(dynamic json) {
    username = json['username'];
    password = json['password'];
    isAdmin = json['isAdmin'];
  }
}
