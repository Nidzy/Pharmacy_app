class Users {
  String userName = "";
  String emailId =  "";
  String password = "";

  Users(this.userName, this.emailId, this.password);

  Users.fromMap(Map snapshot) {
    userName = snapshot['user_name'] ?? '';
    emailId = snapshot['email_id'] ?? '';
    password = snapshot['password'] ?? '';
  }

  toJson() {
    return {
      'user_name': userName,
      'email_id': emailId,
      'password': password,
    };
  }
}
