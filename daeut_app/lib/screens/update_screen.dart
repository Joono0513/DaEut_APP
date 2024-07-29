import 'package:flutter/material.dart';
import '../models/service.dart';
import '../models/service_api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UpdateScreen extends StatefulWidget {
  const UpdateScreen({super.key});

  @override
  State<UpdateScreen> createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {
  late int serviceNo;
  late Future<Service> _service;
  final _formKey = GlobalKey<FormState>();
  final _serviceNameController = TextEditingController();
  final _servicePriceController = TextEditingController();
  final _serviceContentController = TextEditingController();
  bool isCleanSelected = false;
  bool isWashSelected = false;
  bool isQuarantineSelected = false;
  bool isSecuritySelected = false;
  bool isEtcSelected = false;
  String? thumbnailPath;
  List<String> imagePaths = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final arguments = ModalRoute.of(context)!.settings.arguments;
    if (arguments != null) {
      serviceNo = arguments as int;
      _service = ServiceApi.getService(serviceNo);
      _service.then((service) {
        _serviceNameController.text = service.serviceName;
        _servicePriceController.text = service.servicePrice.toString();
        _serviceContentController.text = service.serviceContent;
        isCleanSelected = service.serviceCategory.contains('청소');
        isWashSelected = service.serviceCategory.contains('빨래');
        isQuarantineSelected = service.serviceCategory.contains('방역');
        isSecuritySelected = service.serviceCategory.contains('보안');
        isEtcSelected = service.serviceCategory.contains('기타');
        setState(() {});
      });
    } else {
      serviceNo = 0;
      _service = Future.error('No service number provided');
    }
  }

  @override
  void dispose() {
    _serviceNameController.dispose();
    _servicePriceController.dispose();
    _serviceContentController.dispose();
    super.dispose();
  }

  Future<void> _updateService() async {
    if (_formKey.currentState!.validate()) {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:8080/reservation/reservationUpdate'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'serviceNo': serviceNo,
          'serviceName': _serviceNameController.text,
          'servicePrice': int.parse(_servicePriceController.text),
          'serviceCategory': _getServiceCategory(),
          'serviceContent': _serviceContentController.text,
          'thumbnail': thumbnailPath,
          'images': imagePaths,
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('서비스가 성공적으로 업데이트되었습니다.')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('서비스 업데이트에 실패했습니다.')),
        );
      }
    }
  }

  String _getServiceCategory() {
    List<String> categories = [];
    if (isCleanSelected) categories.add('청소');
    if (isWashSelected) categories.add('빨래');
    if (isQuarantineSelected) categories.add('방역');
    if (isSecuritySelected) categories.add('보안');
    if (isEtcSelected) categories.add('기타');
    return categories.join(', ');
  }

  Future<void> _pickThumbnail() async {
    // 썸네일 선택 로직 추가
  }

  Future<void> _pickImages() async {
    // 설명 이미지 선택 로직 추가
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("서비스 수정"),
      ),
      body: FutureBuilder<Service>(
        future: _service,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No data found'));
          } else {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      controller: _serviceNameController,
                      decoration: const InputDecoration(labelText: '제목'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '제목을 입력해주세요';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _servicePriceController,
                      decoration: const InputDecoration(labelText: '가격'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '가격을 입력해주세요';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    const Text('카테고리'),
                    Wrap(
                      spacing: 8.0,
                      children: [
                        ChoiceChip(
                          label: const Text('청소'),
                          selected: isCleanSelected,
                          onSelected: (selected) {
                            setState(() {
                              isCleanSelected = selected;
                            });
                          },
                        ),
                        ChoiceChip(
                          label: const Text('빨래'),
                          selected: isWashSelected,
                          onSelected: (selected) {
                            setState(() {
                              isWashSelected = selected;
                            });
                          },
                        ),
                        ChoiceChip(
                          label: const Text('방역'),
                          selected: isQuarantineSelected,
                          onSelected: (selected) {
                            setState(() {
                              isQuarantineSelected = selected;
                            });
                          },
                        ),
                        ChoiceChip(
                          label: const Text('보안'),
                          selected: isSecuritySelected,
                          onSelected: (selected) {
                            setState(() {
                              isSecuritySelected = selected;
                            });
                          },
                        ),
                        ChoiceChip(
                          label: const Text('기타'),
                          selected: isEtcSelected,
                          onSelected: (selected) {
                            setState(() {
                              isEtcSelected = selected;
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _serviceContentController,
                      decoration: const InputDecoration(labelText: '내용'),
                      maxLines: 4,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '내용을 입력해주세요';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    const Text('썸네일'),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: _pickThumbnail,
                      child: const Text('썸네일 선택'),
                    ),
                    thumbnailPath != null
                        ? Image.network(thumbnailPath!, width: 250, height: 150)
                        : const Text('썸네일을 선택해주세요'),
                    const SizedBox(height: 10),
                    const Text('설명이미지'),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: _pickImages,
                      child: const Text('이미지 선택'),
                    ),
                    Wrap(
                      spacing: 8.0,
                      children: imagePaths
                          .map((path) => Image.network(path, width: 100, height: 100))
                          .toList(),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _updateService,
                      child: const Text('수정하기'),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
