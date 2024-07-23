import 'package:daeut_app/auth/check_duplicate_service.dart';
import 'package:daeut_app/auth/validation_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart'; // DateFormat 사용을 위해 추가
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart'
    as picker;
class JoinScreen extends StatefulWidget {
  const JoinScreen({super.key});

  @override
  State<JoinScreen> createState() => _JoinScreenState();
}

class _JoinScreenState extends State<JoinScreen> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();
  final TextEditingController _pwChkController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _birthController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String _gender = "남성";

  bool isIdChecked = false;
  bool isEmailChecked = false;

  final ValidationService _validationService = ValidationService(); // 추가

  void _showAlert(BuildContext context, String message) {
    _validationService.showAlert(context, message);
  }

  Future<void> _checkDuplicateId() async {
    try {
      bool result = await CheckDuplicateService.checkDuplicateId(_idController.text);
      setState(() {
        isIdChecked = !result; // result가 false여야 사용 가능
      });
      if (result) {
        _showAlert(context, '이미 존재하는 아이디입니다.');
      } else {
        _showAlert(context, '사용 가능한 아이디입니다.');
      }
    } catch (error) {
      _showAlert(context, '중복 확인 중 오류가 발생했습니다.');
    }
  }

  Future<void> _checkDuplicateEmail() async {
    try {
      bool result = await CheckDuplicateService.checkDuplicateEmail(_emailController.text);
      setState(() {
        isEmailChecked = !result; // result가 false여야 사용 가능
      });
      if (result) {
        _showAlert(context, '이미 존재하는 이메일입니다.');
      } else {
        _showAlert(context, '사용 가능한 이메일입니다.');
      }
    } catch (error) {
      _showAlert(context, '중복 확인 중 오류가 발생했습니다.');
    }
  }

  void _submitForm() async {
    final formData = {
      'userId': _idController.text,
      'userPassword': _pwController.text,
      'confirmPassword': _pwChkController.text,
      'userName': _nameController.text,
      'userBirth': _birthController.text,
      'userPhone': _phoneController.text,
      'userEmail': _emailController.text,
      'userAddress': _addressController.text,
      'userGender': _gender,
    };

    if (!_validationService.validateForm(context, formData, isIdChecked, isEmailChecked)) {
      return;
    }

    try {
      final result = await CheckDuplicateService.join(formData);
      if (result == 'SUCCESS') {
        Navigator.pushNamed(context, '/home');
      } else {
        _showAlert(context, '회원가입에 실패했습니다.');
      }
    } catch (error) {
      _showAlert(context, '회원가입 중 오류가 발생했습니다.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('계정 생성'),
      // ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Center(
                child: Column(
                  children: [
                    Text('계정 생성', style: TextStyle(fontSize: 24)),
                    SizedBox(height: 8),
                    Text('계정에 사용될 정보를 입력해주세요'),
                  ],
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _idController,
                decoration: InputDecoration(
                  labelText: '아이디',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.check),
                    onPressed: _checkDuplicateId,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return '아이디를 입력해주세요';
                  if (!isIdChecked) return '아이디 중복확인을 해주세요';
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _pwController,
                decoration: InputDecoration(labelText: '비밀번호'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) return '비밀번호를 입력해주세요';
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _pwChkController,
                decoration: InputDecoration(labelText: '비밀번호 확인'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) return '비밀번호 확인을 입력해주세요';
                  if (value != _pwController.text) return '비밀번호가 일치하지 않습니다';
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: '이름'),
                validator: (value) {
                  if (value == null || value.isEmpty) return '이름을 입력해주세요';
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: '연락처 (\'-\' 제외)'),
                validator: (value) {
                  if (value == null || value.isEmpty) return '연락처를 입력해주세요';
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: '이메일',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.check),
                    onPressed: _checkDuplicateEmail,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return '이메일을 입력해주세요';
                  if (!isEmailChecked) return '이메일 중복확인을 해주세요';
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(labelText: '주소'),
                validator: (value) {
                  if (value == null || value.isEmpty) return '주소를 입력해주세요';
                  return null;
                },
              ),
              SizedBox(height: 20),
              Text('성별'),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Radio(
                    value: '남성',
                    groupValue: _gender,
                    onChanged: (value) {
                      setState(() {
                        _gender = value.toString();
                      });
                    },
                  ),
                  Text('남성'),
                  Radio(
                    value: '여성',
                    groupValue: _gender,
                    onChanged: (value) {
                      setState(() {
                        _gender = value.toString();
                      });
                    },
                  ),
                  Text('여성'),
                ],
              ),
              SizedBox(height: 20),
              // 생년월일 입력 필드
              TextFormField(
                controller: _birthController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: "생년월일",
                  suffixIcon: GestureDetector(
                    onTap: () {
                      picker.DatePicker.showDatePicker(context,
                        showTitleActions: true,
                        minTime: DateTime(1900, 1, 1),
                        maxTime: DateTime.now(),
                        theme: const picker.DatePickerTheme(
                          headerColor: Colors.orange,
                          backgroundColor: Colors.blue,
                          itemStyle: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                          doneStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 16)),
                        onConfirm: (date) {
                          var dateFormat = DateFormat('yyyy-MM-dd').format(date); // 형식을 yyyy-MM-dd로 설정
                          _birthController.text = dateFormat;
                        }, 
                        currentTime: DateTime.now(), 
                        locale: picker.LocaleType.ko
                      );
                    },
                    child: const Icon(Icons.calendar_month),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "생년월일을 입력하세요.";
                  }
                  return null;
                },
              ),

              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  minimumSize: const Size(double.infinity, 40.0),
                ),
                child: const Text("회원가입"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
