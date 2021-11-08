class PasswordModel{
  int uniqueId;
  String domain;
  String iv;
  String? username;

  PasswordModel({required this.uniqueId, required this.domain, required this.iv, this.username});
}