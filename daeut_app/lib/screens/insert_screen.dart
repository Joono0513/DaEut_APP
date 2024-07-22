import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class InsertScreen extends StatefulWidget {
  const InsertScreen({super.key});

  @override
  State<InsertScreen> createState() => _InsertScreenState();
}

class _InsertScreenState extends State<InsertScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  List<String> _selectedCategories = [];
  List<XFile>? _thumbnails = [];
  List<XFile>? _images = [];

  final ImagePicker _picker = ImagePicker();

  Future<void> insert() async {
    if (_formKey.currentState!.validate()) {
      var url = "http://10.0.2.2:8080/reservation/reservationInsert";
      var request = http.MultipartRequest('POST', Uri.parse(url));

      request.fields['serviceName'] = _titleController.text;
      request.fields['servicePrice'] = _priceController.text;
      request.fields['serviceCategory'] = _selectedCategories.join(',');
      request.fields['serviceContent'] = _contentController.text;

      if (_thumbnails!.isNotEmpty) {
        request.files.add(
          await http.MultipartFile.fromPath('thumbnail', _thumbnails!.first.path),
        );
      }

      for (var image in _images!) {
        request.files.add(await http.MultipartFile.fromPath('file', image.path));
      }

      try {
        var response = await request.send();

        if (response.statusCode == 200 || response.statusCode == 201) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('등록 성공!'),
              backgroundColor: Colors.blueAccent,
            ),
          );
          Navigator.pushReplacementNamed(context, "/reservation/list");
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('등록 실패...'),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      } catch (e) {
        print(e);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('에러: $e')),
        );
      }
    }
  }

  Future<void> _pickThumbnail() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _thumbnails = [pickedFile];
      });
    }
  }

  Future<void> _pickImages() async {
    final List<XFile>? pickedFiles = await _picker.pickMultiImage();
    if (pickedFiles != null) {
      setState(() {
        _images = pickedFiles;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("서비스 등록"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: '제목'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '제목을 입력하세요';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: '가격'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '가격을 입력하세요';
                  }
                  return null;
                },
              ),
              Wrap(
                spacing: 8.0,
                children: [
                  _buildCategoryChip('청소'),
                  _buildCategoryChip('빨래'),
                  _buildCategoryChip('방역'),
                  _buildCategoryChip('보안'),
                  _buildCategoryChip('기타', selected: true),
                ],
              ),
              TextFormField(
                controller: _contentController,
                decoration: const InputDecoration(labelText: '내용'),
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '내용을 입력하세요';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              _buildFilePicker(
                context,
                label: '썸네일',
                pickFile: _pickThumbnail,
                files: _thumbnails,
              ),
              const SizedBox(height: 10),
              _buildFilePicker(
                context,
                label: '설명이미지',
                pickFile: _pickImages,
                files: _images,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: insert,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                ),
                child: const Text('등록하기'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, "/reservation");
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                ),
                child: const Text('취소하기'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String label, {bool selected = false}) {
    return FilterChip(
      label: Text(label),
      selected: _selectedCategories.contains(label),
      onSelected: (bool isSelected) {
        setState(() {
          if (isSelected) {
            _selectedCategories.add(label);
          } else {
            _selectedCategories.remove(label);
          }
        });
      },
    );
  }

  Widget _buildFilePicker(BuildContext context,
      {required String label, required Function() pickFile, List<XFile>? files}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 16)),
        const SizedBox(height: 5),
        OutlinedButton(
          onPressed: pickFile,
          child: Text('첨부하기'),
        ),
        const SizedBox(height: 5),
        files != null && files.isNotEmpty
            ? Text('${files.length} files selected')
            : Text('No file selected'),
      ],
    );
  }
}
