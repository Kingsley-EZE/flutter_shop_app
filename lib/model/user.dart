

class UserModel{
  final String fullName;
  final String email;
  final String password;
  final String? userId;
  final String userProfileImage;
  final int phoneNumber;
  final int profileCompleted;

  UserModel({
      required this.fullName,
      required this.email,
      required this.password,
      required this.userId,
      required this.userProfileImage,
      required this.phoneNumber,
      required this.profileCompleted
});

  Map<String, dynamic> toMap(){
    return {
      'fullName': fullName,
      'email': email,
      'password': password,
      'userId': userId,
      'userProfileImage': userProfileImage,
      'phoneNumber': phoneNumber,
      'profileCompleted': profileCompleted
    };
  }

}