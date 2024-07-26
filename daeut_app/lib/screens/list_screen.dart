 import 'dart:convert'; // Add this for jsonDecode
import 'package:daeut_app/models/service_request.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  List<ServiceRequest> _serviceList = [];

  @override
  void initState() {
    super.initState();
    getServiceList().then((result) {
      setState(() {
        _serviceList = result;
      });
    });
  }

  // 게시글 목록 데이터 요청
  Future<List<ServiceRequest>> getServiceList() async {
    var url = "http://10.0.2.2:8080/reservation";
    var response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      // UTF-8 디코딩
      var utf8Decoded = utf8.decode(response.bodyBytes);
      // JSON 디코딩
      var serviceList = jsonDecode(utf8Decoded);
      List<ServiceRequest> list = [];

      for (var item in serviceList) {
        list.add(ServiceRequest(
          serviceName: item['serviceName'],
          servicePrice: item['servicePrice'],
          serviceCategory: item['serviceCategory'],
          serviceContent: item['serviceContent'],
          thumbnailPath: item['thumbnailPath'],
          filePaths: item['filePaths'] != null ? List<String>.from(item['filePaths']) : [],
        ));
      }

      return list;
    } else {
      throw Exception('Failed to load service requests');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("서비스 예약하기"),
      ),
      body: Container(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,      // 열 개수
              crossAxisSpacing: 10.0, // 열 간격
              mainAxisSpacing: 10.0,  // 행 간격
            ),
            itemBuilder: (context, position) {
              final serviceRequest = _serviceList[position];
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
                color: Colors.grey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      serviceRequest.thumbnailPath,
                      width: 80,
                      height: 80,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 10,),
                    Text(
                      serviceRequest.serviceName,
                      style: const TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              );
            },
            itemCount: _serviceList.length,
          ),
        ),
      ),
    );
  }
}
