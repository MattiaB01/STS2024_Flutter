class User {
  final String username;
  final String password;

  User(this.username, this.password);

  //da json a class
  User.fromJson(Map<String, dynamic> json)
      : username = json['username'] as String,
        password = json['password'] as String;

  //da class a json
  Map<String, dynamic> toJson() => {
        'username': username,
        'password': password,
      };
}
