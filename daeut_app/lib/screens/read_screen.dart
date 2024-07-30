import 'package:flutter/material.dart';
import '../models/service.dart';
import '../models/service_api.dart';

class ReadScreen extends StatefulWidget {
  const ReadScreen({super.key});

  @override
  State<ReadScreen> createState() => _ReadScreenState();
}

class _ReadScreenState extends State<ReadScreen> {
  late int serviceNo;
  late Future<Service> _service;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final arguments = ModalRoute.of(context)!.settings.arguments;
    if (arguments != null) {
      serviceNo = arguments as int;
      _service = ServiceApi.getService(serviceNo);
    } else {
      serviceNo = 0;
      _service = Future.error('No service number provided');
    }
  }

  void _editService() {
    Navigator.pushNamed(context, '/reservation/reservationUpdate', arguments: serviceNo);
  }

  void _deleteService() {
    // 서비스 삭제 로직 추가
    // 삭제 후 리스트 화면으로 이동
    // ServiceApi.deleteService(serviceNo).then((_) {
    //   Navigator.pushReplacementNamed(context, '/reservation');
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("서비스 조회"),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _editService,
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _deleteService,
          ),
        ],
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
            var service = snapshot.data!;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    service.serviceName,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: List.generate(service.averageRating.toInt(), (index) {
                      return const Icon(Icons.star, color: Colors.yellow);
                    }),
                  ),
                  const SizedBox(height: 8),
                  Text('카테고리: ${service.serviceCategory}'),
                  const SizedBox(height: 8),
                  Text('가격: ${service.servicePrice} 원'),
                  const SizedBox(height: 8),
                  Text(service.serviceContent),
                  const SizedBox(height: 16),
                  _buildImageSlider(service.imageUrls),
                  const SizedBox(height: 16),
                  _buildPartnerInfo(service.partner),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, "/reservation");
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      backgroundColor: Colors.blueAccent,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('바로 예약하기'),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      // addToCart(serviceNo);
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('장바구니 담기'),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildImageSlider(List<String> imageUrls) {
    return SizedBox(
      height: 300,
      child: imageUrls.isNotEmpty
          ? PageView.builder(
              itemCount: imageUrls.length,
              itemBuilder: (context, index) {
                return Image.network(
                  imageUrls[index],
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(child: Text('이미지를 불러올 수 없습니다.'));
                  },
                );
              },
            )
          : Center(child: const Text('이미지가 없습니다.')),
    );
  }

  Widget _buildPartnerInfo(Partner partner) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '파트너 소개',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(partner.thumbnailUrl.isNotEmpty
                  ? partner.thumbnailUrl
                  : 'https://via.placeholder.com/150'),
              radius: 40,
              onBackgroundImageError: (error, stackTrace) {
                print('Failed to load partner thumbnail: $error');
              },
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(partner.userName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text(partner.partnerCareer),
                Row(
                  children: List.generate(5, (index) {
                    return Icon(
                      Icons.star,
                      color: index < 4 ? Colors.yellow : Colors.grey,
                    );
                  }),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(partner.introduce),
      ],
    );
  }
}
