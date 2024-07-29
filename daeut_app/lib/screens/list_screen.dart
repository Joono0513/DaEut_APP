import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:daeut_app/models/service.dart' as service_model;

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  List<service_model.Service> _serviceList = [];

  @override
  void initState() {
    super.initState();
    getServiceList().then((result) {
      setState(() {
        _serviceList = result;
      });
    });
  }

  Future<List<service_model.Service>> getServiceList() async {
    var url = "http://10.0.2.2:8080/reservation";
    var response = await http.get(Uri.parse(url));
    print(":::::: response - body ::::::");
    print(response.body);

    if (response.statusCode == 200) {
      var utf8Decoded = utf8.decode(response.bodyBytes);
      var jsonResponse = jsonDecode(utf8Decoded);

      var serviceListJson = jsonResponse['serviceList'];

      if (serviceListJson == null || serviceListJson.isEmpty) {
        return [];
      }

      return serviceListJson.map<service_model.Service>((json) {
        return service_model.Service.fromJson(json);
      }).toList();
    } else {
      print("Failed to load data");
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('서비스 목록'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,       // 열 개수
            crossAxisSpacing: 10.0,  // 열 간격
            mainAxisSpacing: 10.0,   // 행 간격
          ),
          itemCount: _serviceList.length,
          itemBuilder: (context, index) {
            var service = _serviceList[index];
            String imageUrl = service.fileNo != 0 
                ? "http://10.0.2.2:8080/file/img/${service.fileNo}"
                : 'https://via.placeholder.com/150'; // 기본 이미지 URL

            return GestureDetector(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/reservation/reservationRead',
                  arguments: service.serviceNo,
                );
              },
              child: Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.error);
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        service.serviceName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text('${service.servicePrice}원'),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(service.userName), // 유저 이름 추가
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
