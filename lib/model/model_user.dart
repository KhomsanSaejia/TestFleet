class UserModel {
  String? userName;
  String? userLastname;
  String? userTel;
  String? userAddress;
  String? userId;
  String? userPassword;

  UserModel(
      {this.userName,
      this.userLastname,
      this.userTel,
      this.userAddress,
      this.userId,
      this.userPassword});

  UserModel.fromJson(Map<String, dynamic> json) {
    userName = json['user_name'];
    userLastname = json['user_lastname'];
    userTel = json['user_tel'];
    userAddress = json['user_address'];
    userId = json['user_id'];
    userPassword = json['user_password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_name'] = userName;
    data['user_lastname'] = userLastname;
    data['user_tel'] = userTel;
    data['user_address'] = userAddress;
    data['user_id'] = userId;
    data['user_password'] = userPassword;
    return data;
  }
}
