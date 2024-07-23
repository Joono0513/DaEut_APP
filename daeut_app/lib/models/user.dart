import 'package:intl/intl.dart';

class User {
  int? userNo;
  String? userName;
  String? userPhone;
  DateTime? userBirth;
  String? userAddress;
  String? userEmail;
  String? userGender;
  String? userId;
  String? userPassword;
  String? confirmPassword;
  DateTime? userRegDate;
  String? userCoupon;
  DateTime? userUpdDate;
  int? enabled;
  int? status;
  int? partnerNo;
  List<UserAuth>? authList;

  User({
    this.userNo,
    this.userName,
    this.userPhone,
    this.userBirth,
    this.userAddress,
    this.userEmail,
    this.userGender,
    this.userId,
    this.userPassword,
    this.confirmPassword,
    this.userRegDate,
    this.userCoupon,
    this.userUpdDate,
    this.enabled,
    this.status,
    this.partnerNo,
    this.authList,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userNo: json['userNo'],
      userName: json['userName'],
      userPhone: json['userPhone'],
      userBirth: json['userBirth'] != null ? DateFormat('yyyy-MM-dd').parse(json['userBirth']) : null,
      userAddress: json['userAddress'],
      userEmail: json['userEmail'],
      userGender: json['userGender'],
      userId: json['userId'],
      userPassword: json['userPassword'],
      confirmPassword: json['confirmPassword'],
      userRegDate: json['userRegDate'] != null ? DateTime.parse(json['userRegDate']) : null,
      userCoupon: json['userCoupon'],
      userUpdDate: json['userUpdDate'] != null ? DateTime.parse(json['userUpdDate']) : null,
      enabled: json['enabled'],
      status: json['status'],
      partnerNo: json['partnerNo'],
      authList: (json['authList'] as List<dynamic>?)
          ?.map((authJson) => UserAuth.fromJson(authJson))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    final dateFormat = DateFormat('yyyy-MM-dd');
    return {
      'userNo': userNo,
      'userName': userName,
      'userPhone': userPhone,
      'userBirth': userBirth != null ? dateFormat.format(userBirth!) : null,
      'userAddress': userAddress,
      'userEmail': userEmail,
      'userGender': userGender,
      'userId': userId,
      'userPassword': userPassword,
      'confirmPassword': confirmPassword,
      'userRegDate': userRegDate?.toIso8601String(),
      'userCoupon': userCoupon,
      'userUpdDate': userUpdDate?.toIso8601String(),
      'enabled': enabled,
      'status': status,
      'partnerNo': partnerNo,
      'authList': authList?.map((auth) => auth.toJson()).toList(),
    };
  }
}

class UserAuth {
  int? authNo;
  int? userNo;
  String? userId;
  String? auth;

  UserAuth({
    this.authNo,
    this.userNo,
    this.userId,
    this.auth,
  });

  factory UserAuth.fromJson(Map<String, dynamic> json) {
    return UserAuth(
      authNo: json['authNo'],
      userNo: json['userNo'],
      userId: json['userId'],
      auth: json['auth'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'authNo': authNo,
      'userNo': userNo,
      'userId': userId,
      'auth': auth,
    };
  }
}
