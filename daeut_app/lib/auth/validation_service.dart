import 'package:flutter/material.dart';

class ValidationService {
  void showAlert(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('알림'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('확인'),
          ),
        ],
      ),
    );
  }

  bool validateForm(BuildContext context, Map<String, String> formData, bool isIdChecked, bool isEmailChecked) {
    final userIdPattern = RegExp(r'^[a-zA-Z0-9]{4,12}$');
    final passwordPattern = RegExp(r'^(?=.*[a-zA-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$');

    if (!userIdPattern.hasMatch(formData['userId']!)) {
      showAlert(context, '아이디는 4~12자의 영문 또는 숫자만 가능합니다.');
      return false;
    }
    if (!passwordPattern.hasMatch(formData['userPassword']!)) {
      showAlert(context, '비밀번호는 8자 이상이어야 하며, 영문, 숫자, 특수문자를 모두 포함해야 합니다.');
      return false;
    }
    if (formData['userPassword'] != formData['confirmPassword']) {
      showAlert(context, '비밀번호가 일치하지 않습니다.');
      return false;
    }
    if (formData['userName']!.isEmpty) {
      showAlert(context, '이름을 입력해주세요.');
      return false;
    }
    if (formData['userBirth']!.isEmpty) {
      showAlert(context, '생년월일을 입력해주세요.');
      return false;
    }
    if (!RegExp(r'^\d{10,11}$').hasMatch(formData['userPhone']!)) {
      showAlert(context, '연락처를 올바르게 입력해주세요.');
      return false;
    }
    if (formData['userEmail']!.isEmpty || !RegExp(r'\S+@\S+\.\S+').hasMatch(formData['userEmail']!)) {
      showAlert(context, '올바른 이메일 주소를 입력해주세요.');
      return false;
    }
    if (formData['userAddress']!.isEmpty) {
      showAlert(context, '주소를 입력해주세요.');
      return false;
    }
    if (!isIdChecked) {
      showAlert(context, '아이디 중복 체크를 해주세요.');
      return false;
    }
    if (!isEmailChecked) {
      showAlert(context, '이메일 중복 체크를 해주세요.');
      return false;
    }

    return true;
  }
}
