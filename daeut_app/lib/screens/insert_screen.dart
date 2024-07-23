import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as path_provider;
import '../models/file_upload_response.dart';
import '../models/service_request.dart';

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
  XFile? _thumbnail;
  List<XFile> _images = [];

  final ImagePicker _picker = ImagePicker();

  Future<void> insert() async {
    if (_formKey.currentState!.validate()) {
      try {
        // 파일 업로드
        var thumbnailPath = await _uploadFile(_thumbnail, 'thumbnail');
        var imagePaths = await Future.wait(_images.map((image) => _uploadFile(image, 'image')));

        // 서비스 등록
        var serviceRequest = ServiceRequest(
          serviceName: _titleController.text,
          servicePrice: int.parse(_priceController.text),
          serviceCategory: _selectedCategories.join(','),
          serviceContent: _contentController.text,
          thumbnailPath: thumbnailPath,
          filePaths: imagePaths,
        );

        var url = "http://10.0.2.2:8080/reservation/reservationInsert";
        var response = await http.post(
          Uri.parse(url),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(serviceRequest.toJson()),
        );

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

  Future<String> _uploadFile(XFile? file, String fileType) async {
    if (file == null) return '';

    var url = "http://10.0.2.2:8080/file";
    var request = http.MultipartRequest('POST', Uri.parse(url));
    var fileToUpload = await _getFileFromXFile(file);

    request.fields['fileType'] = fileType; // 추가 데이터 전송
    request.files.add(
      await http.MultipartFile.fromPath('file', fileToUpload.path),
    );

    var response = await request.send();
    if (response.statusCode == 200 || response.statusCode == 201) {
      var responseData = await response.stream.bytesToString();
      var jsonResponse = jsonDecode(responseData);
      var fileUploadResponse = FileUploadResponse.fromJson(jsonResponse);
      return fileUploadResponse.filePath;
    } else {
      throw Exception('파일 업로드 실패');
    }
  }

  Future<File> _getFileFromXFile(XFile xfile) async {
    final directory = await path_provider.getApplicationDocumentsDirectory();
    final file = File(path.join(directory.path, xfile.name));
    return File(xfile.path).copy(file.path);
  }

  Future<void> _pickThumbnail() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _thumbnail = pickedFile;
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
                files: _thumbnail != null ? [_thumbnail!] : [],
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
          onPressed: () => pickFile(),
          child: const Text('첨부하기'),
        ),
        const SizedBox(height: 5),
        files != null && files.isNotEmpty
            ? Text('${files.length} files selected')
            : const Text('No file selected'),
      ],
    );
  }
}
