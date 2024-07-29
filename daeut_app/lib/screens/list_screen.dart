import 'dart:convert'; // Add this for jsonDecode
import 'package:daeut_app/models/service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  List<Service> _serviceList = [];

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
  Future<List<Service>> getServiceList() async {
    var url = "http://10.0.2.2:8080/reservation";
    var response = await http.get(Uri.parse(url));
    print(":::::: response - body ::::::");
    print(response.body);

    // UTF-8 디코딩
    var utf8Decoded = utf8.decode(response.bodyBytes);
    // JSON 디코딩
    var jsonResponse = jsonDecode(utf8Decoded);

    // 'serviceList' 키를 통해 리스트를 가져옴
    var serviceList = jsonResponse['serviceList'];

    // Null 및 빈 리스트 체크
    if (serviceList == null || serviceList.isEmpty) {
      return [];
    }

    List<Service> list = [];

    for (var item in serviceList) {
      if (item != null) {
        list.add(Service(
          serviceNo: item['serviceNo'],
          serviceCategory: item['serviceCategory'],
          serviceName: item['serviceName'],
          servicePrice: item['servicePrice'],
          serviceContent: item['serviceContent'],
          partnerNo: item['partnerNo'],
          thumbnailPath: item['thumbnailPath'],
          filePaths: item['filePaths'] != null ? List<String>.from(item['filePaths']) : [],
        ));
      }
    }
    print(list);
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('서비스 목록'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,       // 열 개수
            crossAxisSpacing: 10.0,  // 열 간격
            mainAxisSpacing: 10.0,   // 행 간격
          ),
          itemCount: _serviceList.length,
          itemBuilder: (context, index) {
            var service = _serviceList[index];
            return Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: service.thumbnailPath != null 
                        ? Image.network(
                            service.thumbnailPath!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          )
                        : Container(color: Colors.grey),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      service.serviceName ?? 'Unknown',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text('${service.servicePrice ?? '가격 정보 없음'}원'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
