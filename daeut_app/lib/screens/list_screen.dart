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

    var utf8Decoded = utf8.decode(response.bodyBytes);
    var jsonResponse = jsonDecode(utf8Decoded);

    var serviceListJson = jsonResponse['serviceList'];

    if (serviceListJson == null || serviceListJson.isEmpty) {
      return [];
    }

    return serviceListJson.map<service_model.Service>((json) {
      var service = service_model.Service.fromJson(json);

      return service_model.Service(
        serviceNo: service.serviceNo ?? 0,
        serviceName: service.serviceName ?? 'Unknown',
        serviceCategory: service.serviceCategory ?? 'Unknown',
        servicePrice: service.servicePrice ?? 0,
        serviceContent: service.serviceContent ?? '',
        averageRating: service.averageRating ?? 0,
        imageUrls: service.imageUrls ?? [],
        partner: service.partner ?? service_model.Partner(
          partnerNo: 0,
          partnerCareer: '',
          introduce: '',
          userName: '',
          thumbnailUrl: '',
        ),
      );
    }).toList();
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
                    child: service.imageUrls.isNotEmpty
                        ? Image.network(
                            service.imageUrls.first,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          )
                        : Container(color: Colors.grey),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      service.serviceName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text('${service.servicePrice}원'),
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
